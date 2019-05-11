import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetHasInterestCategory extends TargetConditionLiving {
  SelectElement select;

  @override
  String name = "HasInterestCategory";

  InterestCategory category;

  @override
  String descText = "<b>Has Interest Category:</b><br>Target Player must have an interest in category:  <br><br>";
  @override
  String notDescText = "<b>Has Interest Category:</b><br>Target Entity must NOT have an interest in a category (or not be a player): <br><br>";


  TargetHasInterestCategory(SerializableScene scene) : super(scene) {

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
    scene.syncForm();

  }
  @override
  TargetCondition makeNewOfSameType() {
    return new TargetHasInterestCategory(scene);
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
    return "TargetHasInterestCategory: ${importantWord}";
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
  bool conditionForFilter(GameEntity actor, GameEntity item) {
    if(item is Player) {
      Player p = item as Player;
      if(!p.isTroll) return true;
      if(p.interestedInCategory(category)) {
        return false;
      }
    }
    return true;
  }
}