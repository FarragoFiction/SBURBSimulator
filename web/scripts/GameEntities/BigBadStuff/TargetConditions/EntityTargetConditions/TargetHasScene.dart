import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasScene extends TargetConditionLiving {
    @override
    String name = "HasScene";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>has Scene:</b><br>Target Entities must have scene:  <br><br>";
    @override
    String notDescText = "<bDoes NOT Have Scene:</b><br>Target Entities's must not have scene:<br><br>";


    TargetHasScene(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);
        input = new TextInputElement();
        input.value = importantWord;
        input.onChange.listen((Event e) {
            syncToForm();
        });
        me.append(input);
        syncFormToMe();
        //scene.syncForm();
        scene.syncForm();
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasScene(scene);
    }

    @override
    void syncFormToMe() {
        input.value = importantWord;
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantWord = input.value;
        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
        importantWord = json[TargetCondition.IMPORTANTWORD];
    }

    @override
    bool conditionForFilter(GameEntity item) {
        List<String> serializedScenes = new List<String>();
        for(Scene s in item.scenes) {
            if(s is SerializableScene) {
                SerializableScene ss = s as SerializableScene;
                if(ss.toDataString() == importantWord) {
                    return false; //you have it, don't remove
                }
            }
        }
        //couldn't find it
        return true;
    }
}