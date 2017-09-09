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

        EXPERIENCE = new Stat("Experience", "learned", "naïve", pickable: false);
        GRIST = new Stat("Grist Level", "rich", "poor", pickable: false);

        POWER = new XPScaledStat("Power", "strong", "weak", 0.05, coefficient: 10.0);
        HEALTH = new XPScaledStat("Health", "sturdy", "fragile", 0.05, coefficient: 10.0);
        CURRENT_HEALTH = new Stat("Current Health", "healthy", "infirm", pickable: false);
        MOBILITY = new Stat("Mobility", "fast", "slow");

        RELATIONSHIPS = new RelationshipStat("Relationships", "friendly", "aggressive", pickable: false); // should be a special one to deal with players
        SANITY = new Stat("Sanity", "calm", "crazy");
        FREE_WILL = new Stat("Free Will", "willful", "gullible");

        MAX_LUCK = new Stat("Maximum Luck", "lucky", "unlucky");
        MIN_LUCK = new Stat("Minimum Luck", "lucky", "unlucky");

        ALCHEMY = new Stat("Alchemy", "creative", "boring");
        SBURB_LORE = new Stat("SBURB Lore", "woke", "clueless", pickable: false);
    }
    static bool _initialised;

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
    final double coefficient;

    Stat(String this.name, String this.emphaticPositive, String this.emphaticNegative, {double this.coefficient = 1.0, bool this.pickable = true, bool this.summarise = true}) {
        Stats._list.add(this);
    }
    
    double derived(StatHolder stats, double base) { return base * coefficient; }

    @override
    String toString() => this.name;

    StatObject max(Iterable<StatObject> from) {
        double n = double.NEGATIVE_INFINITY;
        StatObject most = null;
        double s;
        for (StatObject h in from) {
            s = h.getStatHolder()[this];
            if (s > n) {
                most = h;
                n = s;
            }
        }
        return most;
    }

    StatObject min(Iterable<StatObject> from) {
        double n = double.INFINITY;
        StatObject least = null;
        double s;
        for (StatObject h in from) {
            s = h.getStatHolder()[this];
            if (s < n) {
                least = h;
                n = s;
            }
        }
        return least;
    }

    double average(Iterable<StatObject> from) {
        this.total(from) / from.length;
    }

    double total(Iterable<StatObject> from) {
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
}

class XPScaledStat extends Stat {
    final double expCoefficient;

    XPScaledStat(String name, String emphaticPositive, String emphaticNegative, double this.expCoefficient, {double coefficient, bool pickable, bool summarise}):super(name, emphaticPositive, emphaticNegative, coefficient:coefficient,  pickable:pickable, summarise:summarise);

    @override
    double derived(StatHolder stats, double base) {
        double xp = stats[Stats.EXPERIENCE];
        return super.derived(stats, base) * (1.0 + expCoefficient * xp);
    }
}

class RelationshipStat extends Stat {

    RelationshipStat(String name, String emphaticPositive, String emphaticNegative, {double coefficient, bool pickable, bool summarise}):super(name, emphaticPositive, emphaticNegative, coefficient:coefficient,  pickable:pickable, summarise:summarise);

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
 */