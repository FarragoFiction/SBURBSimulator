import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as Math;
part "../GameEntities/GameEntity.dart";
part "../GameEntities/player.dart";
part "../GameEntities/NPCS.dart";
part "../Strife.dart";
part "../fraymotif.dart";
part "../random_tables.dart"; //needed for global functions
part "JRTestSuite.dart";



Strife testStrife = null;

main() {
  print("Hello World");
  jRAssert("initialTest", "this should always pass", "this should always pass");
  testCreation();
  //test choosing a target.
  //TODO find members of denizen fight.

  testMobilitySort();
  testChooseTarget();
}

void testMobilitySort() {
    setup();
    print("Before Sort, Teams are: ${Team.getTeamsNames(testStrife.teams)}");
    Team expectedSlowest = testStrife.teams[0];
    Team expectedFasted = testStrife.teams[1];
    testStrife.teams.sort();
    jRAssert("fastest team", testStrife.teams[0], expectedFasted);
    print("After Sort, Teams are: ${Team.getTeamsNames(testStrife.teams)}");
    GameEntity slug = expectedSlowest.members[0];
    jRAssert("slug name", slug.name, "Slug");
    expectedSlowest.members.sort();
    jRAssert("slowest member of slowest team", expectedSlowest.members[1], slug);
    print("mobility psases");
}

void testChooseTarget()
{
  setup();
  GameEntity attacker = testStrife.teams[0].members[1];
  jRAssert("attacker name", attacker.name, "Turtle");
  GameEntity target = attacker.pickATarget(testStrife.teams[1].members);
  jRAssert("target name", target.name, "DragonFly"); //can one shot it, even though it is faster than Hare.
  print("choose target passed");
}

void testCreation() {
  setup();
  print(testStrife);
  print("Teams are: ${Team.getTeamsNames(testStrife.teams)}");
}

void setup() {
  List<Team> t  = new List<Team>();
  t.add(new Team(null, makeSlowTeam()));
  t.add(new Team.withName("The Probably RainbowDrinkers",null, makeFastTeam()));
  testStrife = new Strife(null,t);
}

List<GameEntity> makeSlowTeam() {
  List<GameEntity> ret = [
  new PotentialSprite("Slug", 0, null)
    ..setStatsHash({"hp": 5, "mobility": -5000, "power": 100}),
  new PotentialSprite("Turtle", 0, null)
    ..setStatsHash({"hp": 500, "mobility": -500, "power": 100})
  ];
  return ret;

}

List<GameEntity> makeFastTeam() {
  List<GameEntity> ret = [
    new PotentialSprite("Hare", 0, null)
      ..setStatsHash({"hp": 500, "mobility": 500, "power": 100}),
    new PotentialSprite("Dragonfly", 0, null)
      ..setStatsHash({"hp": 5, "mobility": 5000, "power": 100})
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