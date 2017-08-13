import "SBURBClass.dart";
class Guide extends SBURBClass {
  Guide() : super("Guide", 17, false);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return false;
  }

}