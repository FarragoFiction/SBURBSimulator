import "../../SBURBSim.dart";
import 'dart:developer';
import "dart:html";
import '../../includes/lz-string.dart';
import "dart:convert";
/*
    Big Bads are serializable. Ironically not necessarily bad.

    form has name, list of scenes, check box for is bigBad and trigger conditions
 */

class BigBad extends NPC {
    static String BIGBADNAME = "BIGBADNAME";

    ///okay YES they are something CALLED a big bad, but until they wreck shit no venegence
  @override
  bool villain = false;
  BigBadForm form;
  String textIfNoStrife = "";
  String textIfYesStrife = "";
  String regularFrogText = "";
 String purpleFrogText = "";
 String pinkFrogText = "";
 String prologueText = "";



    //if any of these are true, the big bad is triggered. proccessed even if not active
  List<SerializableScene> startMechanisms = new List<SerializableScene>();
  //scenes list is like normal, but i assume they are all serializable




  @override
  String description = "What shows up in ShogunBot's BigBadBinder?";

  BigBad(String name, Session session) : super(name, session) {
        textIfNoStrife = "They search for them, but the villain is no where to be found.";
        textIfYesStrife = "This ends, now.  It is not hard to track down the villain. ";
  }

  String toDataString() {
      //print("data is ${toJSON()}");
      return  "$name$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
  }

  JSONObject toJSON() {
      //game entity will handle specibus and shit
      JSONObject json = super.toJSON();
      json["name"] = name;
      json["description"] = description;
      json["canStrife"] = canStrife.toString();
      json["unconditionallyImmortal"] = unconditionallyImmortal.toString();
      json["textIfNoStrife"] = textIfNoStrife;
      json["textIfYesStrife"] = textIfYesStrife;

      json["regularFrogText"] = regularFrogText;
      json["purpleFrogText"] = purpleFrogText;
      json["pinkFrogText"] = pinkFrogText;
      json["prologueText"] = prologueText;


      List<JSONObject> startSceneArray = new List<JSONObject>();
      for(Scene s in startMechanisms) {
          if(s is SerializableScene) startSceneArray.add(s.toJSON());
      }
      json["startMechanisms"] = startSceneArray.toString();

      List<JSONObject> sceneArray = new List<JSONObject>();
      for(Scene s in scenes) {
          if(s is SerializableScene) sceneArray.add(s.toJSON());
      }
      json["scenes"] = sceneArray.toString();


      List<JSONObject> stopSceneArray = new List<JSONObject>();
      for(Scene s in playerReactions) {
          if(s is SerializableScene) stopSceneArray.add(s.toJSON());
      }
      json["stopMechanisms"] = stopSceneArray.toString();

      return json;
  }

  void copyFromDataString(String data) {
     // print("copying from data: $data, looking for labelpattern: $labelPattern");
      super.copyFromDataString(data);
      String dataWithoutName = data.split("$labelPattern")[1];
      String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);
      //print("big bad raw json for ${data.split("$labelPattern")[0]} is $rawJSON");
      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      name = json["name"];
      description = json["description"];

      if(json["canStrife"] != "true") {
          canStrife = false;
      }

      if(json["unconditionallyImmortal"] == "true") {
          unconditionallyImmortal = true;
      }

      if(json["textIfNoStrife"] != null) {
          textIfNoStrife = json["textIfNoStrife"];
      }

      if(json["textIfYesStrife"] != null) {
          textIfYesStrife = json["textIfYesStrife"];
      }


      if(json["regularFrogText"] != null) {
          regularFrogText = json["regularFrogText"];
      }

      if(json["purpleFrogText"] != null) {
          purpleFrogText = json["purpleFrogText"];
      }

      if(json["pinkFrogText"] != null) {
          pinkFrogText = json["pinkFrogText"];
      }

      if(json["prologueText"] != null) {
          prologueText = json["prologueText"];
      }

     // print("done with name and description");

      String startScenesString = json["startMechanisms"];

      loadStartMechanisms(startScenesString);
     // print("done loading start mechanisms");

  }

  @override
    void copyFromDataStringTemplate(String data) {
        // print("copying from data: $data, looking for labelpattern: $labelPattern");
        super.copyFromDataStringTemplate(data);
        //dont do anything else, its just game entity stuff if its a template
    }


    void loadStartMechanisms(String weirdString) {
      //print("weird string is $weirdString");
        List<dynamic> what = jsonDecode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            SummonScene ss = new SummonScene(session);
            ss.gameEntity = this;
            ss.copyFromJSON(j);
            startMechanisms.add(ss);
        }
    }


  static BigBad fromDataString(String rawDataString, Session session) {
      BigBad ret = new BigBad("TEMPORARY", session);
      ret.copyFromDataString(rawDataString);
      //all big bads have at least these stats
      ret.heal();
      return ret;
  }

  void summonTriggered() {
      //UserTag previousTag = session.createDebugTag("CheckingBigBadSummon");

      //first summon scene to trigger has dibs
      for(SummonScene s in startMechanisms) {
          if(s.trigger(session.players)) {
              this.session.numScenes ++;
              s.renderContent(this.session.newScene(s.runtimeType.toString()));
              return;
          }
      }
      //previousTag.makeCurrent();
  }



  void syncForm() {
      print("going to sync with ${startMechanisms.length} start scenes and  ${scenes.length} action scenes and ${playerReactions.length} reaction scenes");
     form.syncDataBoxToBigBad();

  }

  void removeScene(SerializableScene scene) {
      String jsonString = scene.toJSON().toString();
      List<Scene> allScenes = new List<Scene>.from(startMechanisms);
      allScenes.addAll(scenes);
      allScenes.addAll(playerReactions);
      for(Scene s in allScenes) {
          if(s is SerializableScene) {
              if (s.toJSON().toString() == jsonString) {
                  startMechanisms.remove(s);
                  scenes.remove(s);
                  playerReactions.remove(s);
                  return;
              }
          }
      }
  }

  void drawForm(Element container) {
      form = new BigBadForm(this, container);
      form.drawForm();
  }



}


class BigBadForm {

    Element container;
    BigBad bigBad;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    TextAreaElement descElement;
    Element templateInfoElement;

    CheckboxInputElement strifableElement;
    CheckboxInputElement immortalElement;
    TextAreaElement strifableYesElement;
    TextAreaElement strifableNoElement;

    TextAreaElement pinkFrogElement;
    TextAreaElement purpleFrogElement;
    TextAreaElement regularFrogElement;
    TextAreaElement prologueElement;


    Element startSceneSection;
    Element sceneSection;
    Element stopSceneSection;


    BigBadForm(BigBad this.bigBad, Element parentContainer) {
        container = new DivElement();
        parentContainer.append(container);
    }

    void drawForm() {
        drawDataBox();
        drawName();
        drawDesc();
        syncTemplateInfo(); //it will draw tempalte
        drawStrifable();
        drawImmortal();
        drawAddStartButton();
        drawAddSceneButton();
        drawAddStopButton();
        drawTextBoxes();

    }

    void syncDataBoxToBigBad() {
        dataBox.value = bigBad.toDataString();
    }

    void drawTextBoxes() {

        /*
            TextAreaElement pinkFrogElement;
    TextAreaElement purpleFrogElement;
    TextAreaElement regularFrogElement;
    TextAreaElement prologueElement;
         */

        prologueElement = new TextAreaElement();
        LabelElement prologueLabel = new LabelElement()..text ="Prologue Text (if active on session creation)"..style.display="block";
        pinkFrogElement = new TextAreaElement();
        LabelElement pinkLabel = new LabelElement()..text ="Pink Frog Text"..style.display="block";
        purpleFrogElement = new TextAreaElement();
        LabelElement purpleLabel = new LabelElement()..text ="Purple Frog Text"..style.display="block";
        regularFrogElement = new TextAreaElement();
        LabelElement regularLabel = new LabelElement()..text ="Regular Frog Text"..style.display="block";

        DivElement first = new DivElement();
        DivElement second = new DivElement();
        DivElement third = new DivElement();
        DivElement fourth = new DivElement();


        second.append(regularLabel);
        second.append(regularFrogElement);

        first.append(prologueLabel);
        first.append(prologueElement);

        third.append(pinkLabel);
        third.append(pinkFrogElement);

        fourth.append(purpleLabel);
        fourth.append(purpleFrogElement);

        container.append(first);
        container.append(second);
        container.append(third);
        container.append(fourth);

        prologueElement.cols = 60;
        prologueElement.rows = 10;

        pinkFrogElement.cols = 60;
        pinkFrogElement.rows = 10;

        purpleFrogElement.cols = 60;
        purpleFrogElement.rows = 10;

        regularFrogElement.cols = 60;
        regularFrogElement.rows = 10;


        regularFrogElement.onInput.listen((Event e) {
            bigBad.regularFrogText = regularFrogElement.value;
            syncDataBoxToBigBad();
        });

        purpleFrogElement.onInput.listen((Event e) {
            bigBad.purpleFrogText = purpleFrogElement.value;
            syncDataBoxToBigBad();
        });

        pinkFrogElement.onInput.listen((Event e) {
            bigBad.pinkFrogText = pinkFrogElement.value;
            syncDataBoxToBigBad();
        });

        prologueElement.onInput.listen((Event e) {
            bigBad.prologueText = prologueElement.value;
            syncDataBoxToBigBad();
        });





    }

    void syncFormToBigBad() {
        nameElement.value = bigBad.name;
        descElement.value = bigBad.description;
        strifableYesElement.value = bigBad.textIfYesStrife;
        strifableNoElement.value = bigBad.textIfNoStrife;
        strifableElement.checked = bigBad.canStrife;
        immortalElement.checked = bigBad.unconditionallyImmortal;

        prologueElement.value = bigBad.prologueText;
        regularFrogElement.value = bigBad.regularFrogText;
        pinkFrogElement.value = bigBad.pinkFrogText;
        purpleFrogElement.value = bigBad.purpleFrogText;


        for(SummonScene s in bigBad.startMechanisms) {
            s.renderForm(startSceneSection);
        }

        for(SerializableScene s in bigBad.scenes) {
            s.renderForm(sceneSection);
        }

        for(StopScene s in bigBad.playerReactions) {
            s.renderForm(stopSceneSection);
        }
        syncDataBoxToBigBad();
        syncTemplateInfo();
    }

    void drawAddStartButton() {
        startSceneSection = new DivElement();
        startSceneSection.classes.add("startSection");
        startSceneSection.setInnerHtml("<h1>Start Scenes</h1><hr>Each Start Scene will have it's own flavor text and trigger conditions. A BigBad can only be summoned once per session.");
        startSceneSection.style.border = "1px solid black";
        startSceneSection.style.padding = "10px";
        ButtonElement button = new ButtonElement();
        button.text = "Add A Start Scene";
        container.append(startSceneSection);
        container.append(button);
        button.onClick.listen((Event e)
        {
            SummonScene summonScene = new SummonScene(bigBad.session);
            summonScene.gameEntity = bigBad;
            bigBad.startMechanisms.add(summonScene);
            summonScene.renderForm(startSceneSection);
            syncDataBoxToBigBad();
        });

        //render the ones the big bad starts with
        for(SummonScene s in bigBad.startMechanisms) {
            s.renderForm(startSceneSection);
        }

    }


    void drawAddStopButton() {
        print("drawing add stop mechanisms button");
        stopSceneSection = new DivElement();
        stopSceneSection.classes.add("stopSceneSection");
        stopSceneSection.setInnerHtml("<h1>Players Reactions</h1><hr>A Player Reaction Scene is locked to target the original owner of it. Any target conditions you add will be modifiers on top of that. Lands can only be targeted if the original owner is also targetable. (i.e. alive and available) It will be given to the players. (i.e. the players will quest to stop this big bad by doing these scenes)");
        stopSceneSection.style.border = "1px solid black";
        stopSceneSection.style.padding = "10px";
        ButtonElement button = new ButtonElement();
        button.text = "Add A Players Reaction";
        container.append(stopSceneSection);
        container.append(button);
        button.onClick.listen((Event e)
        {
            print("adding a stop scene");
            StopScene stopScene = new StopScene(bigBad.session);
            stopScene.originalOwner = bigBad;
            stopScene.gameEntity = bigBad; //will be replace dlater
            bigBad.playerReactions.add(stopScene);
            stopScene.renderForm(stopSceneSection);
            syncDataBoxToBigBad();
        });

        //render the ones the big bad starts with
        print ("trying to render existing stop mechanisms");
        for(StopScene s in bigBad.playerReactions) {
            print('rendering form for $s');
            s.renderForm(stopSceneSection);
        }

    }

    void drawAddSceneButton() {
        sceneSection = new DivElement();
        sceneSection.classes.add("actionSection");
        sceneSection.setInnerHtml("<h1>Action Scenes</h1><hr>Each Action Scene will have it's own flavor text and trigger conditions. As long as a BigBad is active (usually through a StartScene) they will do actions.");
        sceneSection.style.border = "1px solid black";
        sceneSection.style.padding = "10px";
        ButtonElement button = new ButtonElement();
        button.text = "Add An Action Scene (order added is order priority)";
        container.append(sceneSection);
        container.append(button);
        button.onClick.listen((Event e)
        {
            SerializableScene scene = new SerializableScene(bigBad.session);
            scene.gameEntity = bigBad;
            bigBad.scenes.add(scene);
            scene.renderForm(sceneSection);
            syncDataBoxToBigBad();
        });

        //render the ones the big bad starts with
        for(SerializableScene s in bigBad.scenes) {
            print("serializable scene $s");
            s.renderForm(sceneSection);
        }

    }

    void drawName() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = bigBad.name;
        subContainer.append(nameLabel);
        subContainer.append(nameElement);
        container.append(subContainer);

        nameElement.onInput.listen((Event e) {
            bigBad.name = nameElement.value;
            syncDataBoxToBigBad();
        });
    }

    //check box for canStrife and then two text areas for text on strife or strife avoidance
    void drawStrifable() {
        DivElement subContainer = new DivElement();
        container.append(subContainer);

        LabelElement label1 = new LabelElement()
            ..setInnerHtml(
                "Can BB be strifed at all? (Is it intangible, not yet here, too fast, etc)");
        strifableElement = new CheckboxInputElement();
        subContainer.append(label1);
        subContainer.append(strifableElement);
        strifableElement.checked = bigBad.canStrife;
        strifableElement.onChange.listen((Event e) {
            bigBad.canStrife = strifableElement.checked;
            syncDataBoxToBigBad();
        });

        LabelElement label2 = new LabelElement()
            ..setInnerHtml(
                "<br>When a Strife can't happen, what text is displayed as the reason? (You can leave this unmodified if the BB is expected to always be strifable).<br> ");
        strifableNoElement = new TextAreaElement();
        strifableNoElement.value = bigBad.textIfNoStrife;

        subContainer.append(label2);
        subContainer.append(strifableNoElement);
        strifableNoElement.cols = 60;
        strifableNoElement.rows = 10;
        strifableNoElement.onInput.listen((Event e) {
            bigBad.textIfNoStrife = strifableNoElement.value;
            syncDataBoxToBigBad();
        });


        LabelElement label3 = new LabelElement()
            ..setInnerHtml(
                "<br>When a Strife does happen, what text is displayed? (i.e. the BB is now tangible, slowed down by their weakenss, etc).<br> ");
        strifableYesElement = new TextAreaElement();
        strifableYesElement.value = bigBad.textIfYesStrife;
        strifableYesElement.cols = 60;
        strifableYesElement.rows = 10;
        subContainer.append(label3);
        subContainer.append(strifableYesElement);
        strifableYesElement.onInput.listen((Event e) {
            bigBad.textIfYesStrife = strifableYesElement.value;
            syncDataBoxToBigBad();
        });
    }



        //check box for canStrife and then two text areas for text on strife or strife avoidance
        void drawImmortal() {
            DivElement subContainer = new DivElement();
            container.append(subContainer);

            LabelElement label1 = new LabelElement()..setInnerHtml("Is BB Unconditionally Immortal?");
            immortalElement = new CheckboxInputElement();
            subContainer.append(label1);
            subContainer.append(immortalElement);
            immortalElement.checked = bigBad.unconditionallyImmortal;
            immortalElement.onChange.listen((Event e) {
                bigBad.unconditionallyImmortal = immortalElement.checked;
                syncDataBoxToBigBad();
            });
        }
    void drawDesc() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Card Description:";
        descElement = new TextAreaElement();
        descElement.value = bigBad.description;
        descElement.cols = 60;
        descElement.rows = 10;
        subContainer.append(nameLabel);
        subContainer.append(descElement);
        container.append(subContainer);

        descElement.onInput.listen((Event e) {
            bigBad.description = descElement.value;
            syncDataBoxToBigBad();
        });
    }

    void drawTemplate() {

        DivElement subContainer = new DivElement();
        DivElement nameLabel = new DivElement();
        AnchorElement templateCreator = new AnchorElement(href:"GameEntityCreation.html")..text = "Make Template Here"..target="_blank";
        subContainer.append(templateCreator);
        nameLabel.text = "Load Template (optional, for stats, items and fraymotifs):";
        TextAreaElement templateEle = new TextAreaElement();
        templateEle.value = "N/A";
        templateEle.cols = 60;
        templateEle.rows = 10;
        subContainer.append(nameLabel);
        subContainer.append(templateEle);
        templateInfoElement.append(subContainer);

        templateEle.onInput.listen((Event e) {
            bigBad.copyFromDataStringTemplate(templateEle.value);
            syncDataBoxToBigBad();
            syncTemplateInfo();
        });
    }

    void syncTemplateInfo() {
        if(templateInfoElement == null) {
            templateInfoElement = new DivElement();
            templateInfoElement.style.border = "1px solid black";
            templateInfoElement.style.padding = "5px";
            container.append(templateInfoElement);
        }
        templateInfoElement.text = ""; //clear

        Iterable<Stat> as = Stats.summarise;

        String statsString = "";
        for(Stat s in as) {
            statsString = "$statsString, ${s.name}: ${(bigBad.getStatHolder().getBase(s).round())}";
        }
        DivElement stats = new DivElement()..setInnerHtml("<b>Stats</b>: $statsString");


        templateInfoElement.append(stats);

        DivElement specibus = new DivElement()..setInnerHtml("<b>Specibus:</b> ${bigBad.specibus}");
        templateInfoElement.append(specibus);

        DivElement items = new DivElement()..setInnerHtml("<b>Sylladex</b>: ${bigBad.sylladex}");
        templateInfoElement.append(items);

        DivElement fraymotifs = new DivElement()..setInnerHtml("<b>Fraymotifs</b>: ${bigBad.fraymotifs}");
        templateInfoElement.append(fraymotifs);

        drawTemplate(); //redraw the box

    }

    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = bigBad.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((Event e) {
            print("syncing template to data box");
            try {
                bigBad.copyFromDataString(dataBox.value);
                syncFormToBigBad();
            }catch(e) {
                window.alert("something went wrong, $e");
                print(e);
            }
        });
        container.append(dataBox);
        ButtonElement manualSync = new ButtonElement()..text = "Manual Sync For Accurate DataString";
        manualSync.onClick.listen((e) {
            syncDataBoxToBigBad();
        });
        container.append(manualSync);

    }

}