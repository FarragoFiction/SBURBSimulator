import "../../../SBURBSim.dart";
import 'dart:html';

class TargetIsClassPlayer extends TargetConditionLiving {
    TargetIsClassPlayer(SerializableScene scene) : super(scene);


  SelectElement select;


  String className;
  List<String> _allClasses  = new List<String>();

  List<String> get allClasses {
      //print("getting allTraits");
      if(_allClasses == null || _allClasses.isEmpty) {
          _allClasses = new List<String>.from(SBURBClassManager.allClassNames);
      }
      return _allClasses;
  }


  @override
  String name = "isClassPlayer";

  @override
  String get importantWord => "$className";


  @override
  void copyFromJSON(JSONObject json) {
      className = json[TargetCondition.IMPORTANTWORD];
  }

  @override
  List<GameEntity> filter(List<GameEntity> list) {
      list.removeWhere((GameEntity entity) {
          if (entity is Player) {
              if((entity as Player).class_name.name == className) {
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
    return new TargetIsClassPlayer(scene);
  }

  @override
  void renderForm(Element div) {
      List<String> allClassesKnown = new List<String>.from(allClasses);
      allClassesKnown.sort((String a, String b) => a.toLowerCase().compareTo(b.toLowerCase()));

      DivElement me = new DivElement();
      div.append(me);
      me.setInnerHtml("<br>Target Entity must be a Player With Aspect: <br>");

      select = new SelectElement();
      me.append(select);
      for(String aspect in allClassesKnown) {
          OptionElement o = new OptionElement();
          o.value = aspect.toString();
          o.text = aspect.toString();
          select.append(o);
          if(aspect.toString() == aspect.toString()) {
              print("selecting ${o.value}");
              o.selected = true;
          }else {
              //print("selecting ${o.value} is not ${itemTrait.toString()}");
          }

      }
      if(className == null) select.selectedIndex = 0;
      select.onChange.listen((Event e) => syncToForm());
      syncToForm();

  }

  @override
  void syncFormToMe() {
      print("syncing isClass form with aspect of $className");
      for(OptionElement o in select.options) {
          if(o.value == className) {
              o.selected = true;
              return;
          }
      }
  }

  @override
  void syncToForm() {
      className = select.options[select.selectedIndex].value;
      scene.syncForm();
  }
}