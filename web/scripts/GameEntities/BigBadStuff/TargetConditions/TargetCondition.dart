
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../../SBURBSim.dart";
import 'dart:html';
abstract class TargetCondition {
    //need to do miins
    static String IMPORTANTWORD = "importantWord";
    //could just be a carapace or a player I don't care
    SerializableScene scene;
    String importantWord;
    //definitely replace this.
    String name = "Generic Trigger";
    TargetCondition(SerializableScene scene);



    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);

    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["name"] = name;
        return json;
    }

    TargetCondition makeNewOfSameType();

}


//i filter living things
abstract class TargetConditionLiving extends TargetCondition {
  TargetConditionLiving(SerializableScene scene) : super(scene);

  List<GameEntity> filter(List<GameEntity> list);

  static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner, Element triggersSection) {
      DivElement container = new DivElement();

      triggersSection.setInnerHtml("<h3>Entity Filters:</h3>Filters Applied In Order (So i suggest you pick the most agressive condition first)<br>");
      div.append(container);
      List<TargetCondition> conditions;

      conditions = TargetConditionLiving.listPossibleTriggers(owner);

      SelectElement select = new SelectElement();
      for(TargetCondition sample in conditions) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Living Target Condition";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(TargetCondition tc in conditions) {
              if(tc.name == type) {
                  TargetCondition newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.triggerConditionsLiving.add(newCondition);
                  print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      container.append(select);
      container.append(button);

      //render the ones the big bad starts with
      List<TargetCondition> all;
          all = owner.triggerConditionsLiving;

      for (TargetCondition s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



  //need to figure out what type of trigger condition it is.
  static TargetCondition fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<TargetCondition> allConditions = listPossibleTriggers(scene);
      for(TargetCondition tc in allConditions) {
          if(tc.name == name) {
              TargetCondition ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TargetConditionLiving> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLiving> ret = new List<TargetConditionLiving>();
      ret.add(new TargetIsAlive(scene));
      ret.add(new TargetIsDead(scene));
      ret.add(new TargetHasItemWithTrait(scene));
      ret.add(new TargetHasCrown(scene));
      ret.add(new TargetIsCarapace(scene));
      return ret;
  }


}

//i filter lands or moons or whatever
abstract class TargetConditionLand extends TargetCondition {
  TargetConditionLand(SerializableScene scene) : super(scene);

  List<Land> filter(List<Land> list);

  //need to figure out what type of trigger condition it is.
  static TargetCondition fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<TargetCondition> allConditions = listPossibleTriggers(scene);
      for(TargetCondition tc in allConditions) {
          if(tc.name == name) {
              TargetCondition ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TargetConditionLand> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLand> ret = new List<TargetConditionLand>();
      return ret;
  }

  static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner, Element triggersSection) {
      DivElement container = new DivElement();

      triggersSection.setInnerHtml("<h3>Land Filters:</h3>Filters Applied In Order (So i suggest you pick the most agressive condition first)<br>");
      div.append(container);
      List<TargetCondition> conditions;
      conditions = TargetConditionLand.listPossibleTriggers(owner);
      SelectElement select = new SelectElement();
      for(TargetCondition sample in conditions) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Land Target Condition";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(TargetCondition tc in conditions) {
              if(tc.name == type) {
                  TargetCondition newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                      owner.triggerConditionsLand.add(newCondition);
                  print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      container.append(select);
      container.append(button);

      //render the ones the big bad starts with
      List<TargetCondition> all;
      all = owner.triggerConditionsLand;

      for (TargetCondition s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



}
