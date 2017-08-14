import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Maid extends SBURBClass {
  List<String> levels =["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
  List<String> quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE","repairing various ways the session has been broken","protecting various consorts with game powers"];
  List<String> postDenizenQuests  = ["using their powers to help clean up the debris left from their Denizen actions. Who knew the term maid would be so literal","watching over the consorts as they begin to rebuild","following their consorts to ever larger pieces of debris","empowering an army of consorts to clean out the last of the debris from their Denizen"];
  List<String> handles =["meandering","motley","musing","mischievous","macabre", "maiden", "morose"];
  Maid() : super("Maid", 1, true);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return false;
  }

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 1.5;
  }

  @override
  double getAttackerModifier() {
    return 0.33;
  }

  @override
  double getDefenderModifier() {
    return 3.0;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }

}