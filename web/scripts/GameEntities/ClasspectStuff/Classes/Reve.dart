import "../../GameEntity.dart";
import "SBURBClass.dart";

class Reve extends SBURBClass {


  Reve() : super("Reve", 18, false);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }

  @override
  num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.1;
    } else {
      powerBoost = powerBoost * -0.9;
    }
    return powerBoost;
  }

}