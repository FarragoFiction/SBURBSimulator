import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class AntiMug extends EffectEntity {
    @override
    String name = "AntiMug";
    AntiMug(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>AntiMug:</b> <br>give everything you own to the first target. <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }
  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      String text = "";
      if(scene.gameEntity.sylladex.isNotEmpty) {
          text = "The ${scene.gameEntity
              .htmlTitle()} hands over everything in their inventory to the ${entities
              .first}, ${turnArrayIntoHumanSentence(
              scene.gameEntity.sylladex.inventory)}";
      }else {
          text = "The ${scene.gameEntity
              .htmlTitle()} is feeling charitable, but realizes they have nothing to give to the ${entities
              .first} .";
      }
      entities.first.lootCorpse(scene.gameEntity);


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
    return new AntiMug(scene);
  }
}