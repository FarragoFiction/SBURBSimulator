class SBURBClassManager {
  //static SBURBClass KNIGHT = new ClassKnight();
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

  String name;
  int id;  //for classNameToInt
  bool isCanon = false; //you gotta earn canon, baby.




  SBURBClass(this.name, this.id, this.isCanon) {
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