import "../../../../SBURBSim.dart";
import 'dart:html';

//each potential target has a X% chance of being allowed
class TargetIsRandomLand extends TargetConditionLand {

    InputElement randomInput;
    @override
    String name = "IsRandom";

    Item crown;

    @override
    String get importantWord => "N/A";

    @override
    String descText = "<b>Is Random:</b><br>Each potential target has an X% chance of being targeted. <br><br>";
    @override
    String notDescText = "<b>Is NOT Random???:</br> Each potential target has an X% chance of being NOT targeted.  (why didn't you just change the number???)<br><br>";


    TargetIsRandomLand(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsRandomLand(scene);
    }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);


        LabelElement label = new LabelElement()..text = "Odds of Targeting Individual: $importantInt%";
        randomInput = new InputElement();
        randomInput.type = "range";
        randomInput.min = "0";
        randomInput.max = "100";
        randomInput.value = "$importantInt";
        me.append(label);
        me.append(randomInput);
        randomInput.onChange.listen((e) {
            syncToForm();
            label.text = "Odds of Targeting Individual: $importantInt%";
        });
        syncFormToMe();
    }

    @override
    void syncFormToMe() {
        randomInput.value = "$importantInt";
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantInt  = int.parse(randomInput.value);
        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        importantInt = (int.parse(json[TargetCondition.IMPORTANTINT]));
    }

    @override
    bool conditionForFilter(Land item,Set<GameEntity> entities) {
        //reject if it's bigger than important int. if int is small, most will be rejected
        int number = scene.session.rand.nextIntRange(0, 100);
        return number> importantInt;
    }
}