import "SBURBClass.dart";
class Scout extends SBURBClass {
  Scout() : super("Scout", 13, false);
  @override
  List<String> levels =["BOSTON SCREAMPIE","COOKIE OFFERER","FIRE FRIEND"];
  @override
  List<String> quests = ["exploring areas no Consort has dared to trespass in","getting lost in ridiculously convoluted mazes","playing map-creating mini games"];
  @override
  List<String> postDenizenQuests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat","looking for rare treasures that are no longer being guarded by the Denizen"];
  @override
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