import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHasDreamSelf extends TargetConditionLiving {
    @override
    String name = "HasLivingDreamSelfBackup";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Has Living DreamSelf:</b><br>Target Entity must be a Player who has a backup living dream self.<br><br>";
    @override
    String notDescText = "<b>Does NOT Have Living DreamSelf:</b><br>Target Entity must be NOT a player who has a backup living dream self. (i.e. dream self is dead or not a player) <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHasDreamSelf(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetHasDreamSelf(scene);
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
            if((item as Player).dreamSelf) {
                return false; //don't remove if i'm this aspect
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}