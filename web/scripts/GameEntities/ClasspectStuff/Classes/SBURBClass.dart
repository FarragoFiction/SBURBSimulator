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
import "Waste.dart";
import "Scout.dart";
import "Scribe.dart";
import "Sage.dart";
import "Guide.dart";
import "Grace.dart";


class SBURBClassManager {
  static SBURBClass KNIGHT;
  static SBURBClass SEER;
  static SBURBClass BARD;
  static SBURBClass HEIR;
  static SBURBClass MAID;
  static SBURBClass ROGUE;
  static SBURBClass PAGE;
  static SBURBClass THIEF;
  static SBURBClass SYLPH;
  static SBURBClass PRINCE;
  static SBURBClass WITCH;
  static SBURBClass MAGE;
  static SBURBClass WASTE;
  static SBURBClass SCOUT;
  static SBURBClass SAGE;
  static SBURBClass SCRIBE;
  static SBURBClass GUIDE;
  static SBURBClass GRACE;

  //did you know that static attributes are lazy loaded, and so you can't access them until
  //you interact with the class? Yes, this IS bullshit, thanks for asking!
  static void init() {
    KNIGHT = new Knight();
    SEER = new Seer();
    BARD = new Bard();
    HEIR = new Heir();
    MAID = new Maid();
    ROGUE = new Rogue();
    PAGE = new Page();
    THIEF = new Thief();
    SYLPH = new Sylph();
    PRINCE = new Prince();
    WITCH = new Witch();
    MAGE = new Mage();
    WASTE = new Waste();
    SCOUT = new Scout();
    SCRIBE = new Scribe();
    SAGE = new Sage();
    GUIDE = new Guide();
    GRACE = new Grace();
  }

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
    print("Making a sburb class ${this.name}");
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