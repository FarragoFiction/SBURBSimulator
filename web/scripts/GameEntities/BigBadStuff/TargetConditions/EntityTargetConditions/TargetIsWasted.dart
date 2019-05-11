import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsWasted extends TargetConditionLiving {
    @override
    String name = "IsWasted";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Wasted:</b><br>Target Player must have hit Gnosis4.  <br><br>";
    @override
    String notDescText = "<b>Is NOT Wasted:</b><br>Target Player must be NOT have hit Gnosis4. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsWasted(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsWasted(scene);
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
            if((item as Player).gnosis >=4) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}