import "../../../SBURBSim.dart";
import 'dart:html';

class TargetIsAspectPlayer extends TargetConditionLiving {
  TargetIsAspectPlayer(SerializableScene scene) : super(scene);


  SelectElement select;

  
  String aspectName;
  List<String> _allAspects  = new List<String>();

  List<String> get allAspects {
      //print("getting allTraits");
      if(_allAspects == null || _allAspects.isEmpty) {
          _allAspects = Aspects.names;
      }
      return _allAspects;
  }


  @override
  String name = "isAspectPlayer";

  @override
  String get importantWord => "$aspectName";


  @override
  void copyFromJSON(JSONObject json) {
      aspectName = json[TargetCondition.IMPORTANTWORD];
  }

  @override
  List<GameEntity> filter(List<GameEntity> list) {
      list.removeWhere((GameEntity entity) {
          if (entity is Player) {
              if((entity as Player).aspect.name == aspectName) {
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
      aspectName = select.options[select.selectedIndex].value;
      scene.syncForm();
  }
}