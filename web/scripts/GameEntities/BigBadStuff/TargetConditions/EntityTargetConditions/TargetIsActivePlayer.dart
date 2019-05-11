import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsActivePlayer extends TargetConditionLiving {
    @override
    String name = "IsActivePlayer";

    @override
    String descText = "<b>Is Active Player:</b><br>Target Entity must be an Active Player (uses their aspect directly). <br><br>";
    @override
    String notDescText = "<b>Is NOT Active Player:</b><br>Target Entity must NOT Active OR NOT be a Player. <br><br>";


    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsActivePlayer(SerializableScene scene) : super(scene){
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsActivePlayer(scene);
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
        return !(item is Player) && !(item as Player).isActive();
    }
}