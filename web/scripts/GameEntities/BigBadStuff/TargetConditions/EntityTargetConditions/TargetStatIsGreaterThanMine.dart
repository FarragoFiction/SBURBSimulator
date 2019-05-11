import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetStatIsGreaterThanMine extends TargetConditionLiving {

    @override
    String name = "TargetStatIsGreaterThanMine";


    SelectElement selectStat;


    @override
    String descText = "<b>Stat IS:</b><br>Target's stat is greater than my same stat: <br><br>";
    @override
    String notDescText = "<b>Stat IS NOT:</b><br>Target's stat is less than or equal to my same stat:<br><br>";

    //strongly encouraged for this to be replaced
    //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

    TargetStatIsGreaterThanMine(SerializableScene scene) : super(scene){
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

        syncFormToMe();
        scene.syncForm();

    }


    @override
    TargetCondition makeNewOfSameType() {
        return new TargetStatIsGreaterThanMine(scene);
    }

    @override
    void syncFormToMe() {
        for(OptionElement o in selectStat.options) {
            if(o.value == importantWord) {
                o.selected = true;
                return;
            }
        }
        syncFormToNotFlag();
    }

    @override
    void syncToForm() {
        importantWord = selectStat.options[selectStat.selectedIndex].value;

        syncNotFlagToForm();
        scene.syncForm();
    }


    @override
    bool conditionForFilter(GameEntity actor, GameEntity item) {
        Stat stat = Stats.byName[importantWord];
        return !(item.getStat(stat) > scene.gameEntity.getStat(stat));
    }
}