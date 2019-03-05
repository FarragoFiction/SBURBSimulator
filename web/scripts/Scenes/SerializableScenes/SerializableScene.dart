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
  Set<GameEntity> livingTargets = new Set<GameEntity>();
  //can include moons or the battlefield
  Set<Land> landTargets = new Set<Land>();



  //a valid target has all these conditions
  List<TargetConditionLiving> triggerConditionsLiving = new List<TargetConditionLiving>();
    List<TargetConditionLand> triggerConditionsLand = new List<TargetConditionLand>();
    List<EffectEntity> effectsForLiving = new List<EffectEntity>();
    List<EffectLand> effectsForLands = new List<EffectLand>();

    @override
    String name = "Generic Scene";

  SerializableScene(Session session) : super(session);

  void doAction() {
      //empty, subscenes can have complicated thigns here
  }

  String getHeader() {
      if(gameEntity is BigBad) return ">BigBadBullshit:";
      if(gameEntity.villain) return ">Villany is Afoot:";
      if(gameEntity is Carapace) return ">Carapace Capers:";
      return ">Shenanigans: ";
  }

  //note from jr 10/04/18, i'm doing this so the troll empress can do a thing to a land if she has an item
    //i think in MOST cases if you are targeting a land and have a single 'self' target, you wanna ignore it.
    //but if i'm wrong i can turn this off and all that will happen is the trollempress will go back to
    //roughing herself up, to get ready for her plan, which isn't like, terrible or anything.
  void ignoreSelfIfPrimarilyLandFocused() {
      if(targetOne) {
          if(livingTargets.length == 1 && livingTargets.first == gameEntity && landTargets.isNotEmpty) {
              livingTargets.clear();
          }
      }
  }

  @override
  void renderContent(Element div) {
      //session.logger.info("TEST BIG BAD: rendering content");
      ignoreSelfIfPrimarilyLandFocused();

      String displayText = "<br>${getHeader()} $flavorText";
      displayText =   displayText.replaceAll("$TARGET", "${getTargetNames()}");
      displayText =   displayText.replaceAll("$SCENE_OWNER", "${gameEntity.htmlTitleWithTip()}");




      myElement = new DivElement();
      div.append(myElement);
      myElement.setInnerHtml("$displayText",treeSanitizer: NodeTreeSanitizer.trusted,validator: new NodeValidatorBuilder()..allowElement("img"));

      ImageElement portrait;

      if(gameEntity is Carapace) {
          if(!doNotRender) {
              String extension = ".png";
              if(gameEntity.name.contains("Lord English") || gameEntity.name.contains("Hussie")) extension = ".gif";
              portrait = new ImageElement(
                  src: "images/BigBadCards/${(gameEntity as Carapace).initials
                      .toLowerCase()}$extension");
              portrait.onError.listen((e) {
                  portrait.src = "images/BigBadCards/default.gif";
              });
              portrait.style.width = "100px";
              portrait.style.backgroundColor = "grey";
              div.append(portrait);
          }
      }else if(gameEntity is BigBad) {
          if(!doNotRender) {
              String extension = ".png";
              if(gameEntity.name.contains("Lord English") || gameEntity.name.contains("Hussie")) extension = ".gif";
              portrait = new ImageElement(src: "images/BigBadCards/${gameEntity.name.toLowerCase().replaceAll(" ", "_")}$extension");

              portrait.onError.listen((e) {
                  portrait.src = "images/BigBadCards/default.gif";
              });
              portrait.style.width = "300px";
              portrait.style.backgroundColor = "grey";
              div.append(portrait);
          }
      }

      doEffects(); //automatic
      doAction(); //specific to subclass
      if(gameEntity.name == "Lawgun") {
          if(!doNotRender) {
              String extension = ".png";
              if(gameEntity.name.contains("Lord English") || gameEntity.name.contains("Hussie")) extension = ".gif";
              portrait.src = "images/BigBadCards/${gameEntity.name.toLowerCase().replaceAll(" ", "_")}$extension";

              portrait.onError.listen((e) {
                  portrait.src = "images/BigBadCards/default.gif";
              });

          }
      }
      //ANY SUB CLASSES ARE RESPONSIBLE FOR RENDERING CANVAS SHIT HERE, SO THEY CALL SUPER, THEN DO CANVAS
  }

    void removeCondition(TargetCondition c) {
        String jsonString = c.toJSON().toString();
        List<TargetCondition> allConditions = new List<TargetCondition>.from(triggerConditionsLiving);
        allConditions.addAll(triggerConditionsLand);
        for(TargetCondition s in allConditions) {
            if (s.toJSON().toString() == jsonString) {
                triggerConditionsLand.remove(s);
                triggerConditionsLiving.remove(s);
                return;
            }
        }
    }

    void removeEffect(ActionEffect e) {
        String jsonString = e.toJSON().toString();
        List<ActionEffect> allEffects = new List<ActionEffect>.from(effectsForLands);
        allEffects.addAll(effectsForLiving);
        for(ActionEffect s in allEffects) {
            if (s.toJSON().toString() == jsonString) {
                effectsForLands.remove(s);
                effectsForLiving.remove(s);
                return;
            }
        }
    }

  void doEffects() {
      //print("tick is ${session.numTicks} , doing effect for $gameEntity, scene is $name, chosen targets is $finalLivingTargets from all living of $livingTargets ");
      for(ActionEffect e in effectsForLands) {
          e.applyEffect();
      }

      for(ActionEffect e in effectsForLiving) {
          e.applyEffect();
      }
      gameEntity.available = false;
  }

  Set<GameEntity> get finalLivingTargets {
      if(livingTargets == null || livingTargets.isEmpty) return new Set<GameEntity>();
      if(targetOne) {
          return new Set<GameEntity>()..add(livingTargets.first);
      }else {
          return livingTargets;
      }
  }

    Set<Land> get finalLandTargets {
      if(landTargets == null || landTargets.isEmpty) return new Set<Land>();
        if(targetOne) {
            return new Set<Land>()..add(landTargets.first);
        }else {
            return landTargets;
        }
    }

    //if i some how have both, living target will be the one i pick.
    String getTargetNames() {
      if(livingTargets.isNotEmpty) {
          List<String> tmp = new List<String>();
          for(GameEntity t in finalLivingTargets) {
            tmp.add(t.htmlTitleWithTip());
          }
          return turnArrayIntoHumanSentence(new List<String>.from(tmp));
      }else {
          return turnArrayIntoHumanSentence(new List<Land>.from(finalLandTargets));
      }

  }

void syncForm() {
    form.syncDataBoxToScene();

}

  void renderForm(Element container) {
      print ("render form for scene");
      form = new SceneForm(this, container);
      form.drawForm();
  }

    String toDataString() {
        return  "$name$labelPattern${LZString.compressToEncodedURIComponent(toJSON().toString())}";
    }

    void copyFromDataString(String data) {
        //print("copying from data: $data, looking for labelpattern: $labelPattern");
        String dataWithoutName = data.split("$labelPattern")[1];
        //print("data without name is $dataWithoutName");

        String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);
        //print("raw json is $rawJSON");
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
       // print("effects string living is $effectsStringLiving");
        String effectsStringLand = json["effectsForLands"];

        loadEffectsLiving(effectsStringLiving);
        loadEffectsLand(effectsStringLand);
    }

    void loadEffectsLiving(String weirdString) {
      if(weirdString == null) return;
     // print('weird string is $weirdString');
        List<dynamic> what = jsonDecode(weirdString);
      //print('what is $what');

      for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
           // print("about to tc");
            ActionEffect tc = EffectEntity.fromJSON(j, this);
           // print("action effect is $tc");
            effectsForLiving.add(tc);
        }
    }

    void loadEffectsLand(String weirdString) {
        if(weirdString == null) return;
        List<dynamic> what = jsonDecode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            ActionEffect tc = EffectLand.fromJSON(j, this);
            effectsForLands.add(tc);
        }
    }




    void loadTriggerConditionsLand(String weirdString) {
        List<dynamic> what = jsonDecode(weirdString);

        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            TargetCondition tc = TargetConditionLand.fromJSON(j, this);
            triggerConditionsLand.add(tc);
        }
    }



    void loadTriggerConditionsLiving(String weirdString) {
        List<dynamic> what = jsonDecode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            TargetCondition tc = TargetConditionLiving.fromJSON(j, this);
            triggerConditionsLiving.add(tc);
        }

    }

    @override
    String toString() {
            return name;
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
      livingTargets = new Set<GameEntity>.from(session.activatedNPCS); //not all, just active
      //royalty exist
      if(session.derse != null) {
        if(session.derse.queen != null && !livingTargets.contains(session.derse.queen)) livingTargets.add(session.derse.queen);
        if(session.derse.king != null && !livingTargets.contains(session.derse.king)) livingTargets.add(session.derse.king);
      }

      if(session.prospit != null) {
         if(session.prospit.queen != null && !livingTargets.contains(session.prospit.queen)) livingTargets.add(session.prospit.queen);
          if(session.prospit.king != null && !livingTargets.contains(session.prospit.king)) livingTargets.add(session.prospit.king);
      }

      for(Player p in session.players) {
            if(p.active) {
                livingTargets.add(p);
                if(p.land != null) landTargets.add(p.land);
            }
      }

     //session.logger.info("i think active targets is $livingTargets");

      landTargets.addAll(session.moons);

      livingTargets = new Set<GameEntity>.from(shuffle(session.rand, new List<GameEntity>.from(livingTargets)));
      landTargets = new Set<Land>.from(shuffle(session.rand, new List<Land>.from(landTargets)));


      for(TargetConditionLiving tc in triggerConditionsLiving) {
          livingTargets = new Set<GameEntity>.from(tc.filter(new List<GameEntity>.from(livingTargets)));
          if(gameEntity.name.contains("Empress")) {
           // print("big bad is $gameEntity and scene is $name and living targets is $livingTargets");
          }
      }
      if(triggerConditionsLiving.isEmpty) livingTargets.clear();


      for(TargetConditionLand tc in triggerConditionsLand) {
          landTargets = new Set<Land>.from(tc.filter(new List<Land>.from(landTargets), finalLivingTargets));
      }
      if(triggerConditionsLand.isEmpty) landTargets.clear();

      //if you have conditions you MUSt meet them. period.
      if(triggerConditionsLiving.isNotEmpty && livingTargets.isEmpty) return false;
      if(triggerConditionsLand.isNotEmpty && landTargets.isEmpty) return false;


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
        print("drawing new scene form");
        drawDataBox();
        drawDeleteButton();
        drawName();
        drawFlavorText();
        drawTargetOne();
        drawAddTriggerConditionButton();
        drawAddActionEffectButton();

    }

    void syncDataBoxToScene() {
        print("trying to sync data box, owner is ${scene.gameEntity}");
        dataBox.value = scene.toDataString();
        if(scene.gameEntity is BigBad) {
            print("i'm owned by a big bad so syncing it too");
            (scene.gameEntity as BigBad).syncForm();
        }
    }

    void syncFormToScene() {
        print("syncing form to scene");
        nameElement.value = scene.name;
        flavorText.value = scene.flavorText;
        targetOneElement.checked = scene.targetOne;

        for (TargetCondition s in scene.triggerConditionsLiving) {
            print("rendering form for living condition ${s.name}");
            s.renderForm(targetLivingSection);
        }

        for (TargetCondition s in scene.triggerConditionsLand) {
            print("rendering form for land condition ${s.name}");
            s.renderForm(targetLandSection);
        }

        for (ActionEffect s in scene.effectsForLiving) {
            print("rendering form for living effect ${s.name}");
            s.renderForm(effectLivingSection);
        }

        for (ActionEffect s in scene.effectsForLands) {
            print("rendering form for land effect ${s.name}");
            s.renderForm(effectLandSection);
        }
        print("syncing data box to scene");
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
        if(scene.gameEntity != null) {
            ButtonElement delete = new ButtonElement();
            delete.text = "Remove Scene";
            delete.onClick.listen((e) {
                BigBad bigBad = scene.gameEntity as BigBad;
                //don't bother knowing where i am, just remove from all
                bigBad.removeScene(scene);
                container.remove();
                bigBad.syncForm();
            });
            container.append(delete);
        }
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
        print("drawing data box");
        dataBox = new TextAreaElement();
        dataBox.value = scene.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            try {
                scene.copyFromDataString(dataBox.value);
                print("loaded scene");
                syncFormToScene();
                print("synced form to scene");
            }catch(e) {
                scene.session.logger.info(e);
                window.alert("something went wrong! $e");
            }
        });
        container.append(dataBox);
    }

}