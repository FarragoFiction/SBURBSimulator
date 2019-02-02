import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsMyLand extends TargetConditionLand {
    @override
    String name = "IsMyLand";



    @override
    String descText = "<b>Is My Land:</b><br>Owner of This Scene is from this Land <br><br>";
    @override
    String notDescText = "<b>Is NOT Moon:</b><br>Owner of This Scene is NOT from this Land<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsMyLand(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsMyLand(scene);
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
        return !item.associatedEntities.contains(scene.gameEntity);
    }
}