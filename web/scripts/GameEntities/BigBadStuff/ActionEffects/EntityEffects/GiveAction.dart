import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class GiveAction extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String name = "GiveAction";
    GiveAction(SerializableScene scene) : super(scene);



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

        me.setInnerHtml("<b>GiveAction (whether mind control or giving a quest):</b> <br>");
        //stat time
        AnchorElement a = new AnchorElement(href:"AiEngineSceneCreation.html")..text = "Scene Builder";
        a.style.backgroundColor = "white";
        a.style.padding = "5px";
        a.target = "_blank";
        me.append(a);
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
        String nameOfScene = e.addSerializalbeSceneFromString(importantWord).name;
        text = "$text ${e.htmlTitle()} has a new objective: $nameOfScene.";
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
    return new GiveAction(scene);
  }
}