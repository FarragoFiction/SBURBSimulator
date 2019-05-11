import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeGodTier extends EffectEntity {
    @override
    String name = "MakeGodTier";
    MakeGodTier(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeGodTier:</b> <br>If its a Player, they go GodTier (no matter destiny), otherwise gets God Buff <br><br>");
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
        String text = "";
        if(e is Player) {
          (e as Player).makeGodTier();
          text = "${e.htmlTitle()} has gone god tier. ";
        }else {
          e.addBuff(new BuffGodTier());
          text = "${e.htmlTitle()} has the powers of a god. ";
        }
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
    return new MakeGodTier(scene);
  }
}