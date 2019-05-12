import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class IHaveOpinionOfTarget extends TargetConditionLiving {
    @override
    String name = "IHaveOpinionOfTarget";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>I Have Opinion About</b>:</b><br>I must be not be completely apathetic about target (players and carapaces are like that with each other). <br><br>";
    @override
    String notDescText = "<b>I don't Have Opinion About:</b><br>I must be completely apathetic about target. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    IHaveOpinionOfTarget(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new IHaveOpinionOfTarget(scene);
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
        return actor.getRelationshipWith(item) == null;
    }
}