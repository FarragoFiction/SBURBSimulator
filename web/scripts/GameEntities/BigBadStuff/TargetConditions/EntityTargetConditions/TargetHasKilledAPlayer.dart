import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasKilledAPlayer extends TargetConditionLiving {
    @override
    String name = "HasKilledAPlayer";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Killed A Player:</b><br>Target Entity has killed a Player before, regardless of reason. <br><br>";
    @override
    String notDescText = "<b>Has Never Killed a Player:</b><br>Target Entity must have never killed a Player. <br><br>";


    TargetHasKilledAPlayer(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasKilledAPlayer(scene);
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