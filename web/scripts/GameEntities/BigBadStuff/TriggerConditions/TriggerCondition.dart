
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../../SBURBSim.dart";
import 'dart:html';
abstract class TriggerCondition {
    //need to do miins
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String IMPORTANTWORD = "importantWord";
    //could just be a carapace or a player I don't care
    SerializableScene scene;
    String importantWord;
    //definitely replace this.
    String name = "Generic Trigger";
    TriggerCondition(SerializableScene scene);

    //the keys for this are used for the form builder and the actions are called when it's time to replace words
    Map<String, Generator> replacements = new Map<String, Generator>();

    bool triggered();
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

    String replaceAll(String textWithShitToReplaceProbably) {
        for(String key in replacements.keys) {
            textWithShitToReplaceProbably = textWithShitToReplaceProbably.replaceAll("$key", "${replacements[key]()}");
        }
        return textWithShitToReplaceProbably;
    }


    TriggerCondition makeNewOfSameType();

    static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner, bool forAlive) {
        DivElement container = new DivElement();

        DivElement triggersSection = new DivElement();
        triggersSection.setInnerHtml("<h3>Trigger Conditions:</h3>ALL of these must be TRUE<br>");
        div.append(triggersSection);
        div.append(container);
        List<TriggerCondition> conditions;
        if(forAlive) {
            conditions = TriggerConditionLiving.listPossibleTriggers(owner);
        }else {
            conditions = TriggerConditionLand.listPossibleTriggers(owner);
        }
        SelectElement select = new SelectElement();
        for(TriggerCondition sample in conditions) {
            OptionElement o = new OptionElement();
            o.value = sample.name;
            o.text = sample.name;
            select.append(o);
        }

        ButtonElement button = new ButtonElement();
        button.text = "Add Trigger Condition";
        button.onClick.listen((e) {
            String type = select.options[select.selectedIndex].value;
            for(TriggerCondition tc in conditions) {
                if(tc.name == type) {
                    TriggerCondition newCondition = tc.makeNewOfSameType();
                    newCondition.scene = owner;
                    if(forAlive) {
                        owner.triggerConditionsLiving.add(newCondition);
                    }else {
                        owner.triggerConditionsLand.add(newCondition);
                    }
                    print("adding new condition to $owner");
                    //bigBad.triggerConditions.add(newCondition);
                    newCondition.renderForm(triggersSection);
                }
            }
        });

        container.append(select);
        container.append(button);

        //render the ones the big bad starts with
        List<TriggerCondition> all;
        if(forAlive) {
            all = owner.triggerConditionsLiving;
        }else {
            all = owner.triggerConditionsLand;
        }

        for (TriggerCondition s in all) {
            s.renderForm(triggersSection);
        }
        return select;
    }





}


//i filter living things
abstract class TriggerConditionLiving extends TriggerCondition {
  TriggerConditionLiving(SerializableScene scene) : super(scene);


  //need to figure out what type of trigger condition it is.
  static TriggerCondition fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<TriggerCondition> allConditions = listPossibleTriggers(scene);
      for(TriggerCondition tc in allConditions) {
          if(tc.name == name) {
              TriggerCondition ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TriggerConditionLiving> listPossibleTriggers(SerializableScene scene) {
      List<TriggerConditionLiving> ret = new List<TriggerCondition>();
      //ret.add(new ItemTraitTriggerCondition(scene));
      return ret;
  }


}

//i filter lands or moons or whatever
abstract class TriggerConditionLand extends TriggerCondition {
  TriggerConditionLand(SerializableScene scene) : super(scene);


  //need to figure out what type of trigger condition it is.
  static TriggerCondition fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      List<TriggerCondition> allConditions = listPossibleLandTriggers(scene);
      for(TriggerCondition tc in allConditions) {
          if(tc.name == name) {
              TriggerCondition ret = tc.makeNewOfSameType();
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TriggerConditionLand> listPossibleTriggers(SerializableScene scene) {
      List<TriggerConditionLand> ret = new List<TriggerConditionLand>();
      return ret;
  }


}
