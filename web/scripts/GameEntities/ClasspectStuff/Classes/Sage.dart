import "SBURBClass.dart";
class Sage extends SBURBClass {
  Sage() : super("Sage", 15, false);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return false;
  }

}