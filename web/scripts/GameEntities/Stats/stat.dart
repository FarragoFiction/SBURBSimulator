import "../../SBURBSim.dart";

abstract class Stats {

    static Stat EXPERIENCE;


    static void init() {
        if (_initialised) {return;}
        _initialised = true;

        EXPERIENCE = new Stat("Experience", pickable:false);
    }
    static bool _initialised;

    static List<Stat> _list = <Stat>[];

    static Iterable<Stat> get all => _list;
    static Iterable<Stat> get pickable => _list.where((Stat stat) => stat.pickable);
    static Iterable<Stat> get summarise => _list.where((Stat stat) => stat.summarise);
}

class Stat {
    final String name;
    final bool pickable;
    final bool summarise;

    Stat(String this.name, {bool this.pickable = true, bool this.summarise = true}) {
        Stats._list.add(this);
    }
    
    double derived(StatHolder stats, double base) { return base; }
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