import "SBURBClass.dart";
import "../../player.dart";
import "../../GameEntity.dart";
class Sage extends SBURBClass {
  Sage() : super("Sage", 14, false);
  @override
  List<String> levels =["HERBAL ESSENCE","CHICKEN SEASONER","TOMEMASTER"];
  @override
  List<String> quests = ["making the lore of SBURB part of their personal mythos","learning to nod wisely and remain silent when Consorts start yammering on about the Ultimate Riddle","participating in riddle contests to prove their intelligence to local Consorts"];
  @override
  List<String> postDenizenQuests = ["learning everything there is learn about the Denizen, now that it is safely defeated","learning what Consort civilization was like before the Denizen, to better help them return to 'normal'","demonstrating to the local Consorts the best way to move on from the tyranny of the Denizen"];
  @override
  List<String> handles =["serious", "sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic","savant"];


  @override
  void intializeAssociatedClassStatReferences(Player p) {
    p.associatedStats.add(new AssociatedStat("sburbLore", 0.5, false));
  }

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return false;
  }

}