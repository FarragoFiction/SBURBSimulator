
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
    bool not = false;
    CheckboxInputElement notElement;

    DivElement descElement;

    String descText = "is generic";
    String notDescText = "is NOT generic";

    String get desc {
        if(not) {
            return notDescText;
        }else {
            return descText;
        }
    }


    TargetCondition(SerializableScene scene);




    @override
    void renderForm(Element div) {
        descElement = new DivElement();
        div.append(descElement);
        syncDescToDiv();

        DivElement me = new DivElement();
        div.append(me);
        renderNotFlag(me);

        syncToForm();
    }


    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);

    void renderNotFlag(Element div) {
        DivElement subContainer = new DivElement();
        div.append(subContainer);
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Invert Target";
        notElement = new CheckboxInputElement();
        notElement.checked = scene.targetOne;

        subContainer.append(nameLabel);
        subContainer.append(notElement);
        notElement.append(subContainer);

        notElement.onChange.listen((e) {
            syncNotFlagToForm();
            scene.syncForm();
        });
    }

    void syncDescToDiv() {
        descElement.setInnerHtml(desc);
    }

    void syncNotFlagToForm() {
        if(notElement.checked) {
            not = true;
        }else {
            not = false;
        }
        syncDescToDiv();
    }

    void syncFormToNotFlag() {
        notElement.checked = not;

    }

    void copyNotFlagFromJSON(JSONObject json) {
        String notString = json["NOT"];
        if(notString == "true") not = true;
    }



    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["NOT"] = not.toString();
        json["name"] = name;
        return json;
    }

    TargetCondition makeNewOfSameType();

}


//i filter living things
abstract class TargetConditionLiving extends TargetCondition {
  TargetConditionLiving(SerializableScene scene) : super(scene);
  bool conditionForFilter(GameEntity item);


  List<GameEntity> filter(List<GameEntity> list) {
      if(not) {
          list.removeWhere((GameEntity item) => !conditionForFilter(item));

      }else {
          list.removeWhere((GameEntity item) => conditionForFilter(item));
      }
      return list;
  }

  static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner, Element triggersSection) {
      triggersSection.setInnerHtml("<h3>Entity Filters:   Applied In Order </h3><br>");
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
      button.text = "Add Entity Target Condition";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(TargetCondition tc in conditions) {
              if(tc.name == type) {
                  TargetCondition newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.triggerConditionsLiving.add(newCondition);
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

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
              ret.copyNotFlagFromJSON(json);
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TargetConditionLiving> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLiving> ret = new List<TargetConditionLiving>();
      ret.add(new TargetIsAlive(scene));
      ret.add(new TargetIsPlayer(scene));
      ret.add(new TargetIsClassPlayer(scene));
      ret.add(new TargetIsAspectPlayer(scene));
      ret.add(new TargetHasItemWithTrait(scene));
      ret.add(new TargetHasCrown(scene));
      ret.add(new TargetIsCarapace(scene));
      ret.add(new TargetIsGrimDark(scene));
      ret.add(new TargetIsSelf(scene));

      return ret;
  }


}

//i filter lands or moons or whatever
abstract class TargetConditionLand extends TargetCondition {
  TargetConditionLand(SerializableScene scene) : super(scene);


  bool conditionForFilter(Land item);


  List<Land> filter(List<Land> list) {
      if(not) {
          list.removeWhere((Land item) => !conditionForFilter(item));

      }else {
          list.removeWhere((Land item) => conditionForFilter(item));
      }
      return list;
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

  static List<TargetConditionLand> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLand> ret = new List<TargetConditionLand>();
      ret.add(new TargetIsNotDestroyed(scene));

      return ret;
  }

  static SelectElement drawSelectTriggerConditions(Element div, SerializableScene owner, Element triggersSection) {

      triggersSection.setInnerHtml("<h3>Land Filters: Applied In Order </h3><br>");
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
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

      //render the ones the big bad starts with
      List<TargetCondition> all;
      all = owner.triggerConditionsLand;

      for (TargetCondition s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



}
