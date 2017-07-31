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
List<SessionSummary> testSessionSummaries;
List<SessionSummaryJunior> testSessionSummaryJuniors;

main() {
  print("Hello World");
  jRAssert("initialTest", "this should always pass", "this should always pass");
  testCreateSummary();
  testCollateSummaries();

}

void setup() {
  testSessionSummaries = []; //reset
  testSessionSummaryJuniors = [];
  Session testSession = new Session(0);
  testSession.setUpBosses();
  testSession.players = [];
  testSessionSummaries.add(testSession.generateSummary());
  testSessionSummaries.add(testSession.generateSummary());
  testSessionSummaries.add(testSession.generateSummary());
  for(SessionSummary s in testSessionSummaries) {
    testSessionSummaryJuniors.add(s.getSessionSummaryJunior());
  }
}

void testCreateSummary() {
  setup();
  //can't call regular html cuz gets widnow param like an asshole.
  print(testSessionSummaries[0].generateNumHTML());
  print(testSessionSummaries[0].generateBoolHTML());

}

void testCollateSummaries() {
  setup();
  MultiSessionSummaryJunior mssj = MultiSessionSummaryJunior.collateMultipleSessionSummariesJunior(testSessionSummaryJuniors);
  print(mssj.generateHTML());
}