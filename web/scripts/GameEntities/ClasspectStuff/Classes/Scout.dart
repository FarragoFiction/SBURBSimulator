import "SBURBClass.dart";
class Scout extends SBURBClass {
  Scout() : super("Scout", 14, false);
  List<String> levels =["BOSTON SCREAMPIE","COOKIE OFFERER","FIRE FRIEND"];
  List<String> quests = ["exploring areas no Consort has dared to trespass in","getting lost in ridiculously convoluted mazes","playing map-creating mini games"];

  List<String> postDenizenQuests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat","looking for rare treasures that are no longer being guarded by the Denizen"];

  List<String> handles =["surly","sour","sweet","stylish","soaring", "serene", "salacious"];

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }



}