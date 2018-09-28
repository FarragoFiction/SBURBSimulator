import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsDerse extends TargetConditionLand {
    @override
    String name = "IsDerse";

    Item crown;


    @override
    String descText = "<b>Is Derse:</b><br>Target Land must be Derse <br><br>";
    @override
    String notDescText = "<b>Is NOT Derse:</b><br>Target Entity must not be Derse.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsDerse(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsDerse(scene);
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
        return item != scene.session.derse;
    }
}