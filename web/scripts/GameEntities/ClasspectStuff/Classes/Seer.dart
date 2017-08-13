import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Seer extends SBURBClass {
  Seer() : super("Seer", 7, true);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return false;
  }

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 2;
    } else {
      powerBoost = powerBoost * 2.5;
    }
    return powerBoost;
  }

  @override
  double getAttackerModifier() {
    return 0.67;
  }

  @override
  double getDefenderModifier() {
    return 0.67;
  }

  @override
  double getMurderousModifier() {
    return 1.0;
  }

}