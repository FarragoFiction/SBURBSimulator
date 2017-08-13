import "SBURBClass.dart";
class Scribe extends SBURBClass {
  Scribe() : super("Scribe", 16, false);
  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }

}