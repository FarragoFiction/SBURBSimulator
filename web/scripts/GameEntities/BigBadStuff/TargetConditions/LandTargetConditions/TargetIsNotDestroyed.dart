import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsNotDestroyed extends TargetConditionLand {
    @override
    String name = "TargetIsNotDestroyed";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Not Destroyed:</b><br>Target Land must be intact <br><br>";
    @override
    String notDescText = "<b>Is Destroyed:</b><br>Target Land must be destroyed. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsNotDestroyed(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsNotDestroyed(scene);
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
    bool conditionForFilter(Land item,Set<GameEntity> entities) {
        return item.dead;
    }
}