import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class ChangeMyStatLand extends EffectLand {
    SelectElement selectStat;
    SelectElement selectAmount;



    List<int> amounts = <int>[-13000,-1300,-130,-13, 13,130,1300,13000];

    @override
    int  importantInt = 0;

    @override
    String name = "ChangeMyStatLand";
    ChangeMyStatLand(SerializableScene scene) : super(scene);


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

        me.setInnerHtml("<b>Change My Stat (no matter what land is being targeted):</b> <br>");
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
        if(importantWord == null) {
            importantWord = allStatsKnown.first;
            selectStat.selectedIndex = 0;
        }
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
  void effectLands(List<Land> lands) {
      String text = "";
      List<GameEntity> renderableTargets = new List<GameEntity>();
        if(scene.gameEntity.renderable()) renderableTargets.add(scene.gameEntity);
        text = "$text Changing ${scene.gameEntity.htmlTitle()} $importantWord, from ${scene.gameEntity.getStat(Stats.byName[importantWord])} to";
        if(Stats.byName[importantWord] == Stats.RELATIONSHIPS && scene.gameEntity is Player) {
            scene.gameEntity.boostAllRelationshipsBy(importantInt);
        }
        scene.gameEntity.addStat(Stats.byName[importantWord], importantInt/Stats.byName[importantWord].coefficient);
        text = "$text ${scene.gameEntity.getStat(Stats.byName[importantWord])}";


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
    return new ChangeMyStatLand(scene);
  }
}