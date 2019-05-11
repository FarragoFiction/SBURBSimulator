import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetEntityFraymotifNameContains extends TargetConditionLiving {
    @override
    String name = "HasFraymotifWithName";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Has Fraymotif With Name:</b><br>Target Entity has at least one fraymotif named (or containing the word) X  <br><br>";
    @override
    String notDescText = "<b>Does NOT Have Fraymotif With Name:</b><br>Target Entityhas has NO fraymotifs named (or containing the word) X<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetEntityFraymotifNameContains(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);
        input = new TextInputElement();
        input.value = importantWord;
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
        return new TargetEntityFraymotifNameContains(scene);
    }

    @override
    void syncFormToMe() {
        input.value = importantWord;
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantWord = input.value;
        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
        importantWord = json[TargetCondition.IMPORTANTWORD];
    }

    @override
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        for(Fraymotif f in item.fraymotifs) {
            if(f.name.toLowerCase().contains(importantWord.toLowerCase())) return false;
        }
        return true;

    }
}