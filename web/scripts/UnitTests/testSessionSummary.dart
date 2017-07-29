import 'dart:math' as Math;
import 'dart:typed_data';

part "JRTestSuite.dart";
part "../GameEntities/GameEntity.dart";
part "../GameEntities/NPCs.dart";
part "../GameEntities/Player.dart";
part "../session.dart";
part "../fraymotif.dart";
part "../random_tables.dart"; //needed for global functions
part "../random.dart";
part "../v2.0/YellowYardResultController.dart";
part "../Afterlife.dart";
part "../sessionSummary.dart";
part "../Scenes/Scene.dart";


//need to make sure AB will work BEFORE spending all that effort gettering her html page working again
SessionSummary testSessionSummary;

main() {
  print("Hello World");
  jRAssert("initialTest", "this should always pass", "this should always pass");
  testCreateSummary();

}

void setup() {
  Session testSession = new Session(0);
  testSession.setUpBosses();
  testSession.players = [];
  testSessionSummary = testSession.generateSummary();
}

void testCreateSummary() {
  setup();

}