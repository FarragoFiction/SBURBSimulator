/*import 'dart:math' as Math;
import 'dart:typed_data';

import "../web/scripts/SBURBSim.dart";
import "JRTestSuite.dart";

/*part "JRTestSuite.dart";
part "../web/scripts/GameEntities/GameEntity.dart";
part "../web/scripts/GameEntities/NPCs.dart";
part "../web/scripts/GameEntities/player.dart";
part "../web/scripts/session.dart";
part "../web/scripts/fraymotif.dart";
part "../web/scripts/random_tables.dart"; //needed for global functions
part "../web/scripts/random.dart";
part "../web/scripts/v2.0/YellowYardResultController.dart";
part "../web/scripts/Afterlife.dart";
part "../web/scripts/SessionSummary.dart";
part "../web/scripts/Scenes/Scene.dart";*/


//need to make sure AB will work BEFORE spending all that effort gettering her html page working again
List<SessionSummary> testSessionSummaries;
List<SessionSummaryJunior> testSessionSummaryJuniors;

main() {
  //print("Hello World");
  jRAssert("initialTest", "this should always pass", "this should always pass");
  testCreateSummary();
  testCollateSummaries();

}

void setup() {
  testSessionSummaries = []; //reset
  testSessionSummaryJuniors = [];
  Session testSession = new Session(0);
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
  //print(testSessionSummaries[0].generateNumHTML());
  //print(testSessionSummaries[0].generateBoolHTML());

}

void testCollateSummaries() {
  setup();
  MultiSessionSummaryJunior mssj = MultiSessionSummaryJunior.collateMultipleSessionSummariesJunior(testSessionSummaryJuniors);
  //print(mssj.generateHTML());
}
*/