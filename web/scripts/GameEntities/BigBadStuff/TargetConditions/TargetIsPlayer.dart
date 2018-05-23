import "../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsPlayer extends TargetConditionLiving {
    @override
    String name = "IsPlayer";


    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsPlayer(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element div) {
        DivElement me = new DivElement();
        div.append(me);
        me.setInnerHtml("<br><br><br><b>Is Player:</b><br>Target Entity must be a Player (or the clone of a Player). <br><br>");
        syncToForm();
    }

    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsPlayer(scene);
    }

    @override
    void syncFormToMe() {
            //does nothing
    }

    @override
    void syncToForm() {
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
    }

    @override
    bool conditionForFilter(GameEntity item) {
        return !(item is Player);
    }
}