import "../web/scripts/GameEntities/ClasspectStuff/SBURBClass.dart";
import "JRTestSuite.dart";

SBURBClass globalSC;
main() {
  setup();
  testBasics();
}

void testBasics() {
  jRAssert("numberOfFanonClasses", SBURBClassManager.allClasses.length, 1);
  jRAssert("numberOfFanonClasses", SBURBClassManager.fanon.length, 1);
  jRAssert("numberOfCanonClasses", SBURBClassManager.canon.length, 0);
}

void setup() {
  globalSC = new SBURBClass("Null", 256, false);
}