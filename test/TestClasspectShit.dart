import "../web/scripts/GameEntities/ClasspectStuff/Classes/SBURBClass.dart";
import "JRTestSuite.dart";

SBURBClass globalSC;
main() {
  SBURBClassManager.init();
  testBasics();
}

void testBasics() {
  jRAssert("numberOfClasses", SBURBClassManager.all.length, 18);
  jRAssert("numberOfCanonClasses", SBURBClassManager.canon.length, 12);
  jRAssert("numberOfFanonClasses", SBURBClassManager.fanon.length, 6);
}

