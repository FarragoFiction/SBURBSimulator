import "../../GameEntity.dart";
import "SBURBClass.dart";

class Bro extends SBURBClass {
  Bro() : super("Bro", 18, false);
  @override
  List<String> levels = ["BROBLERONE", "BROTEL RWANDA", "BRO-YO MA"];
  @override
  List<String> quests = [
    "busting out, and I quote, 'the mad stunts all wicked up-ins'",
    "trying to get hella pumped about houses or some noise",
    "getting mud on their doll's dress or whatever"
  ];
  @override
  List<String> postDenizenQuests = [
    "not actually playing the game, but giving it 1.5 out of 5 hats to keep it real",
    "giving a shout out to their boy Dennis who was over the other day",
    "helping their consorts live off the land, for big ups to Mother Earth, yo",
    "getting so wasted. haha, I mean DAMN"
  ];
  @override
  List<String> handles = ["Brother", "Bored", "Bugger", "Badass", "Bothersome"];

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(
      <AssociatedStat>[
        new AssociatedStat("sburbLore", 1.5, false),//dennis was so wasted. ha ha, i mean damn.
        new AssociatedStat("MANGRIT", 3.0, false), //"But all im saying is, when do you get to THRASH something?"
        new AssociatedStat("RELATIONSHIPS", -0.5, false)//It wasn't a long fall, but hey I guess a thumb bone wasn't made for supporting the brunt of a huge useless tool against wet grass.
      ]);

  @override
  double aspectQuestChance = 0.1; //bros dont want to develop as a player of X, they want to develop as a Bro.

  @override
  num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.isFromAspect) {
      if (stat.multiplier > 0) {
        powerBoost = powerBoost * -1.0; //positive boosts become negative.
      } else {
        powerBoost = powerBoost * 1.5; //negative boosts become more significant.
      }
    } else {
      powerBoost = powerBoost * 1.0;
    }
    return powerBoost;
  }

  @override
  double powerBoostMultiplier = 2.0; //they don't have many quests, but once they get going they are hard to stop.

  @override
  double getAttackerModifier() {
    return 2.0;
  }

  @override
  double getDefenderModifier() {
    return 2.0;
  }

  @override
  double getMurderousModifier() {
    return 2.0;
  }
}
