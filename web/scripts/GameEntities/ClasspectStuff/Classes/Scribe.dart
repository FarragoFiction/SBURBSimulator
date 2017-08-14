import "SBURBClass.dart";
class Scribe extends SBURBClass {
  Scribe() : super("Scribe", 16, false);
  List<String> levels =["MIDNIGHT BURNER","WRITER WATCHER","DIARY DEAREST"];
  List<String> quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts","playing typing themed mini games.","saving an important piece of a riddle from a crumbling building"];

  List<String> postDenizenQuests  = ["documenting the various Consorts lost to the Denizen.","writing up a recovery plan for the Local Consorts","figuring out the best way to explain how to recover from the ravages of Denizen"];

  List<String> handles =["sightly","sanctimonious","sarcastic","sassy","scintillating","synergistic","savant"];
  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }

}