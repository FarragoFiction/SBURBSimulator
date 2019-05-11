import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasEverDied extends TargetConditionLiving {
    @override
    String name = "HasEverDied";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Died:</b><br>Target Entity has defied the natural order of things and has died but yet lives. <br><br>";
    @override
    String notDescText = "<b>Has Never Died:</b><br>Target Entity must have never died and then resurrected. <br><br>";


    TargetHasEverDied(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasEverDied(scene);
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
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        if(item is Player) {
            if((item as Player).timesDied > 0) return false;
        }

        return true;
    }
}