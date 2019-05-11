import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsBigBad extends TargetConditionLiving {
    @override
    String name = "IsBigBad";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is BigBad:</b><br>Target Entity must an unspeakably powerful being from beyond your average session. <br><br>";
    @override
    String notDescText = "<b>Is NOT BigBad:</b><br>Target Entity must be NOT an unspeakably powerful being from beyond your average session. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsBigBad(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsBigBad(scene);
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
        return !(item is BigBad);
    }
}