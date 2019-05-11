import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsMyLeader extends TargetConditionLiving {
    @override
    String name = "TargetIsMyLeader";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is My Leader:</b><br>Target Entity must be my party leader. (i.e. I am their companion) <br><br>";
    @override
    String notDescText = "<b>Is NOT my Leader:</b><br>Target Entity must be NOT be my party leader. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsMyLeader(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsMyLeader(scene);
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
        return !item.companionsCopy.contains(scene.gameEntity);
    }
}