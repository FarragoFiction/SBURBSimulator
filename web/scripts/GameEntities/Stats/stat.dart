import "../../SBURBSim.dart";

abstract class Stats {

}

class Stat {
  int id;
  String name;

  double derived(StatHolder stats) { return stats[this]; }
}

/*
NOTES

Stat processing order: classpect.modifiers(stat.modifier(baseline + growth + buff flat values)) * buff multipliers
maybe?

interests provide one time buff and +mult?
god tier becomes smaller flat buff with multiplier instead of gains
experience stat gives multiplier to stats at stat modifier stage

be sparing with flat buffs, they could get very powerful

prototyping as buffs, prototype buff referencing another StatHolder or StatOwner maybe
 */