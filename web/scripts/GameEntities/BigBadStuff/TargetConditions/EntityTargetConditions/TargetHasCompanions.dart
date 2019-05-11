import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasCompanions extends TargetConditionLiving {
    @override
    String name = "HasCompanions";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Companions:</b><br>Target Entity must have party members (consorts, leprechauns, etc). (does not target those members, just the party leader). <br><br>";
    @override
    String notDescText = "<b>Has NO Companions:</b><br>Target Entity must be NOT have any party members (consorts, leprechauns, etc). <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasCompanions(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasCompanions(scene);
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
        return item.companionsCopy.isEmpty;
    }
}