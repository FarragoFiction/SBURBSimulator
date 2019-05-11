import "../../../../SBURBSim.dart";
import 'dart:html';

//TODO can pick "any" or pick a specific carapace, use CrownedCarapace trigger as a guide
class TargetHasPurpleFrog extends TargetConditionLiving {

  @override
  String name = "HasPurpleFrog";


  @override
  String descText = "<b>Has Purple Frog:</b><br>Target Space Player must have a Purple Frog ready to deploy:  <br><br>";
  @override
  String notDescText = "<b>Does NOT Have Purple Frog:</b><br>Target Space Player must NOT have a Purple Frog ready to deploy: <br><br>";


  TargetHasPurpleFrog(SerializableScene scene) : super(scene) {

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
    return new TargetHasPurpleFrog(scene);
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
      if(p.landLevel <= -1 * p.session.goodFrogLevel) return false;
    }
    return true;
  }
}