import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsPassivePlayer extends TargetConditionLiving {
    @override
    String name = "IsPassivePlayer";

    @override
    String descText = "<b>Is Passive Player:</b><br>Target Entity must be a Passive Player (gives their aspect to others). <br><br>";
    @override
    String notDescText = "<b>Is NOT Passive Player:</b><br>Target Entity must NOT PASSIVE OR NOT be a Player. <br><br>";


    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsPassivePlayer(SerializableScene scene) : super(scene){
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsPassivePlayer(scene);
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
        return !(item is Player) && (item as Player).isActive();
    }
}