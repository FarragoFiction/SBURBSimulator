import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsInSessionWithTPK extends TargetConditionLiving {
    @override
    String name = "TargetIsInSessionWithTPK";

    @override
    String descText = "<b>TPK:</b><br>Entity must be in a session where all players are dead. <br><br>";
    @override
    String notDescText = "<b>No TPK:</b><br>Entity must be in a session where at least one plaeyr is alive. <br><br>";


    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsInSessionWithTPK(SerializableScene scene) : super(scene){
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsInSessionWithTPK(scene);
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
    bool conditionForFilter(GameEntity item) {
        List<GameEntity> living = findLiving(scene.session.players);
        return !(living.isEmpty);
    }
}