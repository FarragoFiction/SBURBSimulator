import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Maid extends SBURBClass {
  Maid() : super("Maid", 1, true);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return false;
  }

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 1.5;
  }

  @override
  double getAttackerModifier() {
    return 0.33;
  }

  @override
  double getDefenderModifier() {
    return 3.0;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }

}