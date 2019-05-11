import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class ChangeOpinionOfMe extends EffectEntity {
    SelectElement selectAmount;



    List<int> amounts = <int>[-4000,-40,-20,-10,-5, 5,10,20,40,4000];

    @override
    int  importantInt = 0;

    @override
    String name = "ChangeOpinionOfMe";
    ChangeOpinionOfMe(SerializableScene scene) : super(scene);


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

        me.setInnerHtml("<b>ChangeOpinionOfMe:</b> (20 is normally a huge amount in either direction) <br>");
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
    void effectEntities(GameEntity effector,List<GameEntity> entities) {
        String text = "";
        String emotion = (importantInt > 0) ? "likes":"hates";
        List<GameEntity> renderableTargets = new List<GameEntity>();
        entities.forEach((GameEntity e) {
            if(e.renderable()) renderableTargets.add(e);
            Relationship r = e.getRelationshipWith(effector);
            if(r != null) {
                text = "$text ${e.htmlTitle()} $emotion them ${importantInt} more!";
                r.changeBy(importantInt);
            }else {
                text = "$text ${e.htmlTitle()} wants to $emotion them ${importantInt} more, but they just are too apathetic about them. ";
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
        return new ChangeOpinionOfMe(scene);
    }
}