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



    //subclasses can override this to have different valid targets
    //this builds the drop down for the forms
    List<String> get validTargets => <String>[TARGETPLAYERS, TARGETGODS, TARGETMORTALS,TARGETCARAPACES, TARGETDENIZENS, TARGETLANDS, TARGETMOONS, TARGETBIGBADS,TARGETCONSORTS, TARGETGHOSTS, TARGETROBOTS, TARGETDREAMSELVES, TARGETDEADPLAYERS, TARGETDEADCARAPACES];

    //flavor text will not influence the actual actions going on, but will change how it is narratively
  List<String> flavorText = <String>["$BIGBADNAME does a thing to $TARGET in the first flavor","$BIGBADNAME does a thing to $TARGET in the second flavor","$BIGBADNAME does a thing to $TARGET in the third flavor"];
  GameEntity livingTarget;
  //can include moons or the battlefield
  Land landTarget;

  //player, land, carapace, etc.
  String targetType;

  //everything in this list must be true for this scene to hit
  List<TriggerCondition> triggerConditions = new List<TriggerCondition>();
  //TODO consider if i want a list of effects as well, might work to do things like "if summoned this way, have this effect"


  String name = "Generic Scene";

  SerializableScene(Session session) : super(session);

  void doAction();

  @override
  void renderContent(Element div) {
      String displayText = rand.pickFrom(flavorText);
      displayText =   displayText.replaceAll("$BIGBADNAME", "${gameEntity.htmlTitle()}");
      //if i some how have both, living target will be the one i pick.
      if(livingTarget != null) displayText =   displayText.replaceAll("$TARGET", "${livingTarget.htmlTitle()}");
      if(landTarget != null) displayText =   displayText.replaceAll("$TARGET", "${landTarget.name}");

      DivElement content = new DivElement();
      div.append(content);
      content.setInnerHtml(displayText);
      //ANY SUB CLASSES ARE RESPONSIBLE FOR RENDERING CANVAS SHIT HERE, SO THEY CALL SUPER, THEN DO CANVAS
  }

  void pickTarget() {
      throw("TODO: map string target to a thing i'm looking for.");
  }

    void syncForm() {
      print("$name is syncing form, it has ${triggerConditions.length} triggers and it's game entity is $gameEntity");
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
        String triggerContionsString = json["triggerConditions"];
        loadTriggerConditions(triggerContionsString);
    }

    void loadTriggerConditions(String weirdString) {
        List<dynamic> what = JSON.decode(weirdString);
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            TriggerCondition tc = TriggerCondition.fromJSON(j, this);
            triggerConditions.add(tc);
        }
    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        json["name"] = name;
        List<JSONObject> triggerCondtionsArray = new List<JSONObject>();
        for(TriggerCondition s in triggerConditions) {
            triggerCondtionsArray.add(s.toJSON());
        }
        print("${triggerCondtionsArray.length} triggerConditions were serialized, ${triggerCondtionsArray}");
        json["triggerConditions"] = triggerCondtionsArray.toString();
        print(json);
        return json;
    }


  //all trigger conditions must be true for this to be true.
  @override
  bool trigger(List<Player> playerList) {
      for(TriggerCondition tc in triggerConditions) {
          if(!tc.triggered()) return false;
      }
      return true;
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
        drawAddTriggerConditionButton();

    }

    void syncDataBoxToScene() {
        dataBox.value = scene.toDataString();
    }

    void syncFormToBigBad() {
        nameElement.value = scene.name;
        syncDataBoxToScene();
    }


    void drawAddTriggerConditionButton() {
        //trigger conditions know how to add their own damn selves

        TriggerCondition.drawSelectTriggerConditions(container, scene);
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



    void drawDataBox() {
        dataBox = new TextAreaElement();
        dataBox.value = scene.toDataString();
        dataBox.cols = 60;
        dataBox.rows = 10;
        dataBox.onChange.listen((e) {
            print("syncing template to data box");
            scene.copyFromDataString(dataBox.value);
            syncFormToBigBad();
        });
        container.append(dataBox);
    }

}