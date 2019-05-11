import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetEntitySessionHealthIsGreaterThan extends TargetConditionLiving {
    @override
    String name = "SessionHealthGreaterThan";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Session Health Greater:</b><br>Targets all entities if the Session's health is above a number.  <br><br>";
    @override
    String notDescText = "<b>Session Health Less than Or Equal:</b><br>Targets all entities if the Session's health is below or equal to a number.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetEntitySessionHealthIsGreaterThan(SerializableScene scene) : super(scene){
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
        return new TargetEntitySessionHealthIsGreaterThan(scene);
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
        return scene.session.sessionHealth < importantInt;
    }
}