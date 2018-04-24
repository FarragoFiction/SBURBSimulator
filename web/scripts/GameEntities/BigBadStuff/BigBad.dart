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
      return  "$name$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
  }

  JSONObject toJSON() {
      JSONObject json = new JSONObject();
      json["name"] = name;
      json["description"] = description;

      List<JSONObject> startSceneArray = new List<JSONObject>();
      for(Scene s in startMechanisms) {
          if(s is SerializableScene) startSceneArray.add((s as SerializableScene).toJSON());
      }
      json["startMechanisms"] = startSceneArray.toString();
      return json;
  }

  void copyFromDataString(String data) {
      print("copying from data: $data, looking for labelpattern: $labelPattern");
      String dataWithoutName = data.split("$labelPattern")[1];
      String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);

      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      name = json["name"];
      description = json["description"];

      String startScenesString = json["startMechanisms"];
      loadStartMechanisms(startScenesString);
  }

    void loadStartMechanisms(String weirdString) {
        List<dynamic> what = JSON.decode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            SummonScene ss = new SummonScene(session);
            ss.copyFromJSON(j);
            startMechanisms.add(ss);
        }
    }


  static BigBad fromDataString(String rawDataString, session) {
      BigBad ret = new BigBad("TEMPORARY", session);
      ret.copyFromDataString(rawDataString);
      return ret;
  }

  void syncForm() {
      print("going to sync with ${startMechanisms.length} start scenes");
     form.syncDataBoxToBigBad();

  }

  void removeScene(SerializableScene scene) {
      String jsonString = scene.toJSON().toString();
      List<Scene> allScenes = new List.from(startMechanisms);
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
      if(startMechanisms.isEmpty) {
          SummonScene defaultSummon = new SummonScene(session);
          defaultSummon.gameEntity = this;
          startMechanisms.add(defaultSummon);
      }
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

    BigBadForm(BigBad this.bigBad, Element parentContainer) {
        container = new DivElement();
        parentContainer.append(container);
    }

    void drawForm() {
        drawDataBox();
        drawName();
        drawDesc();
        drawAddStartButton();
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
        button.onClick.listen((e)
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

    void drawName() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = bigBad.name;
        subContainer.append(nameLabel);
        subContainer.append(nameElement);
        container.append(subContainer);

        nameElement.onInput.listen((e) {
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

        descElement.onInput.listen((e) {
            bigBad.description = descElement.value;
            syncDataBoxToBigBad();
        });
    }

    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = bigBad.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            bigBad.copyFromDataString(dataBox.value);
            syncFormToBigBad();
        });
        container.append(dataBox);
    }

}