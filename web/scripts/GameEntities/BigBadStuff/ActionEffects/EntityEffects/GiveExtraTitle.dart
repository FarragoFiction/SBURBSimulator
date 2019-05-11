import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class GiveExtraTitle extends EffectEntity {
    TextAreaElement actionStringBox;
    @override
    int  importantInt = 0;

    @override
    String importantWord = "";
    @override
    String name = "GiveExtraTitle";
    GiveExtraTitle(SerializableScene scene) : super(scene);


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

        me.setInnerHtml("<b>GiveExtraTitle (entities can have only one extra title at a time, will override existing, can remove extra title by giving a blank one):</b> <br>");
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
        e.extraTitle = importantWord;
        text = "$text ${e.htmlTitle()} has a new title.";
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
    return new GiveExtraTitle(scene);
  }
}