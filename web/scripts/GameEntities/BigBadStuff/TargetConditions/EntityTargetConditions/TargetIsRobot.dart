import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsRobot extends TargetConditionLiving {
    @override
    String name = "IsRobotPlayer";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Robot:</b><br>Target Entity must be a superior Robot Player. (reminder it will only target those robots with narrative significance)  <br><br>";
    @override
    String notDescText = "<b>Is NOT Robot:</b><br>Target Entity must be NOT a superior Robot Player (or not a player at all) <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsRobot(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsRobot(scene);
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
        if (item is Player) {
            if((item as Player).robot) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}