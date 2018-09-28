import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetFinalQuestsComplete extends TargetConditionLand {
    @override
    String name = "Land Beaten";

    Item crown;


    @override
    String descText = "<b>Land Beaten:</b><br>Target Land must have no more quests remaining. <br><br>";
    @override
    String notDescText = "<b>Land Not Beaten:</b><br>Target Land must have at least some quests remaining.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetFinalQuestsComplete(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetFinalQuestsComplete(scene);
    }

    @override
    void syncFormToMe() {
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
    }

    @override
    bool conditionForFilter(Land item,Set<GameEntity> entities) {
        return !item.thirdCompleted;
    }
}