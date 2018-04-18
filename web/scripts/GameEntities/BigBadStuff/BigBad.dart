import "../../SBURBSim.dart";
import "dart:html";
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

  BigBad(String name, Session session) : super(name, session);

  String toDataString() {
      //TODO use LZ compression
  }

  JSONObject toJSON() {
      JSONObject json = new JSONObject();
      json["name"] = name;
  }

  static BigBad fromJSON(String rawJSON, Session session) {
      JSONObject json = new JSONObject.fromJSONString(rawJSON);
      BigBad ret = new BigBad(json["name"], session);
      return ret;
  }

  static BigBad fromDataString(String rawDataString) {
      //TODO use LZ compression
  }

  void drawForm(Element container) {

      LabelElement nameLabel = new LabelElement();
      nameLabel.text = "Name:";
      TextInputElement nameElement = new TextInputElement();
      nameElement.value = name;
      container.append(nameLabel);
      container.append(nameElement);
  }

}