import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Knight extends SBURBClass {
  Knight() : super("Knight", 4, true);

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
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.5;
    } else {
      powerBoost = powerBoost * -0.5;
    }
    return powerBoost;
  }

  @override
  double getAttackerModifier() {
    return 1.0;
  }

  @override
  double getDefenderModifier() {
    return 2.5;
  }

  @override
  double getMurderousModifier() {
    return 0.75;
  }

}