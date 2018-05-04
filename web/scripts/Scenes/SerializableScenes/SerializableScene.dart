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
abstract class  SerializableScene extends Scene {

    //things that can be replaced
    static String BIGBADNAME = BigBad.BIGBADNAME;
    static String TARGET = "TARGET";

    SceneForm form;

    String get labelPattern => ":___ ";


    //not all things have a target, subclasses without one won't bother

    //what do you try to target, used for drop down
    static String TARGETPLAYERS = "Players";
    static String TARGETCARAPACES = "Carapaces";
    static String TARGETDENIZENS = "Denizens";
    static String TARGETLANDS = "Lands";
    static String TARGETMOONS = "Moons";
    static String TARGETCONSORTS = "Consorts";
    static String TARGETGHOSTS = "Ghosts";
    static String TARGETDEADPLAYERS = "Dead Players";
    static String TARGETDEADCARAPACES = "Dead Carapaces";
    static String TARGETROBOTS = "Robots";
    static String TARGETDREAMSELVES = "Dream Selves";
    static String TARGETBIGBADS = "Big Bads";
    static String TARGETGODS = "Gods";
    static String TARGETMORTALS = "Mortals";

    //flavor text will not influence the actual actions going on, but will change how it is narratively
  String flavorText = "";
  List<GameEntity> livingTargets = new List<GameEntity>();
  //can include moons or the battlefield
  List<Land> landTargets = new List<Land>();

  //prefers land to living, otherwise first in list
  bool oneTarget;


  //a valid target has all these conditions
  List<TargetConditionLiving> triggerConditionsLiving = new List<TargetConditionLiving>();
    List<TargetConditionLand> triggerConditionsLand = new List<TargetConditionLand>();
  //TODO consider if i want a list of effects as well, might work to do things like "if summoned this way, have this effect"


  String name = "Generic Scene";

  SerializableScene(Session session) : super(session);

  void doAction();

  @override
  void renderContent(Element div) {
      String displayText = "$flavorText";
      displayText =   displayText.replaceAll("$BIGBADNAME", "${gameEntity.htmlTitle()}");
      //if i some how have both, living target will be the one i pick.
      //TODO replace shit.
      DivElement content = new DivElement();
      div.append(content);
      content.setInnerHtml(displayText);
      doAction();
      //ANY SUB CLASSES ARE RESPONSIBLE FOR RENDERING CANVAS SHIT HERE, SO THEY CALL SUPER, THEN DO CANVAS
  }

void syncForm() {
    form.syncDataBoxToScene();
    if(gameEntity is BigBad) {
        (gameEntity as BigBad).syncForm();
    }
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
        String rawJSON = LZString.decompressFromEncodedURIComponent(dataWithoutName);

        JSONObject json = new JSONObject.fromJSONString(rawJSON);
        copyFromJSON(json);
    }

    void copyFromJSON(JSONObject json) {
        name = json["name"];
        String triggerContionsStringLiving = json["triggerConditionsLiving"];
        String triggerContionsStringLand = json["triggerConditionsLand"];

        loadTriggerConditionsLiving(triggerContionsStringLiving);
        loadTriggerConditionsLand(triggerContionsStringLand);

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

        print(json);
        return json;
    }


  //all trigger conditions must be true for this to be true.
  @override
  bool trigger(List<Player> playerList) {
      landTargets.clear();
      livingTargets.clear();
      livingTargets = session.npcHandler.allEntities;
      landTargets = session.allLands;


      for(TargetConditionLiving tc in triggerConditionsLiving) {
          livingTargets = tc.filter(livingTargets);
      }

      for(TargetConditionLand tc in triggerConditionsLand) {
          landTargets = tc.filter(landTargets);
      }


      return landTargets.isNotEmpty || livingTargets.isNotEmpty;
  }
}



class SceneForm {

    Element container;
    SerializableScene scene;

    TextInputElement nameElement;
    TextAreaElement dataBox;
    TextAreaElement flavorText;


    SceneForm(SerializableScene this.scene, parentContainer) {
        container = new DivElement();
        container.style.border = "2px solid black";
        container.style.padding = "10px";
        container.style.marginTop = "10px";
        parentContainer.append(container);

    }

    void drawForm() {
        drawDataBox();
        drawDeleteButton();
        drawName();
        drawFlavorText();
        drawAddTriggerConditionButton();

    }

    void syncDataBoxToScene() {
        dataBox.value = scene.toDataString();
    }

    void syncFormToScene() {
        nameElement.value = scene.name;
        syncDataBoxToScene();
    }


    void drawAddTriggerConditionButton() {
        //trigger conditions know how to add their own damn selves

        TargetConditionLiving.drawSelectTriggerConditions(container, scene);
        TargetConditionLand.drawSelectTriggerConditions(container, scene);

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


    void drawFlavorText() {
        flavorText = new TextAreaElement();
        flavorText.value = scene.toDataString();
        flavorText.cols = 60;
        flavorText.rows = 10;
        flavorText.onChange.listen((e) {
            scene.flavorText = flavorText.value;
            syncFormToScene();
        });
        container.append(dataBox);
    }



    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = scene.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            scene.copyFromDataString(dataBox.value);
            syncFormToScene();
        });
        container.append(dataBox);
    }

}