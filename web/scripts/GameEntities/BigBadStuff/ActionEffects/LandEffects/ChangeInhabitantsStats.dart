import "../../../../SBURBSim.dart";
import 'dart:html';


class ChangeInhabitantsStat extends EffectLand {
    SelectElement selectStat;
    SelectElement selectAmount;



    List<int> amounts = <int>[-13000,-1300,-130, 130,1300,13000];

    @override
    int  importantInt = 0;

    @override
    String name = "ChangeInhabitantsStat";
    ChangeInhabitantsStat(SerializableScene scene) : super(scene);


    @override
    void copyFromJSON(JSONObject json) {
        // print("copying from json");
        importantWord = json[ActionEffect.IMPORTANTWORD];
        importantInt = (int.parse(json[ActionEffect.IMPORTANTINT]));
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
            if(int.parse(o.value) == importantInt) {
                o.selected = true;
                return;
            }
        }
    }

    @override
    void renderForm(Element divbluh) {

        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        List<String> allStatsKnown = new List<String>.from(Stats.byName.keys);

        me.setInnerHtml("<b>Change Inhabitants Stats:</b> <br>");
        //stat time

        selectStat = new SelectElement();
        me.append(selectStat);
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
        if(importantWord == null) selectStat.selectedIndex = 0;
        selectStat.onChange.listen((Event e) => syncToForm());

        //amount time

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
        syncToForm();
    }

    @override
    void syncToForm() {
        importantWord = selectStat.options[selectStat.selectedIndex].value;
        importantInt = (int.parse(selectAmount.options[selectAmount.selectedIndex].value));

        scene.syncForm();
    }
    @override
    void effectLands(List<Land> entities) {
        String text = "";
        List<GameEntity> renderableTargets = new List<GameEntity>();
        entities.forEach((Land l) {
            for(GameEntity e in l.associatedEntities) {
                if (e.renderable()) renderableTargets.add(e);
                text = "$text Changing ${e.htmlTitle()} $importantWord, from ${e.getStat(Stats.byName[importantWord]).round()} to";
                if (Stats.byName[importantWord] == Stats.RELATIONSHIPS && e is Player) {
                    e.boostAllRelationshipsBy(importantInt);
                }
                e.addStat(Stats.byName[importantWord], importantInt/Stats.byName[importantWord].coefficient);
                text = "$text ${e.getStat(Stats.byName[importantWord]).round()}";
            }
        });

        ButtonElement toggle = new ButtonElement()..text = "Show Details?";
        scene.myElement.append(toggle);

        DivElement div = new DivElement()..setInnerHtml(text);
        div.style.display = "none";

        toggle.onClick.listen((Event e) {
            if(div.style.display == "none") {
                toggle.text = "Hide Details?";
                div.style.display = "block";
            }else {
                toggle.text = "Show Details?";
                div.style.display = "none";
            }
        });


        scene.myElement.append(div);
        if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
            CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
            scene.myElement.append(canvasDiv);
            Drawing.poseAsATeam(canvasDiv, renderableTargets);
            scene.posedAsATeamAlready = true;
        }
    }
    @override
    ActionEffect makeNewOfSameType() {
        return new ChangeInhabitantsStat(scene);
    }
}