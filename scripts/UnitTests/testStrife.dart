import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as Math;
part "../GameEntities/GameEntity.dart";
part "../GameEntities/NPCS.dart";
part "../Strife.dart";
part "../random_tables.dart"; //needed for global functions
part "JRTestSuite.dart";

/*
  TODO: Form two teams of NPCs.  Make a Strife instance out of them.  Use them to test all features.
*/

Strife testStrife = null;

main() {
  print("Hello World");
  testCreation();
  //TODO test sorting teams by mobility.
  //test choosing a target.
  //test draining a ghost.


}

testCreation() {
  setup();
  print(testStrife);
}

setup() {
  List<Team> t  = new List<Team>();
  t.add(new Team(disastor_objects.subset(0,3)));
  t.add(new Team(fortune_objects.subset(0,5)));
  testStrife = new Strife(null,t);
}


Session curSessionGlobalVar;
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