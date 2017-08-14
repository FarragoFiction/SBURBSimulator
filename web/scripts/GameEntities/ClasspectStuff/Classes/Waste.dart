import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Waste extends SBURBClass {
  List<String> levels =["4TH WALL AFICIONADO","CATACLYSM COMMANDER","AUTHOR"];
  List<String> quests = ["being a useless piece of shit and reading FAQs to skip the hard shit in levels","causing ridiculous amounts of destruction trying to skip quest lines","learning that sometimes you have to do things right, and can't just skip ahead"];
  List<String> postDenizenQuests =["figuring out the least-disruptive way to help the local Consorts recover from the Denizen's rule","being a useless piece of shit and not joining cleanup efforts.","accidentally causing MORE destruction in an attempt to help clean up after their epic as fuck fight agains their Denizen"];
  List<String> handles =["wasteful","worrying","wacky","withering","worldly","weighty"];
  Waste() : super("Waste", 13, false);

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
    if (stat.isFromAspect) {
      powerBoost = powerBoost * 0;  //wasted aspect
    } else {
      powerBoost = powerBoost * 1;
    }
    return powerBoost;
  }

}