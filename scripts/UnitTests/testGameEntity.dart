//import '../SBURBSim.dart';// show GameEntity;  //Yep, requires whole library to compile can't just test GameEntity.
import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as Math;
part "../GameEntities/GameEntity.dart"; //internet says "part" is functionally like saying "pretend this thing is literally line for line right here".

var testGE = null;
main() {
  print("Hello World");
  testName();
  testID();
  testStats();
  testBuffs();
}

setup() {
  testGE = new GameEntity("Firsty Testy", 413, null);
}

testName() {
  setup();
  print(testGE.name);
  assert(testGE.name == "Firsty Testy");
  jRAssert("toString", testGE.toString(), "FirstyTesty"); //to string gets rid of spaces, which is apparently important because sometimes use it for div.
  print("Name passed");
}

testID() {
  setup();
  print(testGE.id);
  assert(testGE.id == 413 ? true : throw "ID should be 413, but is: ${testGE.id}");
  print("Id passed");
}

testStats() {
  setup();
  print(testGE.stats);
  assert(testGE.getStat("hp") == 0 ? true : throw "initial hp should be 0, but is: ${testGE..getStats("hp")}");
  testGE.setStatsHash({"hp": 100, "currentHP":10, "power":3, "maxLuck": 100});
  jRAssert("hp", testGE.getStat("hp"), 100);
  jRAssert("currentHP", testGE.getStat("currentHP"), 100); //even though i set it to 10, setSTatsHash should not let it e less than HP
  jRAssert("power", testGE.getStat("power"), 3);
  jRAssert("maxLuck", testGE.getStat("maxLuck"), 100);
  jRAssert("minLuck", testGE.getStat("minLuck"), 0);  //confirm did not change.
  jRAssert("sanity", testGE.getStat("sanity"), 0);  //confirm did not change.
  jRAssert("alchemy", testGE.getStat("alchemy"), 0);  //confirm did not change.
  jRAssert("RELATIONSHIPS", testGE.getStat("RELATIONSHIPS"), 0);  //confirm did not change.
  jRAssert("freeWill", testGE.getStat("freeWill"), 0);  //confirm did not change.
  jRAssert("mobility", testGE.getStat("mobility"), 0);  //confirm did not change.
  print(testGE.stats);
  testGE.setStat("hp", 50);
  jRAssert("hp", testGE.getStat("hp"), 50);
  testGE.addStat("hp", 5000);
  jRAssert("hp", testGE.getStat("hp"), 5050);
  print("Stats passed");
}

testBuffs() {
  setup();
  jRAssert("hp", testGE.getStat("hp"), 0);
  jRAssert("number of buffs",testGE.buffs.length, 0);
  jRAssert("buffs for hp",testGE.getTotalBuffForStat("hp"), 0);
  var hpBuff1 = new Buff("hp", 10);
  testGE.buffs.add(hpBuff1); //TODO maybe eventaully should be a funciton instead of exposed array.
  jRAssert("number of buffs",testGE.buffs.length, 1);
  jRAssert("buffs for hp",testGE.getTotalBuffForStat("hp"), 10);
  var hpBuff2 = new Buff("hp", 5);
  testGE.buffs.add(hpBuff2);
  jRAssert("number of buffs",testGE.buffs.length, 2);
  jRAssert("buffs for hp",testGE.getTotalBuffForStat("hp"), 15);
  jRAssert("functional hp", testGE.getStat("hp"), 15); //functional is a pun, cuz it is both FROM a function AND the working value of hp (but not actual). I am the BEST at jokes.
  jRAssert("real hp", testGE.stats["hp"], 0);  //real hp is unmodified.
  print("Buffs passed");
}


//this is how i want asserts to work
jRAssert(name, tested, expected)
{
  assert(tested == expected ? true : throw "${name} should be ${expected}, but is: ${tested}");
}

