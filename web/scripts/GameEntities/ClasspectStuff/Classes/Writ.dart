import '../../../SBURBSim.dart';
import "SBURBClass.dart";

class Writ extends SBURBClass {
  @override
  List<String> levels = ["SADDENED FOOLISH", "BOREDOM INCARNATE", "PHILOSPHO EXTREMO"];
  @override
  List<String> quests = ["travelling long distances while constantly fighting enemies.", "nearly reaching their aspect before something unexpected comes up.", "taking a motherfucking break and helping out with consorts."];
  @override
  List<String> postDenizenQuests = <String>["healing the land so they can access more parts of the land to heal.", "doing random fetch quests for consorts that manage to get things lost in hundred-floor dungeons.", "doing endless amounts of minor dungeons while waiting for consorts to need their help"];
  @override
  List<String> handles = ["wondering","whimsical","woeful"];

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