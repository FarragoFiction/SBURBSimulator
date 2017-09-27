import 'dart:math' as Math;
import "../../SBURBSim.dart";

abstract class Stats {

    //<String>[Stats.POWER, Stats.HEALTH, Stats.RELATIONSHIPS, Stats.MOBILITY, Stats.SANITY, Stats.FREE_WILL, Stats.MAX_LUCK, Stats.MIN_LUCK, Stats.ALCHEMY];

    static Stat EXPERIENCE;
    static Stat GRIST;

    static Stat POWER;
    static Stat HEALTH;
    static Stat CURRENT_HEALTH;
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

        EXPERIENCE = new Stat("Experience", "learned", "naïve", pickable: false)..minBase=0.0; //wastes can get 0
        GRIST = new Stat("Grist Level", "rich", "poor", pickable: false, summarise:false);

        POWER = new XPScaledStat("Power", "strong", "weak", 0.03, coefficient: 10.0, associatedGrowth: 0.5)..minBase=2.5..minDerived=1.0;
        HEALTH = new XPScaledStat("Health", "sturdy", "fragile", 0.04, coefficient: 10.0)..minBase=2.5;
        CURRENT_HEALTH = new Stat("Current Health", "healthy", "infirm", pickable: false, transient:true);
        MOBILITY = new Stat("Mobility", "fast", "slow");

        RELATIONSHIPS = new RelationshipStat("Relationships", "friendly", "aggressive", pickable: false); // should be a special one to deal with players
        SANITY = new Stat("Sanity", "calm", "crazy");
        FREE_WILL = new Stat("Free Will", "willful", "gullible");

        MAX_LUCK = new Stat("Maximum Luck", "lucky", "unlucky");
        MIN_LUCK = new Stat("Minimum Luck", "lucky", "unlucky");

        ALCHEMY = new Stat("Alchemy", "creative", "boring");
        SBURB_LORE = new Stat("SBURB Lore", "woke", "clueless", pickable: false);
    }
    static bool _initialised = false;

    static List<Stat> _list = <Stat>[];

    static Iterable<Stat> get all => _list;
    static Iterable<Stat> get pickable => _list.where((Stat stat) => stat.pickable);
    static Iterable<Stat> get summarise => _list.where((Stat stat) => stat.summarise);
}

class Stat {
    final String name;
    final String emphaticPositive;
    final String emphaticNegative;

    final bool pickable;
    final bool summarise;
    final bool transient;

    double coefficient; //hope players can change
    final double associatedGrowth;

    double minBase = double.NEGATIVE_INFINITY;
    double maxBase = double.INFINITY;
    double minDerived = double.NEGATIVE_INFINITY;
    double maxDerived = double.INFINITY;

    Stat(String this.name, String this.emphaticPositive, String this.emphaticNegative, {double this.coefficient = 1.0, double this.associatedGrowth = 1.0, bool this.pickable = true, bool this.summarise = true, bool this.transient = false}) {
        Stats._list.add(this);
    }
    
    double derived(StatHolder stats, double base) { return base * coefficient; }

    @override
    String toString() => this.name;

    T max<T extends StatObject>(Iterable<T> from) {
        double n = double.NEGATIVE_INFINITY;
        T most = null;
        double s;
        for (T h in from) {
            s = h.getStatHolder()[this];
            if (s > n) {
                most = h;
                n = s;
            }
        }
        return most;
    }

    T min<T extends StatObject>(Iterable<T> from) {
        double n = double.INFINITY;
        T least = null;
        double s;
        for (T h in from) {
            s = h.getStatHolder()[this];
            if (s < n) {
                least = h;
                n = s;
            }
        }
        return least;
    }

    double average(Iterable<StatObject> from, [bool baseStats = false]) {
        return this.total(from, baseStats) / from.length;
    }

    double total(Iterable<StatObject> from, [bool baseStats = false]) {
        if (baseStats) {
            return from.map((StatObject o) => o.getStatHolder().getBase(this)).reduce((double a, double b) => a+b);
        }
        return from.map((StatObject o) => o.getStatHolder()[this]).reduce((double a, double b) => a+b);
    }

    int sorter(StatObject a, StatObject b) => a.getStatHolder()[this].compareTo(b.getStatHolder()[this]);

    List<T> sortedList<T extends StatObject>(Iterable<T> iterable, [bool reverse = false]) {
        List<T> unsorted = iterable.toList();
        if (reverse) {
            unsorted = unsorted.reversed.toList();
        }
        return unsorted..sort(this.sorter);
    }

    String emphaticDescriptor(StatObject o) {
        if (o.getStatHolder()[this] > 0) {
            return this.emphaticPositive;
        }
        return this.emphaticNegative;
    }

    double get rangeMinimum => Math.max(this.minBase * this.coefficient, this.minDerived);
    double get rangeMaximum => Math.min(this.maxBase * this.coefficient, this.maxDerived);
}

class XPScaledStat extends Stat {
    final double expCoefficient;

    XPScaledStat(String name, String emphaticPositive, String emphaticNegative, double this.expCoefficient, {double coefficient = 1.0, double associatedGrowth = 1.0, bool pickable = true, bool summarise = true, bool transient = false}):super(name, emphaticPositive, emphaticNegative, coefficient:coefficient, associatedGrowth:associatedGrowth, pickable:pickable, summarise:summarise, transient:transient);

    @override
    double derived(StatHolder stats, double base) {
        double xp = stats[Stats.EXPERIENCE];
        return super.derived(stats, base) * (1.0 + expCoefficient * xp);
    }
}

class RelationshipStat extends Stat {

    RelationshipStat(String name, String emphaticPositive, String emphaticNegative, {double coefficient = 1.0, double associatedGrowth = 1.0, bool pickable = true, bool summarise = true, bool transient = false}):super(name, emphaticPositive, emphaticNegative, coefficient:coefficient, associatedGrowth:associatedGrowth, pickable:pickable, summarise:summarise, transient:transient);

    @override
    double derived(StatHolder stats, double base) {
        if (stats is PlayerStatHolder) {
            if (stats.owner.relationships.isEmpty) {
                return 0.0;
            }
            return stats.owner.relationships.map((Relationship r) => r.value).reduce((num r1, num r2) => r1+r2) * coefficient;
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
 */