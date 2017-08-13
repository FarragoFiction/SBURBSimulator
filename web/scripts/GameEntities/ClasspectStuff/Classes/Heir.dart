import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Heir extends SBURBClass {
  Heir() : super("Heir", 9, true);
  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 1.5;
  }

}