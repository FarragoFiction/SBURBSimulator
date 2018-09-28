import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsAnyTargetEntititesLand extends TargetConditionLand {
    @override
    String name = "IsAnyTargetEntititesLand";



    @override
    String descText = "<b>Is Target's:</b><br>Target of This Scene is from this Land <br><br>";
    @override
    String notDescText = "<b>Is NOT Target's:</b><br>Target of This Scene is NOT from this Land<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsAnyTargetEntititesLand(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsAnyTargetEntititesLand(scene);
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
        for(GameEntity e in entities) {
            //print("is the targeted entity $e on the land $item?");
            if(item.associatedEntities.contains(e)) {
                //print("yes");
                return false; //found the target. eye lens flare ensues
            }
        }
        return true; //yes you may remove this because it doesn't belong to a target
    }
}