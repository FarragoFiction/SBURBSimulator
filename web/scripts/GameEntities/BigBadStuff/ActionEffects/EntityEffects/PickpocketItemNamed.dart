import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class PickpocketItemNamed extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String importantWord = "";
    @override
    String name = "PickpocketSingleItemNamed";
    PickpocketItemNamed(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
      actionStringBox.value = importantWord;
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        List<String> allStatsKnown = new List<String>.from(Stats.byName.keys);

        me.setInnerHtml("<b>PickpocketSingleItemNamed: (name is either exactly or contains):</b> <br>");
        //stat time

        actionStringBox = new TextAreaElement();
        me.append(actionStringBox);
        actionStringBox.value = importantWord;
        actionStringBox.onChange.listen((Event e) => syncToForm());
        syncToForm();
    }

  @override
  void syncToForm() {
      importantWord = actionStringBox.value;
      scene.syncForm();
  }

  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      String text = "";
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        bool found = false;
        for(Item item in e.sylladex) {
            if(item.fullName.toLowerCase().contains(importantWord.toLowerCase())) {
                found = true;
                e.sylladex.remove(item);
                scene.gameEntity.sylladex.add(item);
                text = "$text The ${e.htmlTitleWithTip()} loses their ${item.fullName} to ${scene.gameEntity.htmlTitleWithTip()}.";
                break;
            }
        }
        if(!found) {
            text = "$text The ${scene.gameEntity.htmlTitleWithTip()} cannot find a  ${importantWord} in ${e.htmlTitleWithTip()}'s sylladex to take.";
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
    return new PickpocketItemNamed(scene);
  }
}