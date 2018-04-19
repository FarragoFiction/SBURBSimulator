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

  //if any of these are true, the big bad is triggered.
  List<TriggerCondition> triggerConditions = new List<TriggerCondition>();

  String get labelPattern => "$name:___ ";

  @override
  String description = "What shows up in ShogunBot's BigBadBinder?";

  BigBad(String name, Session session) : super(name, session);

  String toDataString() {
      return  "$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
  }

  JSONObject toJSON() {
      JSONObject json = new JSONObject();
      json["name"] = name;
      json["description"] = description;
      return json;
  }

  void copyFromDataString(String data) {
      String dataWithoutName = data.split("$labelPattern")[1];
      String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);

      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      name = json["name"];
      description = json["description"];
  }


  static BigBad fromDataString(String rawDataString, session) {
      BigBad ret = new BigBad("TEMPORARY", session);
      ret.copyFromDataString(rawDataString);
      return ret;
  }

  void drawForm(Element container) {
      BigBadForm form = new BigBadForm(this, container);
      form.drawForm();
  }



}


class BigBadForm {

    Element container;
    BigBad bigBad;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    TextAreaElement descElement;

    BigBadForm(BigBad this.bigBad, Element this.container) {
    }

    void drawForm() {
        drawDataBox();
        drawName();
        drawDesc();
    }

    void syncDataBoxToBigBad() {
        dataBox.value = bigBad.toDataString();
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
        });
        container.append(dataBox);
    }

}