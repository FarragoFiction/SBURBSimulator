import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetStatIsGreaterThanValue extends TargetConditionLiving {

    @override
    String name = "TargetStatIsGreaterThanValue";

    SelectElement selectAmount;

    SelectElement selectStat;
    Map<int, StatAmount> amounts = StatAmount.getAllStats();

    Item crown;


    @override
    String descText = "<b>Stat IS:</b><br>Target's stat is greater than value: <br><br>";
    @override
    String notDescText = "<b>Stat IS NOT:</b><br>Target's stat is less than or equal to value:<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetStatIsGreaterThanValue(SerializableScene scene) : super(scene){
    }

    @override
    void renderForm(Element divbluh) {
        print("rendering target condition");
        setupContainer(divbluh);
        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);

        selectStat = new SelectElement();
        me.append(selectStat);
        List<String> allStatsKnown = new List<String>.from(Stats.byName.keys);
        for(String stat in allStatsKnown) {
            OptionElement o = new OptionElement();
            o.value = stat;
            o.text = stat;
            selectStat.append(o);
            if(stat == importantWord) {
                print("selecting ${o.value}");
                o.selected = true;
            }else {
                //print("selecting ${o.value} is not ${itemTrait.toString()}");
            }

        }
        if(importantWord == null) {
            importantWord = allStatsKnown.first;
            selectStat.selectedIndex = 0;
        }
        selectStat.onChange.listen((Event e) => syncToForm());


        selectAmount = new SelectElement();
        me.append(selectAmount);

        for(int amount in amounts.keys) {
            OptionElement o = new OptionElement();
            o.value = "$amount";
            o.text = "${amounts[amount].name}($amount)";
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
        return new TargetStatIsGreaterThanValue(scene);
    }

    @override
    void syncFormToMe() {
        for(OptionElement o in selectStat.options) {
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
        importantWord = selectStat.options[selectStat.selectedIndex].value;
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
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        Stat stat = Stats.byName[importantWord];
        return !(item.getStat(stat) > importantInt);
    }
}