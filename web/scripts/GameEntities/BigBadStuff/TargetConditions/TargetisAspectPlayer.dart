import "../../../SBURBSim.dart";
import 'dart:html';

class TargetIsAspectPlayer extends TargetConditionLiving {
  TargetIsAspectPlayer(SerializableScene scene) : super(scene);

  Aspect aspect;

  @override
  String name = "isAspectPlayer";

  @override
  String get importantWord => "$aspect";


  @override
  void copyFromJSON(JSONObject json) {
    // TODO: implement copyFromJSON
  }

  @override
  List<GameEntity> filter(List<GameEntity> list) {
      list.removeWhere((GameEntity entity) {
          if (entity is Player) {
              if((entity as Player).aspect == aspect) {
                  return false; //don't remove if i'm this aspect
              }else {
                  return true;
              }
          }else {
            return true;
          }
      });
      return list;
  }

  @override
  TargetCondition makeNewOfSameType() {
    return new TargetIsAspectPlayer(scene);
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
}