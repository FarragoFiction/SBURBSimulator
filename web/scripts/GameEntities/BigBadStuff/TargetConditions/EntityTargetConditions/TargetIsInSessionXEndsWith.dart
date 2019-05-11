import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsInSessionXEndsWith extends TargetConditionLiving {
    @override
    String name = "SeedEndsWith";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Session Seed Ends With:</b><br>If X is 113, 4113 and 234234113 are hits, 88878 is not. (useful for targeting specific days of the year)  <br><br>";
    @override
    String notDescText = "<b>Session Seed does NOT end with:</b><br>if X is 113, 234234 and 848888 both are hits, 4113 is not.<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetIsInSessionXEndsWith(SerializableScene scene) : super(scene){
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
        return new TargetIsInSessionXEndsWith(scene);
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
       // print("session is ${scene.session.session_id} and ends with is ${importantInt} and will i return true? ${"${scene.session.session_id}".endsWith("$importantInt")}");
        return !"${scene.session.session_id}".endsWith("$importantInt");

    }
}