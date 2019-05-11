import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsDreamSelf extends TargetConditionLiving {
    @override
    String name = "IsDreamSelf";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is DreamSelf:</b><br>Target Entity must be a Player who is also a dream self. (i.e. real self is dead) <br><br>";
    @override
    String notDescText = "<b>Is NOT DreamSelf:</b><br>Target Entity must be NOT a player who is a dream self. (i.e. a real self or not a player) <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsDreamSelf(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsDreamSelf(scene);
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
            if((item as Player).isDreamSelf) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}