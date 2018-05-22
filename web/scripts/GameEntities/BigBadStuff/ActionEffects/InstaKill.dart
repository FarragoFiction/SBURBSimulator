import "../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
class InstaKill extends EffectEntity {
  InstaKill(SerializableScene scene) : super(scene);


  @override
  void copyFromJSON(JSONObject json) {
    // TODO: implement copyFromJSON
  }

  @override
  void renderForm(Element div) {
    // TODO: implement renderForm
  }

  @override
  void syncFormToMe() {
    // TODO: implement syncFormToMe
  }

  @override
  void syncToForm() {
    // TODO: implement syncToForm
  }
  @override
  void effectEntities(List<GameEntity> entities) {
    entities.forEach((GameEntity e) {
        e.makeDead("encountering ${scene.gameEntity}", scene.gameEntity);
    });
  }
}