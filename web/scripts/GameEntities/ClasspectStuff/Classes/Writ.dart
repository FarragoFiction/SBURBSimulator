import '../../../SBURBSim.dart';
import "SBURBClass.dart";

class Writ extends SBURBClass {


    Writ() : super("Writ", 19, true);

   @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }

    static List<String> _randomStats = Player.playerStats.toList()
      ..remove("power")
      ..add("MANGRIT");

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
      new AssociatedStatRandom(_randomStats, 2, true), //really good at one thing
      new AssociatedStatRandom(_randomStats, -1, true), //hit to another thing.
    ]);

  @override
  num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.isFromAspect) {
      powerBoost = powerBoost * 0.25;
    } else {
      powerBoost = powerBoost * 0.75;
    }
    return powerBoost;
  }

}