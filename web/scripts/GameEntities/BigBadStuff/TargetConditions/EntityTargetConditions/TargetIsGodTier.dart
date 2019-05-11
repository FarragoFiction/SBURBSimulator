import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsGodTier extends TargetConditionLiving {
    @override
    String name = "IsGodTier";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is GodTier:</b><br>Target Entity must be GodTier. <br><br>";
    @override
    String notDescText = "<b>Is NOT GodTier:</b><br>Target Entity must be NOT GodTier. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsGodTier(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsGodTier(scene);
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
            if((item as Player).godTier) {
                return false; //don't remove if i'm this
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}