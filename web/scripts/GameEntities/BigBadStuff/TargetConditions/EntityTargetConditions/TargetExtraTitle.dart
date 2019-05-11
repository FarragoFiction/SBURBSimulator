import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetExtraTitle extends TargetConditionLiving {
    @override
    String name = "ExtraTitleContains";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Title Contains:</b><br>Target Entities's dynamic Title must contain the word:  <br><br>";
    @override
    String notDescText = "<b>Title Does NOT Contain:</b><br>Target Entities's dynamic title must NOT contain the word:<br><br>";


    TargetExtraTitle(SerializableScene scene) : super(scene){
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
        return new TargetExtraTitle(scene);
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
        bool ret = !item.extraTitle.toLowerCase().contains(importantWord.toLowerCase());
        //print("item is $item and does it NOT contain $importantWord? $ret  (which will be flipped: $not)");
        return ret;
    }
}