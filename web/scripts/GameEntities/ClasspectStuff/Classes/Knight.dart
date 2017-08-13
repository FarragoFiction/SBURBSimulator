import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Knight extends SBURBClass {
  Knight() : super("Knight", 4, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.5;
    } else {
      powerBoost = powerBoost * -0.5;
    }
    return powerBoost;
  }

}