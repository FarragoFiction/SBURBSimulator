
//everything inside of this must be true
/*
    Needs to be created via a form in BigBadBuilder but how?
 */
import "../../../SBURBSim.dart";
import 'dart:html';
abstract class TargetCondition {
    //need to do miins
    static String IMPORTANTWORD = "importantWord";
    static String IMPORTANTINT = "importantInt";

    //could just be a carapace or a player I don't care
    SerializableScene scene;
    String importantWord;
    int importantInt = 0;
    //definitely replace this.
    String name = "Generic Trigger";

    bool not = false;
    CheckboxInputElement notElement;

    DivElement container;
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
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);
        syncFormToMe();
        scene.syncForm();
    }


    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json) {
        //nothing to do
        importantWord = json[TargetCondition.IMPORTANTWORD];
        importantInt = int.parse(json[TargetCondition.IMPORTANTINT]);

    }

    void setupContainer(DivElement div) {
        print("setting up container for $name");
        container = new DivElement();
        container.classes.add("conditionOrEffect");
        div.append(container);
        print("appended container");
        drawDeleteButton();
        print("drew delete button");
        renderNotFlag(container);
        print("rendered not flag");
    }

    void drawDeleteButton() {
        if(scene != null) {
            ButtonElement delete = new ButtonElement();
            delete.text = "Remove Condition";
            delete.onClick.listen((e) {
                //don't bother knowing where i am, just remove from all
                scene.removeCondition(this);
                container.remove();
                scene.syncForm();
            });
            container.append(delete);
        }
    }

    void renderNotFlag(Element div) {
        DivElement subContainer = new DivElement();
        div.append(subContainer);
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Invert Target";
        notElement = new CheckboxInputElement();
        notElement.checked = scene.targetOne;

        subContainer.append(nameLabel);
        subContainer.append(notElement);
        container.append(subContainer);

        notElement.onChange.listen((e) {
            syncNotFlagToForm();
            scene.syncForm();
        });
    }

    void syncDescToDiv() {
        if(descElement == null) {
            descElement  = new DivElement();
            container.append(descElement);
        }
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
        print("after synging form to not flag not for $this, it is $not and checked is ${notElement.checked}");
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
        json[IMPORTANTINT] = "$importantInt";

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
                  print("adding new entity condition ${newCondition} to $owner, now its ${owner.triggerConditionsLiving}");
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
             // print("$name is found, time to copy not flag");
              TargetCondition ret = tc.makeNewOfSameType();
              ret.copyNotFlagFromJSON(json);
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
      //The below is for JR to recover from the corrupted strings caused by changing the name of shit
      /*
      TargetCondition ret = new TargetIsFromSessionWithABStat(scene);
      ret.copyNotFlagFromJSON(json);
      ret.copyFromJSON(json);
      ret.scene = scene;
      return ret;
      */
      print("Unknown condition found, $name");
      throw "Unknown condition found, $name";
  }

  static List<TargetConditionLiving> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLiving> ret = new List<TargetConditionLiving>();
      ret.add(new TargetIsAlive(scene));
      ret.add(new TargetIsPlayer(scene));
      ret.add(new TargetStatIsGreaterThanValue(scene));
      ret.add(new TargetStatIsGreaterThanMine(scene));
      ret.add(new MyStatIsGreaterThanValue(scene));
      ret.add(new TargetIsFinalPlayer(scene));
      ret.add(new TargetIsClassPlayer(scene));
      ret.add(new TargetIsAspectPlayer(scene));
      ret.add(new TargetIsPassivePlayer(scene));
      ret.add(new TargetIsActivePlayer(scene));
      ret.add(new TargetHasInterestCategory(scene));
      ret.add(new TargetHasItemWithTrait(scene));
      ret.add(new TargetIsWasted(scene));
      ret.add(new TargetIsTrickster(scene));
      ret.add(new TargetIsDreamSelf(scene));
      ret.add(new TargetIsSelf(scene));
      ret.add(new TargetIsDoomed(scene));
      ret.add(new TargetHasTimeClones(scene));
      ret.add(new TargetHasCrown(scene));
      ret.add(new IAmCrowned(scene));
      ret.add(new TargetIsCarapace(scene));
      ret.add(new TargetIsGrimDark(scene));
      ret.add(new TargetIsMurderMode(scene));
      ret.add(new TargetIsGodTier(scene));
      ret.add(new TargetHasGodDestiny(scene));
      ret.add(new TargetIsLeader(scene));
      ret.add(new TargetIsStrifable(scene));
      ret.add(new TargetIsUnconditionallyImmortal(scene));
      ret.add(new TargetIsRandom(scene));
      ret.add(new TargetIsFromSessionWithABStat(scene));
      ret.add(new TargetIsCompanion(scene));
      ret.add(new TargetHasCompanions(scene));
      ret.add(new TargetIsVillain(scene));
      ret.add(new TargetEntityNameContains(scene));
      ret.add(new TargetEntitySpriteNameContains(scene));
      ret.add(new TargetExtraTitle(scene));
      ret.add(new TargetHasScene(scene));

      ret.add(new TargetIsBigBad(scene));
      ret.add(new TargetHasFrog(scene));
      ret.add(new TargetHasPurpleFrog(scene));
      ret.add(new TargetHasKilledAnything(scene));
      ret.add(new TargetHasKilledAPlayer(scene));
      ret.add(new TargetHasEverDied(scene));
      ret.add(new TargetIsFromProspit(scene));
      ret.add(new TargetIsFromDerse(scene));
      ret.add(new TargetIsTrollWithBloodColor(scene));
      ret.add(new TargetCompletedFirstQuests(scene));
      ret.add(new TargetCompletedDenizenQuests(scene));
      ret.add(new TargetCompletedThirdLandQuests(scene));



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
              ret.copyNotFlagFromJSON(json);
              ret.copyFromJSON(json);
              ret.scene = scene;
              return ret;
          }
      }
  }

  static List<TargetConditionLand> listPossibleTriggers(SerializableScene scene) {
      List<TargetConditionLand> ret = new List<TargetConditionLand>();
      ret.add(new TargetIsNotDestroyed(scene));
      ret.add(new TargetIsMyLand(scene));
      ret.add(new IAmCrownedForLand(scene));
      ret.add(new TargetIsFromSessionWithABStatForLand(scene));
      ret.add(new TargetIsCorrupt(scene));
      ret.add(new TargetNameContains(scene));
      ret.add(new TargetHasConsort(scene));
      ret.add(new TargetHasSmell(scene));
      ret.add(new TargetHasSound(scene));
      ret.add(new TargetHasFeel(scene));
      ret.add(new TargetIsMoon(scene));
      ret.add(new TargetHPIs(scene));
      ret.add(new TargetIsProspit(scene));
      ret.add(new TargetIsDerse(scene));
      ret.add(new TargetIsRandomLand(scene));
      ret.add(new TargetFirstQuestsComplete(scene));
      ret.add(new TargetDenizenQuestsComplete(scene));
      ret.add(new TargetFinalQuestsComplete(scene));



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



class StatAmount {
    String name;
    int amount;

    StatAmount(String this.name, int this.amount);

    void addToMap(Map<int, StatAmount> map) {
        map[amount] = this;
    }

    static Map<int, StatAmount> getAllStats() {
        return getGodStatsBad()..addAll(getMortalStatsBad())..addAll(getMortalStatsGood())..addAll(getGodStatsGood());
    }

    static Map<int, StatAmount> getAllPostiveStats() {
        return getMortalStatsGood()..addAll(getGodStatsGood());
    }

    static Map<int, StatAmount> getAllNegativeStats() {
       return getMortalStatsBad()..addAll(getGodStatsBad());
    }

    static Map<int, StatAmount> getMortalStatsGood() {
        Map<int, StatAmount> ret = new Map<int, StatAmount>();
        new StatAmount("Tiny",13)..addToMap(ret);
        new StatAmount("Low",130)..addToMap(ret);
        new StatAmount("Medium",1300)..addToMap(ret);
        new StatAmount("High",13000)..addToMap(ret);
        return ret;
    }

    static Map<int, StatAmount> getGodStatsGood() {
        Map<int, StatAmount> ret = new Map<int, StatAmount>();
        new StatAmount("Planetary",130000)..addToMap(ret);
        new StatAmount("Galactic",1300000)..addToMap(ret);
        new StatAmount("Cosmic",13000000)..addToMap(ret);
        return ret;
    }

    static Map<int, StatAmount> getMortalStatsBad() {
        Map<int, StatAmount> ret = new Map<int, StatAmount>();
        new StatAmount("Pathetic",-13000)..addToMap(ret);
        new StatAmount("Shitty",-1300)..addToMap(ret);
        new StatAmount("Bad",-130)..addToMap(ret);
        new StatAmount("Barely Bad",-13)..addToMap(ret);
        return ret;
    }

    static Map<int, StatAmount> getGodStatsBad() {
        Map<int, StatAmount> ret = new Map<int, StatAmount>();
        new StatAmount("Irredeemable",-13000000)..addToMap(ret);
        new StatAmount("Cursed",-1300000)..addToMap(ret);
        new StatAmount("Fucked",-130000)..addToMap(ret);
        return ret;
    }
}