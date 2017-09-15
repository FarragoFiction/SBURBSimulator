import "../../GameEntity.dart";
import "SBURBClass.dart";

class Muse extends SBURBClass {
  @override
  List<String> levels = ["WEAK TULIP", "ADMIRABLE MAID", "THE BEST AROUND"];
  @override
  List<String> quests = ["feeling the true pain of being a muse, involving being whacked around like a fucking volleyball", "getting attacked by a giant orc, accidentally dealing a super powered attack... muses are awesome!", "avoiding angry consorts who, for whatever reason, fucking hate muses"];
  @override
  List<String> postDenizenQuests = ["healing all damage dealt by their probably innocent denizen, oops", "being very self conscious about looks, personality, etc", "crying over having to murder an innocent denizen, wishing at the same time you could end these horrid consorts"];
  @override
  List<String> handles = ["meandering", "motley", "musing", "mischievous", "macabre", "maiden", "morose"];

  Muse() : super("Muse", 19, true);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return false;
  }

  @override
  num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 3.5;
  }

  @override
  double powerBoostMultiplier = 3.0;

  @override
  double getAttackerModifier() {
    return 0.1;
  }

  @override
  double getDefenderModifier() {
    return 5.0;
  }

  @override
  double getMurderousModifier() {
    return 0.5;
  }

}