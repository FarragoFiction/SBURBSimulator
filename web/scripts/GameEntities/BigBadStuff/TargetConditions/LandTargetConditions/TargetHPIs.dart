import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetHPIs extends TargetConditionLand {
    @override
    String name = "HPIs";

    SelectElement selectAmount;

    SelectElement selectDirection;

    List<int> amounts = <int>[0,13,130,1300,13000,130000];
    static String GREATER = ">";
    static String LESSER = "<";
    static String EQUAL = "=";

    List<String> directions = <String>[GREATER,EQUAL,LESSER];

    Item crown;


    @override
    String descText = "<b>HP IS:</b><br>Target Land's HP compares true to the value: <br><br>";
    @override
    String notDescText = "<b>HP IS NOT:</b><br>Target Land's HP does not compare true to the value:<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetHPIs(SerializableScene scene) : super(scene){
    }

    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);

        selectDirection = new SelectElement();
        me.append(selectDirection);
        for(String direction in directions) {
            OptionElement o = new OptionElement();
            o.value = direction;
            o.text = direction;
            selectDirection.append(o);
            if(direction == importantWord) {
                print("selecting ${o.value}");
                o.selected = true;
            }else {
                //print("selecting ${o.value} is not ${itemTrait.toString()}");
            }

        }
        selectDirection.onChange.listen((Event e) => syncToForm());

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
        return new TargetHPIs(scene);
    }

    @override
    void syncFormToMe() {
        for(OptionElement o in selectDirection.options) {
            if(o.value == importantWord) {
                o.selected = true;
                return;
            }
        }

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
        importantWord = selectDirection.options[selectDirection.selectedIndex].value;
        importantInt = int.parse(selectAmount.options[selectAmount.selectedIndex].value);

        syncNotFlagToForm();
        scene.syncForm();
    }
    @override
    void copyFromJSON(JSONObject json) {
        //nothing to do
        importantWord = json[TargetCondition.IMPORTANTWORD];
        importantInt = int.parse(json[TargetCondition.IMPORTANTINT]);

    }

    @override
    bool conditionForFilter(Land item,Set<GameEntity> entities) {
        if(importantWord == GREATER) {
            if(item.hp > importantInt) return false;
        }else if(importantWord == LESSER) {
            if(item.hp < importantInt) return false;
        }else {
            if(item.hp == importantInt) return false;
        }
        return true;
    }
}