import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as Math;

import "../web/scripts/SBURBSim.dart";
import "JRTestSuite.dart";

/*part "../web/scripts/GameEntities/GameEntity.dart";
part "../web/scripts/GameEntities/player.dart";
part "../web/scripts/GameEntities/NPCS.dart";
part "../web/scripts/Strife.dart";
part "../web/scripts/fraymotif.dart";
part "../web/scripts/random_tables.dart"; //needed for global functions
part "JRTestSuite.dart";
part "../web/scripts/Afterlife.dart";

part "../web/scripts/random.dart";
part "../web/scripts/v2.0/YellowYardResultController.dart";*/


Strife testStrife = null;

main() {
  //print("Hello World");
  jRAssert("initialTest", "this should always pass", "this should always pass");
  testCreation();
  testKillEveryone();
  //test choosing a target.
  //TODO find members of denizen fight.

  testMobilitySort();
  testChooseTarget();
  //TODO I WANT to use test fraymotif's being single use per battle here, but not sure how to do it without hitting a div append.
  //TODO probably should refactor strifes to only do a single div append from an accumulated list of shit
  //easier to debug, and more efficient than lots of little appends
}

//dear sweet precious sweet sweet AuthorBot is getting into an infinite loop
//and me saving her causes ANOTHER loop because apparently
//i don't have the true form of "rocks fall" yet
void testKillEveryone() {
    setup();
    GameEntity testGE = testStrife.teams[0].members[0];
    jRAssert("random member of strife should be alive", testGE.dead, false);
}

void testMobilitySort() {
    setup();
    //print("Before Sort, Teams are: ${Team.getTeamsNames(testStrife.teams)}");
    Team expectedSlowest = testStrife.teams[0];
    Team expectedFasted = testStrife.teams[1];
    testStrife.teams.sort();
    jRAssert("fastest team", testStrife.teams[0], expectedFasted);
    //print("After Sort, Teams are: ${Team.getTeamsNames(testStrife.teams)}");
    GameEntity slug = expectedSlowest.members[0];
    jRAssert("slug name", slug.name, "Slug");
    expectedSlowest.members.sort();
    jRAssert("slowest member of slowest team", expectedSlowest.members[1], slug);
    //print("mobility psases");
}

void testChooseTarget()
{
  setup();
  GameEntity attacker = testStrife.teams[0].members[1];
  jRAssert("attacker name", attacker.name, "Turtle");
  GameEntity target = attacker.pickATarget(testStrife.teams[1].members);
  jRAssert("target name", target.name, "Dragonfly"); //can one shot it, even though it is faster than Hare.
  //print("choose target passed");
}

void testCreation() {
  setup();
  //print(testStrife);
  //print("Teams are: ${Team.getTeamsNames(testStrife.teams)}");
}

void setup() {
  List<Team> t  = new List<Team>();
  t.add(new Team(null, makeSlowTeam()));
  t.add(new Team.withName("The Probably RainbowDrinkers",null, makeFastTeam()));
  testStrife = new Strife(null,t);
}

List<GameEntity> makeSlowTeam() {
  List<GameEntity> ret = [
  new PotentialSprite("Slug", null)
    ..stats.setMap(<Stat,num>{Stats.HEALTH: 5, Stats.MOBILITY: -5000, Stats.POWER: 100}),
  new PotentialSprite("Turtle", null)
    ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.MOBILITY: -500, Stats.POWER: 100})
  ];
  return ret;

}

List<GameEntity> makeFastTeam() {
  List<GameEntity> ret = [
    new PotentialSprite("Hare", null)
      ..stats.setMap(<Stat,num>{Stats.HEALTH: 500, Stats.MOBILITY: 500, Stats.POWER: 100}),
    new PotentialSprite("Dragonfly", null)
      ..stats.setMap(<Stat,num>{Stats.HEALTH: 5, Stats.MOBILITY: 5000, Stats.POWER: 100})
  ];
  return ret;
}


int canvasWidth;
int canvasHeight;
bool simulationMode;

T getRandomElementFromArray<T>(List<T> list) {
  return list[0];
}

int getRandomInt(int lower, int upper) {
  return lower;
}

int getRandomIntNoSeed(int lower, int upper) {
  return lower;
}

double seededRandom() {
  return 0.0;
}

double random() {
  return 0.0;
}

//placeholder for now. need a way to know "what is the next random number in the list without using that number"
double seed() {

}