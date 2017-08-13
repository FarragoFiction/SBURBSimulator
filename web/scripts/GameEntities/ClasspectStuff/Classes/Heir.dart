import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Heir extends SBURBClass {
  Heir() : super("Heir", 9, true);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }


  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 1.5;
  }
  @override
  double getAttackerModifier() {
    return 0.5;
  }

  @override
  double getDefenderModifier() {
    return 2.0;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }


}