import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class IAmCrowned extends TargetConditionLiving {
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

    IAmCrowned(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new IAmCrowned(scene);
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
        return scene.gameEntity.crowned == null;
    }
}