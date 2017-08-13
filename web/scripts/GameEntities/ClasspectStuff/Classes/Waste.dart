import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Waste extends SBURBClass {
  Waste() : super("Waste", 13, false);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }

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