import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Page extends SBURBClass {
  Page() : super("Page", 2, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 2;
    } else {
      powerBoost = powerBoost * 0.5;
    }
    return powerBoost;
  }

}