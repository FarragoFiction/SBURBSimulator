import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetEntityHasCompanionNamed extends TargetConditionLiving {
    @override
    String name = "HasCompanionNamed";
    InputElement input;

    Item crown;


    @override
    String descText = "<b>Has Companion With Name:</b><br>Target Entity has companion named (or containing the word) X   <br><br>";
    @override
    String notDescText = "<b>Does NOT Have Companion With Name:</b><br>Target Entity  does NOT have Companion named (or containing the word) X<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetEntityHasCompanionNamed(SerializableScene scene) : super(scene){
    }


    @override
    void renderForm(Element divbluh) {
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
        return new TargetEntityHasCompanionNamed(scene);
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
        for(GameEntity companion in item.companionsCopy) {
            if(companion.title().toLowerCase().contains(
                importantWord.toLowerCase())) return false;
        }
        return true;
    }
}