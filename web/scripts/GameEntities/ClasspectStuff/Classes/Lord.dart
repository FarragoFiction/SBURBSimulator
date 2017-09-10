import "../../GameEntity.dart";
import "SBURBClass.dart";

class Lord extends SBURBClass {
  @override
  List<String> levels = [
    "Psychopatcic Overlord", "Probable Killer", "Donald Trump"];
  @override
  List<String> quests = [
    "demonstrating force to gain an entire army of consort followers. They really suck.",
    "abusing their aspect in any way possible to complete quests early.",
    "thinking of all the players they hate, cursing them and trying to prove they're the worst"
  ];
  @override
  List<String> postDenizenQuests = [
    "complaining and complaining and complaining! Shut up!",
    "admring their new aquired strength in front of a mirror",
    "stealing a lollipop from a little consort. What a monster."
  ];
  @override
  List<String> handles = [
    "laborsavinig", "lacking", "lamented", "lame", "landscaped", "likeable"];

  Lord() : super("Lord", 18, true);

  @override
  bool highHinit() {
    return true;
  }

  @override
  double powerBoostMultiplier = 3.0;

  @override
  double getAttackerModifier() {
    return 5.0;
  }

  @override
  double getDefenderModifier() {
    return 2.0;
  }

  @override
  double getMurderousModifier() {
    return 10.0;
  }

}