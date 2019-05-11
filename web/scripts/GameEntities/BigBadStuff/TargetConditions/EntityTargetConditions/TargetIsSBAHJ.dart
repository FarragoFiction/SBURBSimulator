import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsSBAHJ extends TargetConditionLiving {
    @override
    String name = "IsSBAHJ";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is SBAHJ:</b><br>Target Entity must be a SBAHJ Player (likely caused by doom gnosis).  <br><br>";
    @override
    String notDescText = "<b>Is NOT SBAHJ:</b><br>Target Entity must be NOT a SBAHJ Player (or not a player at all) <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsSBAHJ(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsSBAHJ(scene);
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
            if((item as Player).sbahj) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}