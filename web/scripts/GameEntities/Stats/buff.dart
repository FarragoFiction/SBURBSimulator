import "../../SBURBSim.dart";

abstract class Buff {
    final bool combat;
    final bool timed;
    final Set<Stat> stats = new Set<Stat>();
    int age = 0;
    int maxAge = 0;

    Buff(Stat stat, bool this.combat, bool this.timed, [int this.maxAge= 0]) {
        this.stats.add(stat);
    }

    Buff.multiple(Iterable<Stat> stats, bool this.combat, bool this.timed, [int this.maxAge= 0]) {
        this.stats.addAll(stats);
    }

    double ageMultiplier(int age) => 1.0;

    double baseAdditive(Stat stat, double val) => val;
    double additional(Stat stat, double val) => val;
    double more(Stat stat, double val) => val;
    double flatAdditive(Stat stat, double val) => val;

    Buff copy();

    void tick() {
        if (this.timed && !this.combat) {
            this.age++;
        }
    }
    void combatTick() {
        if (this.timed && this.combat) {
            this.age++;
        }
    }

    bool shouldRemove() {
         if(this.timed) {
             if (this.age >= this.maxAge) {
                 return true;
             }
         }
         return false;
    }
}

class BuffAdditional extends Buff {
    double multiplier;
    BuffAdditional(Stat stat, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffAdditional.multiple(Iterable<Stat> stats, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double additional(Stat stat, double val) => val * multiplier;
    
    @override
    BuffAdditional copy() {
        return new BuffAdditional.multiple(this.stats, this.multiplier, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge;
    }
}

class BuffMore extends Buff {
    double multiplier;
    BuffMore(Stat stat, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffMore.multiple(Iterable<Stat> stats, double this.multiplier, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double more(Stat stat, double val) => val * multiplier;

    @override
    BuffMore copy() {
        return new BuffMore.multiple(this.stats, this.multiplier, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge;
    }
}

class BuffFlat extends Buff {
    double value;
    BuffFlat(Stat stat, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffFlat.multiple(Iterable<Stat> stats, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double flatAdditive(Stat stat, double val) => val + this.value;

    @override
    BuffFlat copy() {
        return new BuffFlat.multiple(this.stats, this.value, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge;
    }
}

class BuffBase extends Buff {
    double value;
    BuffBase(Stat stat, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super(stat, combat, timed, maxAge);
    BuffBase.multiple(Iterable<Stat> stats, double this.value, {bool combat = false, bool timed = false, int maxAge = 0}):super.multiple(stats, combat, timed, maxAge);

    @override
    double baseAdditive(Stat stat, double val) => val + this.value;

    @override
    BuffBase copy() {
        return new BuffBase.multiple(this.stats, this.value, combat:this.combat, timed:this.timed, maxAge:this.maxAge)
            ..age = this.maxAge;
    }
}
