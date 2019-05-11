import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
//NOTE FROM 10/5/18 JR, YOU CANT TEST FOR TPK CUZ THAT ENDS A SESSION

class TargetIsFinalPlayer extends TargetConditionLiving {
    @override
    String name = "IsFinalPlayer";

    @override
    String descText = "<b>Is Final Player:</b><br>Target Entity must be the last player left alive. <br><br>";
    @override
    String notDescText = "<b>Is NOT Final Player:</b><br>Target Entity must NOT be the lone survivor of the Players (could even be not a player). <br><br>";


    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsFinalPlayer(SerializableScene scene) : super(scene){
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsFinalPlayer(scene);
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

    //NOTE FROM 10/5/18 JR, YOU CANT TEST FOR TPK CUZ THAT ENDS A SESSION
    @override
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        List<GameEntity> living = findLiving(scene.session.players);
        return !(living.contains(item) && living.length == 1);
    }
}