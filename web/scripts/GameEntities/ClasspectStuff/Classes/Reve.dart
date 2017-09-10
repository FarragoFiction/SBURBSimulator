import "../../GameEntity.dart";
import "SBURBClass.dart";

class Reve extends SBURBClass {


  Reve() : super("Reve", 21, true);
  @override
  List<String> levels = ["GRIM REVER", "BULLSHIT MAGICIAN", "SBURBAN REVERSAL"];
  @override
  List<String> quests = ["learning of SBURB's bullshit to better their ability to do tasks", "healing in an extremely bullshitty manner", "pulling off insane reality-bending tricks that nobody understands"];
  @override
  @override
  List<String> postDenizenQuests = <String>["just overall being a huge help to everyone on the land", "mastering their abilities and exploiting the shit out of them", "taking out underlings attempting to become a second denizen"];
  @override
  List<String> handles = ["reaping", "ruined", "reversed"];

  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("sburbLore", 0.1, false)
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

  @override
  double getAttackerModifier() {
    return 2.5;
  }

  @override
  double getDefenderModifier() {
    return 1.5;
  }

  @override
  double getMurderousModifier() {
    return 0.5;
  }

}