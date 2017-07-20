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

}

testCreation() {
  setup();
  print(testStrife);
}

setup() {
  List<Team> t  = new List<Team>();
  t.add(new Team(disastor_objects.subset(0,3)));
  t.add(new Team(fortune_objects.subset(0,5)));
  testStrife = new Strife(t);
}