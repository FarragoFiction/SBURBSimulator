
import "../../SBURBSim.dart";
import 'dart:html';

class SummonScene extends SerializableScene {
    @override
    String name = "Summon Scene";
  SummonScene(Session session) : super(session);

  @override
  void doAction() {
    throw("TODO: make this set my game entity to active");
  }
}