import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class KillFrog extends EffectEntity {
    @override
    String name = "LoseFrog";
    KillFrog(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>LoseFrog:</b> <br>target loses a Frog (nearly pointless unless they are the Space Player).  <br><br>");
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
        if(e is Player) {
          Land land = (e as Player).land;
          if(land != null) {
            land.thirdCompleted = true;
            land.noMoreQuests = true;
          }
          Player p = e as Player;
          p.landLevel = 0.0;
          if((e as Player).aspect.isThisMe(Aspects.SPACE)) {
              SpanElement death = new SpanElement();
              String text = "The ${e.htmlTitleWithTip()} lost the Ultimate Frog? That's bullshit!";
              death.setInnerHtml(text);
              scene.myElement.append(death);
          }
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
    return new KillFrog(scene);
  }
}