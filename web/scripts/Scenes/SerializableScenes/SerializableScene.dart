import "../../SBURBSim.dart";
import 'dart:html';
import '../../includes/lz-string.dart';
import "dart:convert";

/**
 * Serializable Scenes are similar to Life Sim.
 *
 * Each sub class of this is a different ACTION (destroy, corrupt, etc).
 *
 * ALL Serializable Scenes have a FLAVOR TEXT section. Subclasses can replace the default
 * text, but it's recomended that instances of them set their own.
 *
 * sub classes define what valid targets are for them
 * if a sub class overrides the trigger, it should be to make sure the ACTION on a TARGET
 * is actually possible (i.e. there are any carapaces living remainging)
 */
class  SerializableScene extends Scene {


    Element myElement;

    static String TARGET = "TARGET_NAME_OR_NAMES";
    static String SCENE_OWNER = "SCENE_OWNER_NAME";


    SceneForm form;
    //if this is set i only poke at the first valid target, not all valid targets
    bool targetOne = false;

    String get labelPattern => ":___ ";


    bool posedAsATeamAlready = false;

    //not all things have a target, subclasses without one won't bother

    //flavor text will not influence the actual actions going on, but will change how it is narratively
  String flavorText = "Describe what happens in this scene in human words, based on what it targets and what it does to the targets. You can add a script tag to refer to the target or targets, but everything else should be your own words, including the Big Bads name.";
  List<GameEntity> livingTargets = new List<GameEntity>();
  //can include moons or the battlefield
  List<Land> landTargets = new List<Land>();



  //a valid target has all these conditions
  List<TargetConditionLiving> triggerConditionsLiving = new List<TargetConditionLiving>();
    List<TargetConditionLand> triggerConditionsLand = new List<TargetConditionLand>();
    List<EffectEntity> effectsForLiving = new List<EffectEntity>();
    List<EffectLand> effectsForLands = new List<EffectLand>();

  String name = "Generic Scene";

  SerializableScene(Session session) : super(session);

  void doAction() {
      //empty, subscenes can have complicated thigns here
  }

  @override
  void renderContent(Element div) {
      //session.logger.info("TEST BIG BAD: rendering content");

      String displayText = "<br>>BigBadBullshit: $flavorText";
      displayText =   displayText.replaceAll("$TARGET", "${getTargetNames()}");
      displayText =   displayText.replaceAll("$SCENE_OWNER", "${gameEntity.htmlTitle()}");

      myElement = new DivElement();
      div.append(myElement);
      myElement.setInnerHtml(displayText);
      doEffects(); //automatic
      doAction(); //specific to subclass
      //ANY SUB CLASSES ARE RESPONSIBLE FOR RENDERING CANVAS SHIT HERE, SO THEY CALL SUPER, THEN DO CANVAS
  }

  void doEffects() {
      print("doing effect for $gameEntity, effects for living is $effectsForLiving, $effectsForLands");
      for(ActionEffect e in effectsForLands) {
          e.applyEffect();
      }

      for(ActionEffect e in effectsForLiving) {
          e.applyEffect();
      }
      gameEntity.available = false;
  }

  List<GameEntity> get finalLivingTargets {
      if(targetOne) {
          return <GameEntity>[livingTargets.first];
      }else {
          return livingTargets;
      }
  }

    List<Land> get finalLandTargets {
        if(targetOne) {
            return <Land>[landTargets.first];
        }else {
            return landTargets;
        }
    }

    //if i some how have both, living target will be the one i pick.
    String getTargetNames() {
      if(livingTargets.isNotEmpty) {
          return turnArrayIntoHumanSentence(finalLivingTargets);
      }else {
          return turnArrayIntoHumanSentence(finalLandTargets);
      }

  }

void syncForm() {
    form.syncDataBoxToScene();

}

  void renderForm(Element container) {
      form = new SceneForm(this, container);
      form.drawForm();
  }

    String toDataString() {
        return  "$name$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
    }

    void copyFromDataString(String data) {
        print("copying from data: $data, looking for labelpattern: $labelPattern");
        String dataWithoutName = data.split("$labelPattern")[1];
        print("data without name is $dataWithoutName");

        String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);
        print("raw json is $rawJSON");
        JSONObject json = new JSONObject.fromJSONString(rawJSON);
        copyFromJSON(json);
    }

    void copyFromJSON(JSONObject json) {
        name = json["name"];
        if(json["targetOne"] == "true") targetOne = true;
        flavorText = json["flavorText"];
        //print("name is $name and flavortext is $flavorText");
        String triggerContionsStringLiving = json["triggerConditionsLiving"];
        String triggerContionsStringLand = json["triggerConditionsLand"];

        loadTriggerConditionsLiving(triggerContionsStringLiving);
        loadTriggerConditionsLand(triggerContionsStringLand);


        String effectsStringLiving = json["effectsForLiving"];
        print("effects string living is $effectsStringLiving");
        String effectsStringLand = json["effectsForLands"];

        loadEffectsLiving(effectsStringLiving);
        loadEffectsLand(effectsStringLand);
    }

    void loadEffectsLiving(String weirdString) {
      if(weirdString == null) return;
      print('weird string is $weirdString');
        List<dynamic> what = JSON.decode(weirdString);
      print('what is $what');

      for(dynamic d in what) {
            print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            print("about to tc");
            ActionEffect tc = EffectEntity.fromJSON(j, this);
            print("action effect is $tc");
            effectsForLiving.add(tc);
        }
    }

    void loadEffectsLand(String weirdString) {
        if(weirdString == null) return;
        List<dynamic> what = JSON.decode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            ActionEffect tc = EffectLand.fromJSON(j, this);
            effectsForLands.add(tc);
        }
    }

    void loadTriggerConditionsLand(String weirdString) {
        List<dynamic> what = JSON.decode(weirdString);

        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            TargetCondition tc = TargetConditionLand.fromJSON(j, this);
            triggerConditionsLand.add(tc);
        }
    }

    void loadTriggerConditionsLiving(String weirdString) {
        List<dynamic> what = JSON.decode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            TargetCondition tc = TargetConditionLiving.fromJSON(j, this);
            triggerConditionsLiving.add(tc);
        }

    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json["name"] = name;
        json["flavorText"] = flavorText;

        json["targetOne"] = targetOne.toString();

        List<JSONObject> triggerCondtionsArrayLiving = new List<JSONObject>();
        List<JSONObject> triggerCondtionsArrayLand = new List<JSONObject>();

        for(TargetCondition s in triggerConditionsLiving) {
            triggerCondtionsArrayLiving.add(s.toJSON());
        }

        for(TargetCondition s in triggerConditionsLand) {
            triggerCondtionsArrayLand.add(s.toJSON());
        }
        //print("${triggerCondtionsArray.length} triggerConditions were serialized, ${triggerCondtionsArray}");
        json["triggerConditionsLiving"] = triggerCondtionsArrayLiving.toString();
        json["triggerConditionsLand"] = triggerCondtionsArrayLand.toString();


        List<JSONObject> livingEffectsArray = new List<JSONObject>();
        List<JSONObject> landEffectsArray = new List<JSONObject>();

        for(ActionEffect s in effectsForLiving) {
            livingEffectsArray.add(s.toJSON());
        }

        for(ActionEffect s in effectsForLands) {
            landEffectsArray.add(s.toJSON());
        }
        //print("${triggerCondtionsArray.length} triggerConditions were serialized, ${triggerCondtionsArray}");
        json["effectsForLiving"] = livingEffectsArray.toString();
        json["effectsForLands"] = landEffectsArray.toString();

        return json;
    }


  //all trigger conditions must be true for this to be true.
  @override
  bool trigger(List<Player> playerList) {
      //session.logger.info("TEST BIG BAD: checking triggers");
      posedAsATeamAlready = false;
      landTargets.clear();
      livingTargets.clear();
      livingTargets = new List<GameEntity>.from(session.activatedNPCS); //not all, just active
      //TODO should i also get party members for those npcs? otherwise can't get brain ghosts and robots and the like
      livingTargets.addAll(session.players);
      landTargets = session.allLands;

      livingTargets = shuffle(session.rand, livingTargets);
      landTargets = shuffle(session.rand, landTargets);


      for(TargetConditionLiving tc in triggerConditionsLiving) {
          livingTargets = tc.filter(livingTargets);
      }
      if(triggerConditionsLiving.isEmpty) livingTargets.clear();


      for(TargetConditionLand tc in triggerConditionsLand) {
          landTargets = tc.filter(landTargets);
      }
      if(triggerConditionsLand.isEmpty) landTargets.clear();


      return landTargets.isNotEmpty || livingTargets.isNotEmpty;
  }
}



class SceneForm {

    Element container;
    SerializableScene scene;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    TextAreaElement flavorText;
    CheckboxInputElement targetOneElement;

    Element targetLivingSection;
    Element targetLandSection;
    Element effectLivingSection;
    Element effectLandSection;


    SceneForm(SerializableScene this.scene, parentContainer) {
        container = new DivElement();
        container.classes.add("SceneDiv");

        parentContainer.append(container);

    }

    void drawForm() {
        drawDataBox();
        drawDeleteButton();
        drawName();
        drawFlavorText();
        drawTargetOne();
        drawAddTriggerConditionButton();
        drawAddActionEffectButton();

    }

    void syncDataBoxToScene() {
        dataBox.value = scene.toDataString();
        if(scene.gameEntity is BigBad) {
            (scene.gameEntity as BigBad).syncForm();
        }
    }

    void syncFormToScene() {
        nameElement.value = scene.name;
        flavorText.value = scene.flavorText;
        targetOneElement.checked = scene.targetOne;

        for (TargetCondition s in scene.triggerConditionsLiving) {
            s.renderForm(targetLivingSection);
        }

        for (TargetCondition s in scene.triggerConditionsLand) {
            s.renderForm(targetLandSection);
        }

        for (ActionEffect s in scene.effectsForLiving) {
            s.renderForm(effectLivingSection);
        }

        for (ActionEffect s in scene.effectsForLands) {
            s.renderForm(effectLandSection);
        }
        syncDataBoxToScene();
    }


    void drawAddTriggerConditionButton() {
        //trigger conditions know how to add their own damn selves
        DivElement tmp = new DivElement();
        tmp.classes.add("filterSection");
        targetLandSection = new DivElement();
        targetLivingSection = new DivElement();
        tmp.append(targetLivingSection);
        tmp.append(targetLandSection);
        container.append(tmp);

        TargetConditionLiving.drawSelectTriggerConditions(container, scene, targetLivingSection);
        TargetConditionLand.drawSelectTriggerConditions(container, scene, targetLandSection);

    }

    void drawAddActionEffectButton() {
        DivElement tmp = new DivElement();
        tmp.classes.add("effectSection");
        effectLandSection = new DivElement();
        effectLivingSection = new DivElement();

        tmp.append(effectLivingSection);
        tmp.append(effectLandSection);
        container.append(tmp);

        //action effects know how to add their own damn selves
        EffectEntity.drawSelectActionEffects(container, scene,effectLivingSection);
        EffectLand.drawSelectActionEffects(container, scene,effectLandSection);

    }


    void drawDeleteButton() {
        ButtonElement delete = new ButtonElement();
        delete.text = "Remove Scene";
        delete.onClick.listen((e) {
            BigBad bigBad = scene.gameEntity as BigBad;
            //don't bother knowing where i am, just remove from all
            print("big bad has ${ bigBad.startMechanisms.length} start mechanisms. are any me? ${ bigBad.startMechanisms.contains(this)}");
            bigBad.removeScene(scene);
            container.remove();
            bigBad.syncForm();
        });
        container.append(delete);
    }

    void drawName() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Name:";
        nameElement = new TextInputElement();
        nameElement.value = scene.name;
        subContainer.append(nameLabel);
        subContainer.append(nameElement);
        container.append(subContainer);

        nameElement.onInput.listen((e) {
            scene.name = nameElement.value;
            syncDataBoxToScene();
        });
    }

    void drawTargetOne() {
        DivElement subContainer = new DivElement();
        LabelElement nameLabel = new LabelElement();
        nameLabel.text = "Target One Valid Target (vs target All Valid Targets):";
        targetOneElement = new CheckboxInputElement();
        targetOneElement.checked = scene.targetOne;

        subContainer.append(nameLabel);
        subContainer.append(targetOneElement);
        container.append(subContainer);

        targetOneElement.onChange.listen((e) {
            if(targetOneElement.checked) {
                scene.targetOne = true;
            }else {
                scene.targetOne = false;
            }
            syncDataBoxToScene();
        });

    }


    void drawFlavorText() {
        flavorText = new TextAreaElement();
        flavorText.value = scene.flavorText;
        flavorText.cols = 60;
        flavorText.rows = 10;
        flavorText.onInput.listen((e) {
            scene.flavorText = flavorText.value;
            syncDataBoxToScene();
        });

        DivElement buttonDiv = new DivElement();
        ButtonElement button = new ButtonElement();
        button.text = "Append Target Name(s)";
        button.onClick.listen((e) {
            flavorText.value = "${flavorText.value} ${SerializableScene.TARGET}";
            scene.flavorText = flavorText.value;
            syncDataBoxToScene();
        });
        buttonDiv.append(button);

        ButtonElement button2 = new ButtonElement();
        button2.text = "Append Scene Owner Name";
        button2.onClick.listen((e) {
            flavorText.value = "${flavorText.value} ${SerializableScene.SCENE_OWNER}";
            scene.flavorText = flavorText.value;
            syncDataBoxToScene();
        });
        buttonDiv.append(button2);
        container.append(flavorText);
        container.append(buttonDiv);
    }



    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = scene.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            try {
                scene.copyFromDataString(dataBox.value);
                syncFormToScene();
            }catch(e) {
                scene.session.logger.info(e);
                window.alert("something went wrong! $e");
            }
        });
        container.append(dataBox);
    }

}