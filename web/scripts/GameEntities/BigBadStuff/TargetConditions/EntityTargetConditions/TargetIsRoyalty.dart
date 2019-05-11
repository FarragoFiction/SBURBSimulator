import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsRoyalty extends TargetConditionLiving {
    @override
    String name = "IsRoyalty";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Royalty:</b><br>Target Entity be a Royal Carapace (even if not crowned) or a FUCHSIA BLOODED TROLL. <br><br>";
    @override
    String notDescText = "<b>Is NOT Royalty:</b><br>Target Entity must NOT be a Royal Carapace (even if not crowned) or a FUCHSIA BLOODED TROLL.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsRoyalty(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsRoyalty(scene);
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
        if(item is Carapace) {
            return !(item as Carapace).royalty;
        }else if (item is Player) {
            return (item as Player).bloodColor != "#99004d";
        }else {
            return true; //reject me plz
        }
    }
}