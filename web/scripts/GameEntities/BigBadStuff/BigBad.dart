import "../../SBURBSim.dart";
import "dart:html";
import '../../includes/lz-string.dart';
import "dart:convert";
/*
    Big Bads are serializable. Ironically not necessarily bad.

    form has name, list of scenes, check box for is bigBad and trigger conditions
 */

class BigBad extends NPC {
    static String BIGBADNAME = "BIGBADNAME";

  @override
  bool bigBad = true;
  BigBadForm form;

  //if any of these are true, the big bad is triggered. proccessed even if not active
  List<SerializableScene> startMechanisms = new List<SerializableScene>();
  //scenes list is like normal, but i assume they are all serializable

    //these are processed only if active, but separately from regular scenes. you can take an action and then be defeated
    List<SerializableScene> stopMechanisms = new List<SerializableScene>();


    String get labelPattern => ":___ ";

  @override
  String description = "What shows up in ShogunBot's BigBadBinder?";

  BigBad(String name, Session session) : super(name, session);

  String toDataString() {
      print("data is ${toJSON()}");
      return  "$name$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
  }

  JSONObject toJSON() {
      JSONObject json = new JSONObject();
      json["name"] = name;
      json["description"] = description;

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
      return json;
  }

  void copyFromDataString(String data) {
     // print("copying from data: $data, looking for labelpattern: $labelPattern");
      String dataWithoutName = data.split("$labelPattern")[1];
      String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);
      print("big bad raw json is $rawJSON");
      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      name = json["name"];
      description = json["description"];

      String startScenesString = json["startMechanisms"];
      loadStartMechanisms(startScenesString);

      String scenesString = json["scenes"];
      print("scenes string is $scenesString");
      loadScenes(scenesString);
  }


    void loadScenes(String weirdString) {
      if(weirdString == null) return;
        List<dynamic> what = JSON.decode(weirdString);
        for(dynamic d in what) {
            print("dynamic json thing for action scene is is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            SerializableScene ss = new SerializableScene(session);
            ss.gameEntity = this;
            ss.copyFromJSON(j);
            scenes.add(ss);
        }
    }

    void loadStartMechanisms(String weirdString) {
        List<dynamic> what = JSON.decode(weirdString);
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
      return ret;
  }

  void summonTriggered() {
      //first summon scene to trigger has dibs
      for(SummonScene s in startMechanisms) {
          if(s.trigger(session.players)) {
              this.session.numScenes ++;
              s.renderContent(this.session.newScene(s.runtimeType.toString()));
              return;
          }
      }
  }

  void syncForm() {
      print("going to sync with ${startMechanisms.length} start scenes");
     form.syncDataBoxToBigBad();

  }

  void removeScene(SerializableScene scene) {
      String jsonString = scene.toJSON().toString();
      List<Scene> allScenes = new List<Scene>.from(startMechanisms);
      allScenes.addAll(scenes);
      allScenes.addAll(stopMechanisms);
      for(Scene s in startMechanisms) {
          if(s is SerializableScene) {
              if (s.toJSON().toString() == jsonString) {
                  startMechanisms.remove(s);
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
    Element startSceneSection;
    Element sceneSection;


    BigBadForm(BigBad this.bigBad, Element parentContainer) {
        container = new DivElement();
        parentContainer.append(container);
    }

    void drawForm() {
        drawDataBox();
        drawName();
        drawDesc();
        drawAddStartButton();
        drawAddSceneButton();
    }

    void syncDataBoxToBigBad() {
        dataBox.value = bigBad.toDataString();
    }

    void syncFormToBigBad() {
        nameElement.value = bigBad.name;
        descElement.value = bigBad.description;

        for(SummonScene s in bigBad.startMechanisms) {
            s.renderForm(startSceneSection);
        }

        for(SerializableScene s in bigBad.scenes) {
            s.renderForm(sceneSection);
        }
        syncDataBoxToBigBad();
    }

    void drawAddStartButton() {
        startSceneSection = new DivElement();
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

    void drawAddSceneButton() {
        sceneSection = new DivElement();
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

    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = bigBad.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((Event e) {
            print("syncing template to data box");
            bigBad.copyFromDataString(dataBox.value);
            syncFormToBigBad();
        });
        container.append(dataBox);
    }

}