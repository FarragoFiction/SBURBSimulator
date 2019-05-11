import "../../../SBURBSim.dart";
import 'dart:html';
/*
much like target conditions decide WHO a scene should effect
action effects decide what happens when a scene triggers.
 */
abstract class ActionEffect {
    SerializableScene scene;
    static String IMPORTANTWORD = "importantWord";
    static String IMPORTANTINT = "importantNumber";

    String name = "Generic Effect";
    //what gets deleted
    Element container;

    String  importantWord = "N/A";
    int  importantInt = 0;

    bool vriska = false;
    CheckboxInputElement vriskaElement;
    DivElement descElement;



    ActionEffect(SerializableScene scene);

    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();

    void copyFromJSON(JSONObject json) {
        // print("copying from json");
        importantWord = json[ActionEffect.IMPORTANTWORD];
        importantInt = (int.parse(json[ActionEffect.IMPORTANTINT]));
        copyVriskaFlagFromJSON(json);
    }

    void copyVriskaFlagFromJSON(JSONObject json) {
        String notString = json["VRISKA"];
        if(notString == "true") vriska = true;
    }

    void applyEffect();
    ActionEffect makeNewOfSameType();

    void setupContainer(DivElement div) {
        container = new DivElement();
        container.classes.add("conditionOrEffect");
        div.append(container);
        drawDeleteButton();
    }

    void drawDeleteButton() {
        if(scene != null) {
            ButtonElement delete = new ButtonElement();
            delete.text = "Remove Effect";
            delete.onClick.listen((e) {
                //don't bother knowing where i am, just remove from all
                scene.removeEffect(this);
                container.remove();
                scene.syncForm();
            });
            container.append(delete);
        }

        drawVriska();
    }

    void drawVriska() {
        if(this is EffectLand) return;
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Apply to Self Instead of Target";
        vriskaElement = new CheckboxInputElement();
        vriskaElement.checked = vriska;

        subContainer.append(nameLabel);
        subContainer.append(vriskaElement);
        container.append(subContainer);

        vriskaElement.onChange.listen((e) {
            syncVriskaForm();
            scene.syncForm();
        });
        syncVriskaForm();
    }

    void syncVriskaForm() {
        String text;
        if(descElement == null) {
            descElement = new DivElement();
            container.append(descElement);
        }
        if(vriskaElement.checked) {
            vriska = true;
            text = "(effects self)";
        }else {
            vriska = false;
            text = "(effects target or targets)";
        }
        descElement.text = text;
    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json[IMPORTANTWORD] = importantWord;
        json["name"] = name;
        json["VRISKA"] = vriska.toString();
        json[IMPORTANTINT] = "$importantInt";
        return json;
    }
}


//lands don't have stats and shit
abstract class EffectLand extends ActionEffect {
  EffectLand(SerializableScene scene) : super(scene);

  static List<EffectLand> listPossibleEffects(SerializableScene scene) {
      List<EffectLand> ret = new List<EffectLand>();
      ret.add(new InstaBlowUp(scene));
      ret.add(new ChangeMyStatLand(scene));
      ret.add(new MarkAllQuestsAsCompleteForLand(scene));
      ret.add(new MarkDenizenQuestsAsCompleteForLand(scene));
      ret.add(new MarkFirstQuestsAsCompleteForLand(scene));
      ret.add(new ChangeInhabitantsStat(scene));
      ret.add(new ChangeLandHealth(scene));
      ret.add(new MakeConsortsSay(scene));
      ret.add(new MakeConsortsInto(scene));
      ret.add(new MakeLandNamed(scene));
      ret.add(new MakeLandNamedStartWith(scene));
      ret.add(new Corrupt(scene));

      return ret;
  }

  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      //print("name is $name");
      List<EffectLand> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
         // print("is ${tc.name} the same as $name");
          if(tc.name == name) {
              ActionEffect ret = tc.makeNewOfSameType();
              //print("before i copy, ret is $ret");
              ret.importantWord = json[ActionEffect.IMPORTANTWORD];
              ret.copyFromJSON(json);
              //print("after i copy, ret is $ret");
              ret.scene = scene;
              return ret;
          }
      }
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      triggersSection.setInnerHtml("<h3>Land Effects: Applied In Order<br></h3>");
      List<ActionEffect> effects;
      effects = EffectLand.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectLand sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Land Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLands.add(newCondition);
                  //print("adding new condition to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLands;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }


  @override
  void applyEffect() {
        List<Land> targets = new List.from(scene.finalLandTargets);
        effectLands(targets);
  }

  void effectLands(List<Land> lands);


}

abstract class EffectEntity extends ActionEffect {
  EffectEntity(SerializableScene scene) : super(scene);


  static List<EffectEntity> listPossibleEffects(SerializableScene scene) {
      List<EffectEntity> ret = new List<EffectEntity>();
      ret.add(new InstaKill(scene));
      ret.add(new KillSleepingDreamSelf(scene));
      ret.add(new ChangeStat(scene));
      ret.add(new ChangeMyStat(scene));
      ret.add(new ChangeOpinionOfMe(scene));
      ret.add(new GiveMinion(scene));
      ret.add(new GiveFraymotif(scene));
      ret.add(new GiveItem(scene));
      ret.add(new AbdicateCrown(scene));
      ret.add(new GiveSpecibus(scene));
      ret.add(new GiveAction(scene));
      ret.add(new GiveThisAction(scene));
      ret.add(new BanScene(scene));
      ret.add(new UnBanScene(scene));
      ret.add(new RemoveAction(scene));
      ret.add(new RemoveThisAction(scene));
      ret.add(new DestroyItemNamed(scene));
      ret.add(new RemoveMinionNamed(scene));
      ret.add(new PickpocketItemNamed(scene));
      ret.add(new PickPocket(scene));
      ret.add(new Mug(scene));
      ret.add(new AntiMug(scene));
      ret.add(new GiveFrog(scene));
      ret.add(new KillFrog(scene));
      ret.add(new MarkFirstQuestsAsComplete(scene));
      ret.add(new MarkDenizenQuestsAsComplete(scene));
      ret.add(new MarkAllQuestsAsComplete(scene));
      ret.add(new PledgeLoyalty(scene));
      ret.add(new MakeMinion(scene));
      ret.add(new MakeGodDestined(scene));
      ret.add(new MakeUnGodDestined(scene));
      ret.add(new MakeBusy(scene));
      ret.add(new RenameTarget(scene));
      ret.add(new GiveExtraTitle(scene));
      ret.add(new GiveFlipOutReason(scene));
      ret.add(new MakeGodTier(scene));
      ret.add(new DestroySylladex(scene));
      ret.add(new GrimDarkCorruption(scene));
      ret.add(new CureGrimDarkCorruption(scene));
      ret.add(new MakeMurderMode(scene));
      ret.add(new UnMakeMurderMode(scene));
      ret.add(new DeclareVillain(scene));
      ret.add(new DeclareRedeemed(scene));
      ret.add(new MakeStrifable(scene));
      ret.add(new MakeUnStrifable(scene));
      ret.add(new StartStrife(scene));
      ret.add(new MakeInactive(scene));
      ret.add(new ModifySessionHealth(scene));
      ret.add(new MakeMortal(scene));
      ret.add(new MakeActiveProphecy(scene));
      ret.add(new MakeFullfilledProphecy(scene));
      ret.add(new MakeUnconditionallyImmortal(scene));

      return ret;
  }


  //need to figure out what type of trigger condition it is.
  static ActionEffect fromJSON(JSONObject json, SerializableScene scene) {
      String name = json["name"];
      //print("looking for name $name");

      List<EffectEntity> allConditions = listPossibleEffects(scene);
      for(ActionEffect tc in allConditions) {
          //print("is $name the same as ${tc.name}");

          if(tc.name == name) {
              //print("yes");
              ActionEffect ret = tc.makeNewOfSameType();
              //print("made new of same type");

              ret.copyFromJSON(json);
              ret.scene = scene;
              //print("ret is $ret for name $name");
              return ret;
          }
      }


      print("unknown action found, $name");
      throw("unknown action found, $name");
  }


  static SelectElement drawSelectActionEffects(Element div, SerializableScene owner, Element triggersSection) {
      triggersSection.setInnerHtml("<h3>Entity Effects: Applied In Order.</h3><br>");
      List<ActionEffect> effects;
      effects = EffectEntity.listPossibleEffects(owner);
      SelectElement select = new SelectElement();
      for(EffectEntity sample in effects) {
          OptionElement o = new OptionElement();
          o.value = sample.name;
          o.text = sample.name;
          select.append(o);
      }

      ButtonElement button = new ButtonElement();
      button.text = "Add Entity Effect";
      button.onClick.listen((e) {
          String type = select.options[select.selectedIndex].value;
          for(ActionEffect tc in effects) {
              if(tc.name == type) {
                  ActionEffect newCondition = tc.makeNewOfSameType();
                  newCondition.scene = owner;
                  owner.effectsForLiving.add(newCondition);
                  print("adding new effect to $owner");
                  //bigBad.triggerConditions.add(newCondition);
                  newCondition.renderForm(triggersSection);
              }
          }
      });

      triggersSection.append(select);
      triggersSection.append(button);

      //render the ones the big bad starts with
      List<ActionEffect> all;
      all = owner.effectsForLiving;

      for (ActionEffect s in all) {
          s.renderForm(triggersSection);
      }
      return select;
  }



  @override
  void applyEffect() {
      List<GameEntity> targets;
      if(vriska) {
          targets = new List<GameEntity>();
          targets.add(scene.gameEntity);
      }else {
          targets = new List.from(scene.finalLivingTargets);
      }
      effectEntities(scene.gameEntity,targets);
  }

  void effectEntities(GameEntity effector, List<GameEntity> entities);
}