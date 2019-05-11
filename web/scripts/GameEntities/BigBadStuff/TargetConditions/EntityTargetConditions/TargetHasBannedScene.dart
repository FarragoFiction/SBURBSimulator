import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasBannedScene extends TargetConditionLiving {
    @override
    String name = "TargetHasBannedScene";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Scenes Banned Contains:</b><br>Target Entities's ban list must contain a scene named:  <br><br>";
    @override
    String notDescText = "<b>Scenes Banned does NOT Contain:</b><br>Target Entities's ban list must NOT contain a scene named:<br><br>";


    TargetHasBannedScene(SerializableScene scene) : super(scene){
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
        return new TargetHasBannedScene(scene);
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
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        bool ret = !item.bannedScenes.contains(importantWord);
        //print("item is $item and does it NOT contain $importantWord? $ret  (which will be flipped: $not)");
        return ret;
    }
}