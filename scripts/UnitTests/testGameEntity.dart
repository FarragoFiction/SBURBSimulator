//import '../SBURBSim.dart';// show GameEntity;  //Yep, requires whole library to compile can't just test GameEntity.
import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
part "../GameEntities/GameEntity.dart"; //internet says "part" is functionally like saying "pretend this thing is literally line for line right here".

var testGE = null;
main() {
  print("Hello World");
  testName();
  testID();
}

setup() {
  testGE = new GameEntity("Firsty", 413, null);
}

testName() {
  setup();
  print(testGE.name);
  assert(testGE.name == "Firsty");
}

testID() {
  setup();
  print(testGE.id);
  assert(testGE.id == 413 ? true : throw "ID should be 413, but is: ${testGE.id}");
}