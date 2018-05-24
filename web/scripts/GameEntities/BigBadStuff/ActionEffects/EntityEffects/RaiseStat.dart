import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class RaiseStat extends EffectEntity {
    SelectElement selectStat;
    SelectElement selectAmount;

    int amountIndex = 0;
    List<int> amounts = <int>[130,1300,13000];

    @override
    int get importantInt => amounts[amountIndex];

    @override
    String name = "RaiseStat:";
    RaiseStat(SerializableScene scene) : super(scene);


  @override
  void copyFromJSON(JSONObject json) {
      importantWord = json[TargetCondition.IMPORTANTWORD];
      amountIndex = amounts.indexOf(int.parse(json["amount"]));
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
          if(int.parse(o.value) == amounts[amountIndex]) {
              o.selected = true;
              return;
          }
      }
  }

    @override
    void renderForm(Element div) {
        DivElement me = new DivElement();
        div.append(me);
        List<String> allStatsKnown = new List<String>.from(Stats.all);

        me.setInnerHtml("<br><br><b>Raise Stat:</b> <br>");
        //TODO I need to have a list of stat names. how do I get that?

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

        //TODO i need to have a drop down of possible values to raise it by

        selectAmount = new SelectElement();
        me.append(selectAmount);
        for(int amount in amounts) {
            OptionElement o = new OptionElement();
            o.value = "$amount";
            o.text = "$amount";
            selectAmount.append(o);
            if(amount == amounts[amountIndex]) {
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
      amountIndex = amounts.indexOf(int.parse(selectAmount.options[selectStat.selectedIndex].value));

      scene.syncForm();
  }
  @override
  void effectEntities(List<GameEntity> entities) {
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        //TODO
    });
    if(renderableTargets.isNotEmpty) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new RaiseStat(scene);
  }
}