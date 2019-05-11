import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasCrown extends TargetConditionLiving {
    static String ITEMAME = "CROWNNAME";
    @override
    String name = "HasCrown";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Crown:</b><br>Target Entity must be CROWNED (even if they can't use it). <br><br>";
    @override
    String notDescText = "<b>Has NO Crown:</b><br>Target Entity must NOT be CROWNED. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasCrown(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasCrown(scene);
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
        return item.crowned == null;
    }
}