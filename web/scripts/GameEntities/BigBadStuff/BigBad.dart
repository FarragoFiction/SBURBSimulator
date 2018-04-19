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

  BigBad(String name, Session session) : super(name, session);

  String toDataString() {
      return  "$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
  }

  JSONObject toJSON() {
      JSONObject json = new JSONObject();
      json["name"] = name;
      return json;
  }

  void copyFromDataString(String data) {
      String dataWithoutName = data.split("$labelPattern")[1];
      String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);

      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      name = json["name"];
  }

  static BigBad fromJSON(String rawJSON, Session session) {
      BigBad ret = new BigBad("TEMPORARY", session);
      ret.copyFromDataString(rawJSON);
      return ret;
  }



  static BigBad fromDataString(String rawDataString) {
      //TODO use LZ compression
  }

  void drawForm(Element container) {
      BigBadForm form = new BigBadForm(this, container);

  }



}


class BigBadForm {

    Element container;
    BigBad bigBad;

    TextInputElement nameElement;
    TextAreaElement dataBox;

    BigBadForm(BigBad this.bigBad, Element this.container) {
        drawForm();
    }

    void drawForm() {
        drawName();
        drawDataBox();
    }

    void syncDataBoxToBigBad() {
        dataBox.value = bigBad.toDataString();
    }

    void drawName() {
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = bigBad.name;
        container.append(nameLabel);
        container.append(nameElement);

        nameElement.onInput.listen((e) {
            bigBad.name = nameElement.value;
            syncDataBoxToBigBad();
        });
    }

    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = bigBad.toDataString();
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            bigBad.copyFromDataString(dataBox.value);
        });
        container.append(dataBox);
    }

}