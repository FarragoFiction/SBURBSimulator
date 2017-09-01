//import '../SBURBSim.dart';// show GameEntity;  //Yep, requires whole library to compile can't just test GameEntity.
import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as Math;

import "../web/scripts/SBURBSim.dart";
import "JRTestSuite.dart";


var testGE = null;
main() {
  //print("Hello World");
  testName();
  testID();
  testStats(); //when i do this for players, make sure relationships are being added right.
  testBuffs();
  testLuck();
}

setup() {
  testGE = new GameEntity("Firsty Testy", new Session(0));
}

testName() {
  setup();
  //print(testGE.name);
  assert(testGE.name == "Firsty Testy");
  jRAssert("toString", testGE.toString(),
      "FirstyTesty"); //to string gets rid of spaces, which is apparently important because sometimes use it for div.
  //print("Name passed");
}

testID() {
  setup();
  //print(testGE.id);
  assert(
      testGE.id > 0 ? true : throw "ID should be greater than zero, but is: ${testGE.id}");
  //print("Id passed");
}

testStats() {
  setup();
  //print(testGE.stats);
  assert(testGE.getStat("hp") == 0
      ? true
      : throw "initial hp should be 0, but is: ${testGE..getStats("hp")}");
  testGE.setStatsHash(<String,num>{"hp": 100, "currentHP": 10, "power": 3, "maxLuck": 100});
  jRAssert("hp", testGE.getStat("hp"), 100);
  jRAssert("currentHP", testGE.getStat("currentHP"),
      100); //even though i set it to 10, setSTatsHash should not let it e less than HP
  jRAssert("power", testGE.getStat("power"), 3);
  jRAssert("maxLuck", testGE.getStat("maxLuck"), 100);
  jRAssert("minLuck", testGE.getStat("minLuck"), 0); //confirm did not change.
  jRAssert("sanity", testGE.getStat("sanity"), 0); //confirm did not change.
  jRAssert("alchemy", testGE.getStat("alchemy"), 0); //confirm did not change.
  jRAssert("RELATIONSHIPS", testGE.getStat("RELATIONSHIPS"),
      0); //confirm did not change.
  jRAssert("freeWill", testGE.getStat("freeWill"), 0); //confirm did not change.
  jRAssert("mobility", testGE.getStat("mobility"), 0); //confirm did not change.
  //print(testGE.stats);
  testGE.setStat("hp", 50);
  jRAssert("hp", testGE.getStat("hp"), 50);
  testGE.addStat("hp", 5000);
  jRAssert("hp", testGE.getStat("hp"), 5050);
  try {
    testGE.setStat("bogus413", 345); //test that it throws an error
  }catch(exception, stackTrace) {
    //print("Exception: $exception caught as expected for setting a stat.");
  }

  try {
    testGE.addStat("bogus413", 345); //test that it throws an error
  }catch(exception) {
    //print("Exception: $exception caught as expected for adding a stat.");
  }

  testGE.setStat("power", 0);
  testGE.permaBuffs["MANGRIT"] = 10;
  jRAssert("power (taking into account MANGRIT)", testGE.getStat("power"), 10); //TODO implement MANGRIT
  //print("Stats passed");
}

void testBuffs() {
  setup();
  jRAssert("currentHP", testGE.getStat("currentHP"), 0);
  jRAssert("number of buffs", testGE.buffs.length, 0);
  jRAssert("buffs for hp", testGE.getTotalBuffForStat("currentHP"), 0);
  BuffOld hpBuff1 = new BuffOld("currentHP", 10);
  testGE.buffs.add(hpBuff1); //TODO maybe eventaully should be a funciton instead of exposed array.
  jRAssert("number of buffs", testGE.buffs.length, 1);
  jRAssert("buffs for hp", testGE.getTotalBuffForStat("currentHP"), 10);
  BuffOld hpBuff2 = new BuffOld("currentHP", 5);
  testGE.buffs.add(hpBuff2);
  jRAssert("number of buffs", testGE.buffs.length, 2);
  jRAssert("buffs for hp", testGE.getTotalBuffForStat("currentHP"), 15);
  jRAssert("functional hp", testGE.getStat("currentHP"), 15); //functional is a pun, cuz it is both FROM a function AND the working value of hp (but not actual). I am the BEST at jokes.
  jRAssert("real hp", testGE.stats["currentHP"], 0); //real hp is unmodified.
  jRAssert("glitch stat", testGE.stats["bogus413"], null); //how are glitchy things handled? good, don't want it to appear to be working when it's not.
  //print(testGE.describeBuffs());
  testGE.buffs
    ..add(new BuffOld("minLuck", 5))
    ..add(new BuffOld("MANGRIT", 5))
    ..add(new BuffOld("mobility", 5))
    ..add(new BuffOld("alchemy", 5));
  //print(testGE.describeBuffs()); //not gonna try to do unit testing for a narrative thing but at least call it and make sure it doesn't crash.
  testGE.buffs = <BuffOld>[];
  testGE.buffs
    ..add(new BuffOld("minLuck", -5))
    ..add(new BuffOld("MANGRIT", -5))
    ..add(new BuffOld("mobility", -5))
    ..add(new BuffOld("alchemy", -5));
  //print(testGE.describeBuffs());

  //print("Buffs passed");
}

//do you feel lucky, punk?
void testLuck() {
  setup();
  testGE.setStatsHash(<String,num>{"minLuck": -100,"maxLuck": 100});
  num roll = testGE.rollForLuck("");
  assert((roll < 100 && roll > -100)); //expect this to fail, for now. random numbers don't REALLY work yet.
}


int canvasWidth;
int canvasHeight;
bool simulationMode;