import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeFullfilledProphecy extends EffectEntity {
    @override
    String name = "MakeFullfilledProphecy";
    MakeFullfilledProphecy(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeFullfilledProphecy:</b> <br>The targets death happens according to prophecy. (does not set them to being dead). <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      List<GameEntity> renderableTargets = new List<GameEntity>();
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        SpanElement death = new SpanElement();
        String text = "${e.htmlTitleWithTip()} died (even if temporarily) according to prophecy.";
        e.prophecy = ProphecyState.FULLFILLED;
        death.setInnerHtml(text);
        scene.myElement.append(death);
    });
    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MakeFullfilledProphecy(scene);
  }
}