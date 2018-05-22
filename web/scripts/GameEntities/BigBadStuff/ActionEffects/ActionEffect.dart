import "../../../SBURBSim.dart";
import 'dart:html';
/*
much like target conditions decide WHO a scene should effect
action effects decide what happens when a scene triggers.
 */
abstract class ActionEffect {
    SerializableScene scene;
    String name = "Generic Effect";

    ActionEffect(SerializableScene scene);

    void renderForm(Element div);
    void syncToForm();
    void syncFormToMe();
    void copyFromJSON(JSONObject json);
    void applyEffect();
}


//lands don't have stats and shit
abstract class EffectLand extends ActionEffect {
  EffectLand(SerializableScene scene) : super(scene);

  @override
  void applyEffect() {
        List<Land> targets = scene.finalLandTargets;
        effectLands(targets);
  }

  void effectLands(List<Land> lands);


}

abstract class EffectEntity extends ActionEffect {
  EffectEntity(SerializableScene scene) : super(scene);
  @override
  void applyEffect() {
      List<GameEntity> targets = scene.finalLivingTargets;
      effectEntities(targets);
  }

  void effectEntities(List<GameEntity> entities);
}