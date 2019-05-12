import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasOpinionOfMe extends TargetConditionLiving {
    @override
    String name = "TargetHasOpinionOfMe";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Opinion Of Me:</b><br>Target Entity must be not be completely apathetic about you (players and carapaces are like that with each other). <br><br>";
    @override
    String notDescText = "<b>Does NOT Have Opinion Of Me:</b><br>Target Entity must be completely apathetic about you. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasOpinionOfMe(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasOpinionOfMe(scene);
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
        return item.getRelationshipWith(actor) == null;
    }
}