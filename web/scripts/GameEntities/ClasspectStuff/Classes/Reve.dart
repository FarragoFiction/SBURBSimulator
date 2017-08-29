import "../../GameEntity.dart";
import "SBURBClass.dart";

class Reve extends SBURBClass {


  Reve() : super("Reve", 18, true);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("sburbLore", 0.2, false)
  ]);

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
      powerBoost = powerBoost * 0.25;
    } else {
      powerBoost = powerBoost * -0.75;
    }
    return powerBoost;
  }

}