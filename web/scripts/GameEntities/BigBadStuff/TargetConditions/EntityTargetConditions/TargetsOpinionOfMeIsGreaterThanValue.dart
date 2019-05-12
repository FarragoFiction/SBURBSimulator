import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetsOpinionOfMeIsGreaterThanValue extends TargetConditionLiving {

    @override
    String name = "TargetsOpinionOfMeIsGreaterThanValue";

    SelectElement selectAmount;

    List<int> amounts = <int>[-4000,-40,-20,-10,-5, 5,10,20,40,4000];

    Item crown;


    @override
    String descText = "<b>Target Opinion Is:</b><br>Target Likes Me More Than Value: <br><br>";
    @override
    String notDescText = "<b>Target Opinion IS NOT:</b><br>Target Does NOT like Me More Than Value:<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetsOpinionOfMeIsGreaterThanValue(SerializableScene scene) : super(scene){
    }

    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);




        selectAmount = new SelectElement();
        me.append(selectAmount);

        for(int amount in amounts) {
            OptionElement o = new OptionElement();
            o.value = "$amount";
            o.text = "$amount";
            selectAmount.append(o);
            if(amount == importantInt) {
                print("selecting ${o.value}");
                o.selected = true;
            }else {
                //print("selecting ${o.value} is not ${itemTrait.toString()}");
            }

        }
        selectAmount.onChange.listen((Event e) => syncToForm());
        syncFormToMe();
        scene.syncForm();
    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetsOpinionOfMeIsGreaterThanValue(scene);
    }

    @override
    void syncFormToMe() {

        for(OptionElement o in selectAmount.options) {
            if(o.value == "${importantInt}") {
                o.selected = true;
                return;
            }
        }
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantInt = int.parse(selectAmount.options[selectAmount.selectedIndex].value);

        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
        importantInt = int.parse(json[TargetCondition.IMPORTANTINT]);

    }

    @override
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        Relationship r = item.getRelationshipWith(actor);
        if(r == null) {
            return true;  //filter me i don't exist
        }
        return !(r.value > importantInt);
    }
}