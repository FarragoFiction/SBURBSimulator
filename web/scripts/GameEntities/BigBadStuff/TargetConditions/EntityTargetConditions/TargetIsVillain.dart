import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsVillain extends TargetConditionLiving {
    @override
    String name = "IsVillain";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Villain:</b><br>Target Entity must be responsible for terrible crimes. <br><br>";
    @override
    String notDescText = "<b>Is NOT Villain:</b><br>Target Entity must be NOT responsible for terrible crimes. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsVillain(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsVillain(scene);
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
        return !item.villain;
    }
}