import "SBURBClass.dart";
import "../../player.dart";
import "../../GameEntity.dart";
class Grace extends SBURBClass {
  @override
  List<String> levels =["KNEEHIGH ROBINHOOD","DASHING DARTABOUT", "COMMUNIST COMMANDER"];
  @override
  List<String> handles =["sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic","savant"];
  Grace() : super("Grace", 17, false);

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