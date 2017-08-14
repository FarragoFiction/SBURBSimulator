import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Mage extends SBURBClass {
  @override
  List<String> levels =["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
  @override
  List<String> quests = ["performing increasingly complex alchemy for demanding, moody consorts","learning to silence their Mage Senses long enough to not go insane","learning to just let go and let things happen"];
  @override
  List<String> postDenizenQuests  = ["finding yet another series of convoluted puzzles, buried deep in their land. These puzzles pour poison into the land, and will continue to do so until solved","realizing the voices are gone. Not just quiet, but… gone. Without them, they can finally get down to work on their land puzzles","solving the more of the puzzles of their land. Not that that's the end of the horseshit, but hey! Less horseshit always helps","getting sick to death of puzzles and just utterly annihilating one with their game powers"];
  @override
  List<String> handles =["magnificent","managerial","major","majestic","mannerly", "malignant", "morbid"];
  Mage() : super("Mage", 3, true);



  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 2;
    } else {
      powerBoost = powerBoost * 2.5;
    }
    return powerBoost;
  }

  @override
  double getAttackerModifier() {
    return 0.67;
  }

  @override
  double getDefenderModifier() {
    return 0.67;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }

}