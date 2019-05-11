import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class MakeMortal extends EffectEntity {
    @override
    String name = "MakeMortal";
    MakeMortal(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);
        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>MakeMortal:</b> <br>God tier Players will no longer revive if non Heroic/Just. Unconditionally immortal entities now no longer are. <br><br>");
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
          (e as Player).canGodTierRevive = false;
          e.unconditionallyImmortal = false;
          //even if not god tier, it still will happen and if you god tier later you're fucked
          text = "${e.htmlTitle()} feels terrifyingly mortal. ";
        }else if (e.unconditionallyImmortal) {
           e.unconditionallyImmortal = false;
           text = "${e.htmlTitle()} feels terrifyingly mortal. ";
          }else {
          //does nothing. Nak.
          text = "${e.htmlTitle()} is confused. ";
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
    return new MakeMortal(scene);
  }
}