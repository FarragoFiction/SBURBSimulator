import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeBusy extends EffectEntity {
    @override
    String name = "MakeBusy";
    MakeBusy(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeBusy:</b> <br>The Target is now unable to take their turn, if they haven't already this tick. Time and Breath players are immune to this.<br><br>");
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
        if(e is Player) {
          scene.session.removeAvailablePlayer(e);
        }else {
          e.available = false;
        }
        text = "$text ${e.htmlTitle()} is too busy.";
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
    return new MakeBusy(scene);
  }
}