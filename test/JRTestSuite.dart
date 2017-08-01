//part of SBURBSim;
//this is how i want asserts to work
jRAssert(name, tested, expected) {
  assert(tested == expected
      ? true
      : throw "${name} should be ${expected}, but is: ${tested}");
}
//testing testing testing
