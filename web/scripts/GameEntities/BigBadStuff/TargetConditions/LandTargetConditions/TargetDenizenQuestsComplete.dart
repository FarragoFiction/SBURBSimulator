import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetDenizenQuestsComplete extends TargetConditionLand {
    @override
    String name = "DenizenQuestsComplete";

    Item crown;


    @override
    String descText = "<b>Denizen Quests Complete:</b><br>Target Land must have its Denizen placated or defeated.. <br><br>";
    @override
    String notDescText = "<b>Denizen Quests Incomplete:</b><br>Target Land must have its Denizen actively fucking shit up.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetDenizenQuestsComplete(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetDenizenQuestsComplete(scene);
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
        return !item.secondCompleted;
    }
}