import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsFlippingOutAbout extends TargetConditionLiving {
    @override
    String name = "TargetIsFlippingOutAbout";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Flip Out Reason Contains:</b><br>Target Entities's is a player flipping out about:  <br><br>";
    @override
    String notDescText = "<b>Flip out reason Does NOT Contain:</b><br>Target Entities's is not a player or is not flipping out about:<br><br>";


    TargetIsFlippingOutAbout(SerializableScene scene) : super(scene){
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
        return new TargetIsFlippingOutAbout(scene);
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
        bool ret = true; //reject if not player
        if(item is Player) {
            if(item.flipOutReason != null) {
                ret = !item.flipOutReason.toLowerCase().contains(
                    importantWord.toLowerCase());
            }else {
                ret = true; //flipping out about nothing
            }
            //print("item is $item and is flipping out about ${item.flipOutReason} which is maybe $importantWord? $ret  (which will be flipped: $not)");
        }
        return ret;
    }
}