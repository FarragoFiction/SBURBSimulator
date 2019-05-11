import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetHasFrog extends TargetConditionLiving {

  @override
  String name = "HasFrog";


  @override
  String descText = "<b>Has Frog:</b><br>Target Space Player must have a Frog ready to deploy:  <br><br>";
  @override
  String notDescText = "<b>Does NOT Have Frog:</b><br>Target Space Player must NOT have a frog: <br><br>";


  TargetHasFrog(SerializableScene scene) : super(scene) {

  }

  @override
  void renderForm(Element divbluh) {
    Session session = scene.session;

    setupContainer(divbluh);

    syncDescToDiv();

    DivElement me = new DivElement();
    container.append(me);
    syncFormToMe();
  }
  @override
  TargetCondition makeNewOfSameType() {
    return new TargetHasFrog(scene);
  }
  @override
  void syncFormToMe() {
    syncFormToNotFlag();

  }

  @override
  String toString() {
    return "TargetHasFrog: ${importantWord}";
  }

  @override
  void syncToForm() {
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
      if(p.landLevel >= p.session.goodFrogLevel) return false;
    }
    return true;
  }
}