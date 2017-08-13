import "SBURBClass.dart";
class Scout extends SBURBClass {
  Scout() : super("Scout", 14, false);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }



}