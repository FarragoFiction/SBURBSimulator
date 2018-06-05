import "../../../../SBURBSim.dart";
import 'dart:html';


class ChangeLandHealth extends EffectLand {
    SelectElement selectAmount;



    List<int> amounts = <int>[-13000,-1300,-130, 130,1300,13000];

    @override
    int  importantInt = 0;

    @override
    String name = "ChangeLandHealth";
    ChangeLandHealth(SerializableScene scene) : super(scene);


    @override
    void copyFromJSON(JSONObject json) {
        // print("copying from json");
        importantWord = json[ActionEffect.IMPORTANTWORD];
        importantInt = (int.parse(json[ActionEffect.IMPORTANTINT]));
    }

    @override
    void syncFormToMe() {

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

        me.setInnerHtml("<b>Change HP By:</b> <br>");
        //stat time
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
        importantInt = (int.parse(selectAmount.options[selectAmount.selectedIndex].value));

        scene.syncForm();
    }
    @override
    void effectLands(List<Land> entities) {
        String text = "";
        entities.forEach((Land l) {
            l.hp += importantInt;
            text = "$text ${l.name} hp is now ${l.hp}";
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
    }
    @override
    ActionEffect makeNewOfSameType() {
        return new ChangeLandHealth(scene);
    }
}