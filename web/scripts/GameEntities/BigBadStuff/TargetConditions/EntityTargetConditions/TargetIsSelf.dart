import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsSelf extends TargetConditionLiving {
    @override
    String name = "IsSelf";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Self:</b><br>Target Entity must be myself (clones don't count). <br><br>";
    @override
    String notDescText = "<b>Is NOT Self:</b><br>Target Entity must NOT be myself (clones count). <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsSelf(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsSelf(scene);
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
    return item != scene.gameEntity;
  }
}