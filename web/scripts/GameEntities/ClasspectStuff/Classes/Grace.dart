import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Grace extends SBURBClass {
  List<String> levels =["KNEEHIGH ROBINHOOD","DASHING DARTABOUT", "COMMUNIST COMMANDER"];
  List<String> quests = ["","",""];
  List<String> postDenizenQuests  = ["","","",""];
  List<String> handles =["sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic","savant"];
  Grace() : super("Grace", 18, false);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.isFromAspect) {
      powerBoost = powerBoost * 0;  //wasted aspect
    } else {
      powerBoost = powerBoost * 1;
    }
    return powerBoost;
  }

}