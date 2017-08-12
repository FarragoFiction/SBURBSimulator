import "Knight.dart";
import "Seer.dart";
import "Bard.dart";
import "Heir.dart";
import "Maid.dart";
import "Rogue.dart";
import "Page.dart";
import "Thief.dart";
import "Sylph.dart";
import "Prince.dart";
import "Witch.dart";
import "Mage.dart";


class SBURBClassManager {
  static SBURBClass KNIGHT = new Knight();
  static SBURBClass SEER = new Seer();
  static SBURBClass BARD = new Bard();
  static SBURBClass HEIR = new Heir();
  static SBURBClass MAID = new Maid();
  static SBURBClass ROGUE = new Rogue();
  static SBURBClass PAGE = new Page();
  static SBURBClass THIEF = new Thief();
  static SBURBClass SYLPH = new Sylph();
  static SBURBClass PRINCE = new Prince();
  static SBURBClass WITCH = new Witch();
  static SBURBClass MAGE = new Mage();

  static List<SBURBClass> _classes = []; // gets filled by class constrcutor
  static Iterable<SBURBClass> get canon => _classes.where((SBURBClass c) => c.isCanon);
  static Iterable<SBURBClass> get fanon => _classes.where((SBURBClass c) => !c.isCanon);

  static void addClass(SBURBClass c) {
      _classes.add(c);
  }

  static List<SBURBClass> get allClasses => new List<SBURBClass>.from(_classes);

}

//instantiatable for Null classes.
class SBURBClass {

  String name = "Null";
  int id = 256;  //for classNameToInt
  bool isCanon = false; //you gotta earn canon, baby.


  SBURBClass(this.name, this.id, this.isCanon) {
    print("Making a sburb class $this.name");
    SBURBClassManager.addClass(this);
  }
  List<String> levels = ["SNOWMAN SAVIOR","NOBODY NOWHERE","NULLZILLA"];
  List<String> quests = ["definitely doing class related quests", "solving consorts problems in a class themed manner", "absolutely not goofing off"];
  List<String> postDenizenQuests = ["cleaning up after their Denizen in a class approrpiate fashion","absolutly not goofing off instead of cleaing up after their Denizen","vaguely sweeping up rubble"];
  List<String> handles = ["nothing","never","mysterious","nebulous","null","missing","negative"];



  bool hasInteractionEffect() {
      return false;
  }

  void processStatInteractionEffect() {

  }

  num  modPowerBoostByClass() {

  }

  double getAttackerModifier() {
    return 1.0;
  }

  double getMurderousModifier() {
    return 1.0;
  }

  double getDefenderModifier() {
    return 1.0;
  }

  double getPVPModifier() {
    return 1.0;
  }

  bool highHinit() {
    return false;
  }

  void intializeAssociatedClassStatReferences() {

  }


}