import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class PledgeLoyalty extends EffectEntity {
    @override
    String name = "PledgeLoyalty";
    PledgeLoyalty(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>PledgeLoyalty:</b> <br>scene owner will help the TARGETS with Strifes <br><br>");
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
        e.addCompanion(scene.gameEntity);
        text = "$text ${scene.gameEntity.htmlTitle()} agrees to help the ${e.htmlTitle()} with any future strifes. ";

    });
      ButtonElement toggle = new ButtonElement()..text = "Show Details?";
      scene.myElement.append(toggle);

      DivElement div = new DivElement()..setInnerHtml(text);
      div.style.display = "none";
    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new PledgeLoyalty(scene);
  }
}