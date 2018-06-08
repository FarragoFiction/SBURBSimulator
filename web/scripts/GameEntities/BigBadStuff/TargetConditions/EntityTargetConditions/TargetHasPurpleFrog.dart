import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetHasPurpleFrog extends TargetConditionLiving {
  SelectElement select;

  @override
  String name = "HasPurpleFrog";

  InterestCategory category;

  @override
  String descText = "<b>Has Purple Frog:</b><br>Target Space Player must have a Purple Frog ready to deploy:  <br><br>";
  @override
  String notDescText = "<b>Does NOT Have Purple Frog:</b><br>Target Space Player must NOT have a Purple Frog ready to deploy: <br><br>";


  TargetHasPurpleFrog(SerializableScene scene) : super(scene) {

  }

  @override
  void renderForm(Element divbluh) {
    Session session = scene.session;
    List<InterestCategory> allCategories = new List.from(InterestManager.allCategories);

    setupContainer(divbluh);

    syncDescToDiv();

    DivElement me = new DivElement();
    container.append(me);


    select = new SelectElement();
    select.size = 13;
    me.append(select);

    for(InterestCategory category in allCategories) {
      OptionElement o = new OptionElement();
      o.value = category.name;
      o.text = category.name;
      select.append(o);
      if(o.value == importantWord) {
        print("selecting ${o.value}");
        o.selected = true;
      }

    }



    if(select.selectedIndex == -1) {
      category = InterestManager.allCategories.first;
      importantWord = category.name;

      select.options[0].selected = true;
    }
    select.onChange.listen((e) => syncToForm());
    syncFormToMe();
  }
  @override
  TargetCondition makeNewOfSameType() {
    return new TargetHasPurpleFrog(scene);
  }
  @override
  void syncFormToMe() {
    importantWord = category.name;
    for(OptionElement o in select.options) {
      if(o.value == importantWord) {
        o.selected = true;
        return;
      }
    }
    syncFormToNotFlag();

    if(select.selectedIndex == -1) {
      category = InterestManager.allCategories.first;
      importantWord = category.name;
      select.options[0].selected = true;
    }
  }

  @override
  String toString() {
    return "TargetHasFrog: ${importantWord}";
  }

  @override
  void syncToForm() {
    importantWord = select.options[select.selectedIndex].value;
    category = InterestManager.getCategoryFromString(importantWord);
    //keeps the data boxes synced up the chain
    syncNotFlagToForm();

    scene.syncForm();
  }
  @override
  void copyFromJSON(JSONObject json) {
    importantWord = json[TargetCondition.IMPORTANTWORD];
    category = InterestManager.getCategoryFromString(importantWord);
  }

  @override
  bool conditionForFilter(GameEntity item) {
    if(item is Player) {
      Player p = item as Player;
      if(p.landLevel <= -1 * p.session.goodFrogLevel) return false;
    }
    return true;
  }
}