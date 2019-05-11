import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsTrickster extends TargetConditionLiving {
    @override
    String name = "IsTrickster";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Trickster:</b><br>Target Entity must be a Trickster Player.  <br><br>";
    @override
    String notDescText = "<b>Is NOT Trickster:</b><br>Target Entity must be NOT a Trickster Player (or not a player at all) <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsTrickster(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsTrickster(scene);
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
            if((item as Player).trickster) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}