import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasFullfilledProphecy extends TargetConditionLiving {
    @override
    String name = "HasFullfilledProphecy";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Fullfilled Prophecy:</b><br>Target Entity must have died according to prophecy. (Pro Tip: p much only players do this and then get back up)<br><br>";
    @override
    String notDescText = "<b>Does NOT Have Fullfilled Prophecy:</b><br>Target Entity must not have died according to prophecy. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasFullfilledProphecy(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasFullfilledProphecy(scene);
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
        return !(item.prophecy == ProphecyState.FULLFILLED);
    }
}