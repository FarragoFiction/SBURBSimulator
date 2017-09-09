import "../../../SBURBSim.dart";
import "SBURBClass.dart";

class Dame extends SBURBClass {

  @override
  List<String> levels = ["PRETTY PRINCESS", "DAMSEL IN DIS DRESS", "UGLY FIDO"];
  @override
  List<String> quests = [
    "performing embarassing acts, such as cleaning a consorts house",
    "doing dame like things, ya know?",
    "attempting to master their powers and completely failing"
  ];
  @override
  List<String> postDenizenQuests = [
    "cleaning up ALL consort houses that have been damage (this class sucks)",
    "realizing a special power activates upon their death",
    "finally getting the hang of their powe- nevermind, they fucked up"
  ];
  @override
  List<String> handles = [
    "deadly",
    "dancing",
    "destroying",
    "detrimental",
    "decieving",
    "diluted",
    "desolate"
  ];


  Dame() : super("Dame", 20, true);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }

  @override
  // ignore: expected_token
  double powerBoostMultiplier = 0.5;

  @override
  double getAttackerModifier() {
    return 0.5;
  }

  @override
  double getDefenderModifier() {
    return 0.5;
  }

  @override
  double getMurderousModifier() {
    return 0.5;
  }

}