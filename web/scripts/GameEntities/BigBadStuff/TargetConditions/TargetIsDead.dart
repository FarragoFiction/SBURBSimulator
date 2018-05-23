import "../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsDead extends TargetConditionLiving {
    @override
    String name = "IsDead";

    @override
    String descText = "<br><br><br><b>Is Dead:</b><br>Target Entity must be DEAD (zombies dont count). <br><br>";
    @override
    String notDescText = "<br><br><br><b>Is NOT Dead:</b><br>Target Entity must be NOT DEAD (zombies count). <br><br>";

    Item crown;

    @override
    String get importantWord => "N/A";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsDead(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element div) {
        descElement = new DivElement();
        div.append(descElement);
        syncDescToDiv();

        DivElement me = new DivElement();
        div.append(me);
        renderNotFlag(me);

        syncToForm();
    }

    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsDead(scene);
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
        return !item.dead;
    }
}