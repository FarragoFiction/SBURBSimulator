import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsInSessionX extends TargetConditionLiving {
    @override
    String name = "SessionSeedIs";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Session Seed Is:</b><br>the seed is X:  <br><br>";
    @override
    String notDescText = "<b>Session Seed Is NOT:</b><br>the seed is NOT x<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsInSessionX(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);
        input = new TextInputElement();
        input.value = "$importantInt";
        input.onChange.listen((Event e) {
            syncToForm();
        });
        me.append(input);
        syncFormToMe();
        //scene.syncForm();
        scene.syncForm();
    }



    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsInSessionX(scene);
    }

    @override
    void syncFormToMe() {
        input.value = "$importantInt";
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantInt = int.parse(input.value);
        syncNotFlagToForm();
        scene.syncForm();
    }

    @override
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        return scene.session.session_id != importantInt;

    }
}