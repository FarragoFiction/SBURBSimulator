import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class IAmCrownedForLand extends TargetConditionLand {
    static String ITEMAME = "CROWNNAME";
    @override
    String name = "IAmCrowned";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>I am Crowned:</b><br>Owner of scene must be CROWNED to target anything. <br><br>";
    @override
    String notDescText = "<b>I am Not Crowned:</b><br>Owner of scene must be NOT CROWNED to target anything. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    IAmCrownedForLand(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new IAmCrownedForLand(scene);
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
        return scene.gameEntity.crowned == null;
    }
}