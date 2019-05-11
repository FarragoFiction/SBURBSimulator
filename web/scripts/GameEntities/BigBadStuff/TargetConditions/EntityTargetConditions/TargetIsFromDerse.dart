import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsFromDerse extends TargetConditionLiving {
    static String ITEMAME = "CROWNNAME";
    @override
    String name = "IsFromDerse";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is From Derse:</b><br>Target Entity must be a carapace or player from Derse. <br><br>";
    @override
    String notDescText = "<b>Is Not From Derse:</b><br>Target Entity must be from Prospit or from no moon. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsFromDerse(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsFromDerse(scene);
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
            Carapace c = item as Carapace;
            return c.type != Carapace.DERSE;
        }else if( item is Player) {
            Player p = item as Player;
            //okay maybe you don't have a moon anymore but you still have jamies
            if(p.moon == null) return p.dreamPalette == scene.session.derse.palette;
            if(p.moon.name == scene.session.derse.name) return false;
        }else {
            return !scene.session.derse.associatedEntities.contains(item);
        }
        return true;
    }
}