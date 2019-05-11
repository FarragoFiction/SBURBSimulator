import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class Mug extends EffectEntity {
    @override
    String name = "Mug";
    Mug(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>Mug:</b> <br>take everything in target's inventory. All of it. <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      String text = "";

      entities.forEach((GameEntity e) {
          if(e.sylladex.isNotEmpty) {
              text = "$text ${e.htmlTitle()} loses everything in their inventory, including ${turnArrayIntoHumanSentence(e.sylladex.inventory)}.  ${scene.gameEntity} now owns them.";
          }else {
              text = "$text ${scene.gameEntity.htmlTitle()} can find nothing to take from ${e.htmlTitle()}.";
          }
          scene.gameEntity.lootCorpse(e);
      });

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
    return new Mug(scene);
  }
}