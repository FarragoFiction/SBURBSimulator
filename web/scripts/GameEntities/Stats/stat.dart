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

Stat processing order: (base + base buffs) * (totalled additive multipliers) * (each consecutive multiplicative mod) + flat modifiers

players get a special StatHolder which applies their aspect and class modifiers before buff ones at each stage

interests provide one time buff and +mult?
god tier becomes smaller flat buff with multiplier instead of gains
experience stat gives multiplier to stats at stat modifier stage

be sparing with base buffs, they could get very powerful

prototyping as buffs, prototype buff referencing another StatHolder or StatOwner maybe

COMBAT and COMBAT_TIMED buffs are removed at the end of combat
TIMED buffs tick up in age once per round of main scenes
COMBAT_TIMED tick up once per combat round
 */