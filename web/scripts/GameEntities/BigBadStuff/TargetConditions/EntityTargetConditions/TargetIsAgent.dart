import "../../../../SBURBSim.dart";
import 'dart:html';

// Entity filter. Filters for targets who are Jack, CD, DD, HB, PS, PI, AD, HB, or NB. Use IsFromDerse and IsFromProspit to indicate which team.
class TargetIsAgent extends TargetConditionLiving {
    @override
    String name = "TargetIsAgent";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Agent:</b><br>Target Entity is a member of the Midnight Crew, or the Sunshine Team. <br><br>";
    @override
    String notDescText = "<b>Is NOT Agent:</b><br>arget Entity is NOT a member of the Midnight Crew, or the Sunshine Team.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsAgent(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsAgent(scene);
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
            List<String> validInitials = <String>["SS","HB","DD","CD","PS","PI","AD","NB","HD"];
            for(String initial in validInitials) {
                if(item.initials == initial) return false;
            }
            return true;
        }else {
            return true; //reject me plz
        }
    }
}