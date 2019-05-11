import "../../../../SBURBSim.dart";
import 'dart:html';

//has no sub form, just exists
class TargetIsFromSessionWithABStat extends TargetConditionLiving {

    SelectElement select;

    @override
    String name = "TargetIsFromSessionWithABStat";

    Item crown;

    @override
    String importantWord;

    @override
    String descText = "<b>Has AB Stat:</b><br>If AB were to visit this session at this moment, what would she report back on. (i.e. she would know there WERE sick fires, but not who did them). WARNING: Some things she reports back on are only set POST GAME (like scratch available), and thus a big bad couldn't really do anything about it. <br><br>";
    @override
    String notDescText = "<b>Doesn't Have AB Stat:</b><br>WARNING: ALL stats are 'false' when the session is created. They only get set to 'true' when shit happens. Using this version means you are saying 'a big bad can only show up UNTIL X happens'. <br><br>";

    //strongly encouraged for this to be replaced

    TargetIsFromSessionWithABStat(SerializableScene scene) : super(scene){
    }




    @override
    TargetCondition makeNewOfSameType() {
        return new TargetIsFromSessionWithABStat(scene);
    }

    @override
    void renderForm(Element divbluh) {
        Session session = scene.session;
        SessionSummary sessionSummary = session.generateSummary();

        List<String> allStats = new List.from(sessionSummary.bool_stats.keys);

        setupContainer(divbluh);

        syncDescToDiv();

        DivElement me = new DivElement();
        container.append(me);


        select = new SelectElement();
        select.size = 13;
        me.append(select);

        for(String stat in allStats) {
            OptionElement o = new OptionElement();
            o.value = stat;
            o.text = stat;
            select.append(o);
            if(o.value == importantWord) {
                print("selecting $stat");
                o.selected = true;
            }

        }



        if(select.selectedIndex == -1) {
            select.options[0].selected = true;
            importantWord = select.options[select.selectedIndex].value;
        }
        select.onChange.listen((e) => syncToForm());
        syncFormToMe();
        scene.syncForm();

    }

    @override
    void syncFormToMe() {
        for(OptionElement o in select.options) {
            if(o.value == importantWord) {
                o.selected = true;
                return;
            }
        }
        syncFormToNotFlag();

        if(select.selectedIndex == -1) {
            select.options[0].selected = true;
            importantWord = select.options[select.selectedIndex].value;
        }
    }

    @override
    void syncToForm() {
        importantWord = select.options[select.selectedIndex].value;
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
        SessionSummary sessionSummary = item.session.generateSummary();
        return sessionSummary.bool_stats[importantWord] != true;
    }
}