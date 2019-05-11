import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeInactive extends EffectEntity {
    @override
    String name = "MakeInactive";
    MakeInactive(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeInactive:</b> <br>The Target is deactivated, and irreversibly will never do anything again.<br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      List<GameEntity> renderableTargets = new List<GameEntity>();
      String text = "";
    entities.forEach((GameEntity e) {
        if(e.renderable()) renderableTargets.add(e);
        scene.session.deactivateNPC(e);
        text = "$text ${e.htmlTitle()} will never trouble this session again.";
    });
    scene.myElement.append(new SpanElement()..setInnerHtml(text));
    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new MakeInactive(scene);
  }
}