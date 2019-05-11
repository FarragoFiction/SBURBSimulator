import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasKilledAnything extends TargetConditionLiving {
    @override
    String name = "HasKilledAnything";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Killed:</b><br>Target Entity has killed, regardless of reason or what they killed. <br><br>";
    @override
    String notDescText = "<b>Has Never Killed:</b><br>Target Entity must have never killed anything ever. <br><br>";


    TargetHasKilledAnything(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasKilledAnything(scene);
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
        return item.playerKillCount == 0;
    }
}