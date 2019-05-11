import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class AbdicateCrown extends EffectEntity {
    @override
    String name = "AbdicateCrown";
    AbdicateCrown(SerializableScene scene) : super(scene);



  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>AbdicateCrown:</b> <br>Hand over the ring or scepter the system identifies as your crown. <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      List<GameEntity> renderableTargets = new List<GameEntity>();
      GameEntity e = entities.first;
        if(e.renderable()) renderableTargets.add(e);
        String text = "${scene.gameEntity.htmlTitle()} hands over the ${scene.gameEntity.crowned} to ${e.htmlTitle()}.";
        Item item = scene.gameEntity.crowned;
        e.sylladex.add(item);
        scene.gameEntity.sylladex.remove(item); //should happen automatically but i'm feeling paranoid.

    if(renderableTargets.isNotEmpty && !scene.posedAsATeamAlready) {
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        scene.myElement.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, renderableTargets);
        scene.posedAsATeamAlready = true;
    }

      ButtonElement toggle = new ButtonElement()..text = "Show Details?";
      scene.myElement.append(toggle);

      DivElement div = new DivElement()..setInnerHtml(text);
      div.style.display = "none";
      scene.myElement.append(div);

      toggle.onClick.listen((Event e) {
          if(div.style.display == "none") {
              toggle.text = "Hide Details?";
              div.style.display = "block";
          }else {
              toggle.text = "Show Details?";
              div.style.display = "none";
          }
      });
  }
  @override
  ActionEffect makeNewOfSameType() {
    return new AbdicateCrown(scene);
  }
}