import "../web/scripts/GameEntities/ClasspectStuff/Classes/SBURBClass.dart";
import "JRTestSuite.dart";

SBURBClass globalSC;
main() {
  testBasics();
}

void testBasics() {
  jRAssert("numberOfClasses", SBURBClassManager.allClasses.length, 12);
  jRAssert("numberOfCanonClasses", SBURBClassManager.canon.length, 12);
  jRAssert("numberOfFanonClasses", SBURBClassManager.fanon.length, 0);
}

