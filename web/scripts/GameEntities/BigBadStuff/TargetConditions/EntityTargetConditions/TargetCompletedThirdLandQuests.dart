import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetCompletedThirdLandQuests extends TargetConditionLiving {
    @override
    String name = "HasCompletedAllLandQuests";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Completed All Land Quests:</b><br>Target Entity must be a player who has finished their land quests. <br><br>";
    @override
    String notDescText = "<b>Has Not Completed All Land Quests:</b><br>Target Entity must be either not a player, or a player who hasn't yet beaten their land. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetCompletedThirdLandQuests(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetCompletedThirdLandQuests(scene);
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
        if(item is Player) {
            if((item as Player).land != null && (item as Player).land.thirdCompleted) return false;
        }

        return true;
    }
}