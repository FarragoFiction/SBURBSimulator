import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetIsCarapace extends TargetConditionLiving {
  SelectElement select;

  static String ANY = "ANY";

  @override
  String name = "IsCarapace";

  @override
  String descText = "<b>Is Carapace:</b><br>Target Entity must be a carapace named:  <br><br>";
  @override
  String notDescText = "<b>Is NOT Carapace:</b><br>Target Entity must NOT be a carapace named: <br><br>";

  //strongly encouraged for this to be replaced
  //like, "An ominous 'honk' makes the Knight of Rage drop the Juggalo Poster in shock. With growing dread they realize that shit is about to get hella rowdy, as the Mirthful Messiahs have rolled into town.

  TargetIsCarapace(SerializableScene scene) : super(scene) {

  }

  @override
  void renderForm(Element divbluh) {
    Session session = scene.session;
    List<GameEntity> allCarapaces = new List.from(session.prospit.associatedEntities);
    allCarapaces.addAll(session.derse.associatedEntities);
    print("all carapaces is $allCarapaces");

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
    for(GameEntity carapace in allCarapaces) {
      OptionElement o = new OptionElement();
      o.value = carapace.initials;
      o.text = "${carapace.initials} (${carapace.name})";
      select.append(o);
      if(o.value == importantWord) {
        print("selecting ${o.value}");
        o.selected = true;
      }

    }

    if(select.selectedIndex == -1) {
        select.options[0].selected = true;
        importantWord = ANY;
    }

    select.onChange.listen((e) => syncToForm());
    syncFormToMe();
    scene.syncForm();

  }
  @override
  TargetCondition makeNewOfSameType() {
    return new TargetIsCarapace(scene);
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

    if(select.selectedIndex == -1) select.options[0].selected = true;
  }

  @override
  String toString() {
    return "TargetIsCarapace: ${importantWord}";
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
    //print("i am ${scene.gameEntity}, checking for is Carapace for ${item}, carapace initials are $importantWord");
    if(importantWord != ANY) {
        //print("looking for specific carapace");
      return !(item is Carapace) || item.initials != importantWord;
    }else {
        //print("looking for any carapace, should I reject ${item}? ${!(item is Carapace)}");
      return !(item is Carapace);
    }
  }
}