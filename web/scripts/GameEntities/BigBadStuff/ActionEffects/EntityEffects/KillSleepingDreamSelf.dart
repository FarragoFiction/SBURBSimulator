import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class KillSleepingDreamSelf extends EffectEntity {
    @override
    String name = "KillSleepingDreamSelf";
    KillSleepingDreamSelf(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>KillSleepingDreamSelf:</b> <br>If the target has a sleeping back up dream self, it is now dead. <br><br>");
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
        if(e is Player) {
            if (e.renderable()) renderableTargets.add(e);
            SpanElement death = new SpanElement();
            (e as Player).dreamSelf = false;
            String moon = "???";
            if((e as Player).moon != null) moon = (e as Player).moon.name;
            String text = "The ${e.htmlTitle()} feels a sudden pang of unexplainable loss. Far away, on $moon, someone who looks just like them breathes their last breath.";
            death.setInnerHtml(text);
            scene.myElement.append(death);
        }
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
    return new KillSleepingDreamSelf(scene);
  }
}