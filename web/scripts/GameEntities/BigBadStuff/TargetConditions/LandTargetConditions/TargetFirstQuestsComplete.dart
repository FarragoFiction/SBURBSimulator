import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetFirstQuestsComplete extends TargetConditionLand {
    @override
    String name = "FirstQuestsComplete";

    Item crown;


    @override
    String descText = "<b>First Quests Complete:</b><br>Target Land must have it's first quests completed. <br><br>";
    @override
    String notDescText = "<b>Is NOT Moon:</b><br>Target Land must be relatively unquested upon.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetFirstQuestsComplete(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetFirstQuestsComplete(scene);
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
        return !item.firstCompleted;
    }
}