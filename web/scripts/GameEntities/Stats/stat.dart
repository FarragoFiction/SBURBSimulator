<<<<<<< HEAD
import "../../SBURBSim.dart";

abstract class Stats {

    //<String>["power", "hp", "RELATIONSHIPS", "mobility", "sanity", "freeWill", "maxLuck", "minLuck", "alchemy"];

    static Stat EXPERIENCE;

    static Stat POWER;
    static Stat HEALTH;
    static Stat MOBILITY;

    static Stat RELATIONSHIPS;
    static Stat SANITY;
    static Stat FREE_WILL;

    static Stat MAX_LUCK;
    static Stat MIN_LUCK;

    static Stat ALCHEMY;
    static Stat SBURB_LORE;

    static void init() {
        if (_initialised) {return;}
        _initialised = true;

        EXPERIENCE = new Stat("Experience", pickable: false);

        POWER = new XPScaledStat("Power", 0.05, coefficient: 10.0);
        HEALTH = new XPScaledStat("Health", 0.05, coefficient: 10.0);
        MOBILITY = new Stat("Mobility");

        RELATIONSHIPS = new RelationshipStat("Relationships", pickable: false); // should be a special one to deal with players
        SANITY = new Stat("Sanity");
        FREE_WILL = new Stat("Free Will");

        MAX_LUCK = new Stat("Maximum Luck");
        MIN_LUCK = new Stat("Minimum Luck");

        ALCHEMY = new Stat("Alchemy");
        SBURB_LORE = new Stat("SBURB Lore", pickable: false);
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
    final double coefficient;

    Stat(String this.name, {double this.coefficient = 1.0, bool this.pickable = true, bool this.summarise = true}) {
        Stats._list.add(this);
    }
    
    double derived(StatHolder stats, double base) { return base * coefficient; }

    @override
    String toString() => this.name;
}

class XPScaledStat extends Stat {
    final double expCoefficient;

    XPScaledStat(String name, double this.expCoefficient, {double coefficient, bool pickable, bool summarise}):super(name, coefficient:coefficient,  pickable:pickable, summarise:summarise);

    @override
    double derived(StatHolder stats, double base) {
        double xp = stats[Stats.EXPERIENCE];
        return super.derived(stats, base) * (1.0 + expCoefficient * xp);
    }
}

class RelationshipStat extends Stat {

    RelationshipStat(String name, {double coefficient, bool pickable, bool summarise}):super(name, coefficient:coefficient,  pickable:pickable, summarise:summarise);

    @override
    double derived(StatHolder stats, double base) {
        if (stats is PlayerStatHolder) {
            return stats.player.relationships.map((Relationship r) => r.value).reduce((num r1, num r2) => r1+r2) * coefficient;
        }
        return super.derived(stats, base);
    }
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
=======
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
>>>>>>> f2436884a65c68bfa2e622f5b4cf52b334aff4d7
 */