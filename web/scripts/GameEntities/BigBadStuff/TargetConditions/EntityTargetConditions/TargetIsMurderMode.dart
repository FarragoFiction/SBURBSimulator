import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsMurderMode extends TargetConditionLiving {
    @override
    String name = "IsMurderMode";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<br><br><br><b>Is MurderMode:</b><br>Target Entity must be MuderMode. <br><br>";
    @override
    String notDescText = "<br><br><br><b>Is NOT MurderMode:</b><br>Target Entity must be NOT MurderMode. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsMurderMode(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsMurderMode(scene);
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
    bool conditionForFilter(GameEntity item) {
        if (item is Player) {
            if((item as Player).murderMode) {
                return false; //don't remove if i'm this
            }else {
                return true;
            }
        }else {
            return true;
        }
    }
}