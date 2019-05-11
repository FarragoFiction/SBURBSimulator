import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsFromProspit extends TargetConditionLiving {
    static String ITEMAME = "CROWNNAME";
    @override
    String name = "IsFromProspit";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is From Prospit:</b><br>Target Entity must be a carapace or player from Prospit. <br><br>";
    @override
    String notDescText = "<b>Is Not From Prospit:</b><br>Target Entity must be from Derse or from no moon. <br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsFromProspit(SerializableScene scene) : super(scene){
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsFromProspit(scene);
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
       // print("oh, hello there. Is this $item from prospit?");
        if(item is Carapace) {
            Carapace c = item as Carapace;
           // print("oh, hello there. is this carapace, $c, from prospit? ${c.type}, ${c.type == Carapace.PROSPIT}");
            return c.type != Carapace.PROSPIT;
        }else if( item is Player) {
          Player p = item as Player;
          //okay maybe you don't have a moon anymore but you still have jamies
          if(p.moon == null) return p.dreamPalette == scene.session.prospit.palette;
          if(p.moon.name == scene.session.prospit.name) return false;
        }else {
            //print("oh, hello there. $item is not a carapace or a player. i guess i can see if its on the moon");
            return !scene.session.prospit.associatedEntities.contains(item);
        }
        return true;
    }
}