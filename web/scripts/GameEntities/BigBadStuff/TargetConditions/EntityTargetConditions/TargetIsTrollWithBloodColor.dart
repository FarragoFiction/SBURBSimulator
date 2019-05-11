import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetIsTrollWithBloodColor extends TargetConditionLiving {
  SelectElement select;

  static String ANY = "ANY";

  @override
  String name = "IsTrollWithBloodColor";

  @override
  String descText = "<b>Is Troll:</b><br>Target Entity must be a troll with blood color:  <br><br>";
  @override
  String notDescText = "<b>Is NOT Troll:</b><br>Target Entity must NOT be a troll with blood color: <br><br>";


  TargetIsTrollWithBloodColor(SerializableScene scene) : super(scene) {

  }

  @override
  void renderForm(Element divbluh) {
    Session session = scene.session;
    List<String> allBloodColors = new List.from(bloodColors);
    allBloodColors.add("#ff0000");

    setupContainer(divbluh);

    syncDescToDiv();

    DivElement me = new DivElement();
    container.append(me);


    select = new SelectElement();
    select.size = 13;
    me.append(select);

    OptionElement o = new OptionElement();
    o.value = ANY;
    o.text = ANY;
    select.append(o);
    for(String bloodColor in allBloodColors) {
      OptionElement o = new OptionElement();
      o.value = bloodColor;
      o.text = bloodColor;
      o.style.backgroundColor = bloodColor;
      select.append(o);
      if(o.value == importantWord) {
        print("selecting ${o.value}");
        o.selected = true;
      }

    }



    if(select.selectedIndex == -1) {
      importantWord = ANY;
      select.options[0].selected = true;
    }
    select.onChange.listen((e) => syncToForm());
    syncFormToMe();
    scene.syncForm();

  }
  @override
  TargetCondition makeNewOfSameType() {
    return new TargetIsTrollWithBloodColor(scene);
  }
  @override
  void syncFormToMe() {
    for(OptionElement o in select.options) {
      if(o.value == importantWord) {
        o.selected = true;
        return;
      }
    }
    syncFormToNotFlag();

    if(select.selectedIndex == -1) {
      importantWord = ANY;
      select.options[0].selected = true;
    }
  }

  @override
  String toString() {
    return "TargetHasBloodColor: ${importantWord}";
  }

  @override
  void syncToForm() {
    importantWord = select.options[select.selectedIndex].value;
    //keeps the data boxes synced up the chain
    syncNotFlagToForm();

    scene.syncForm();
  }
  @override
  void copyFromJSON(JSONObject json) {
    importantWord = json[TargetCondition.IMPORTANTWORD];
  }

  @override
  bool conditionForFilter(GameEntity actor, GameEntity item) {
    if(item is Player) {
      Player p = item as Player;
      if(!p.isTroll) return true;
      if(importantWord == ANY) {
          return false;
      }else if(p.bloodColor == importantWord) {
        return false;
      }
    }
    return true;
  }
}