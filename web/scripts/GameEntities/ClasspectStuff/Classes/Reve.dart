import "../../GameEntity.dart";
import "SBURBClass.dart";

class Reve extends SBURBClass {


  Reve() : super("Guide", 16, false);

  @override
  num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.25;
    } else {
      powerBoost = powerBoost * 0.25;
    }
    return powerBoost;
  }

}