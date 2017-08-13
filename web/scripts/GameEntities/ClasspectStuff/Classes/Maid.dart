import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Maid extends SBURBClass {
  Maid() : super("Maid", 1, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 1.5;
  }

}