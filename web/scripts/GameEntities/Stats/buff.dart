import "../../SBURBSim.dart";

enum BuffLife {
    COMBAT,
    COMBAT_TIMED,
    TIMED,
    FOREVER
}

abstract class Buff {
    final BuffLife life;
    final Set<Stat> stats = new Set<Stat>();
    int age = 0;
    int maxAge = 0;

    Buff._single(Stat stat, BuffLife this.life) {
        this.stats.add(stat);
    }

    Buff._mutliple(Iterable<Stat> stas, BuffLife this.life) {
        this.stats.addAll(stats);
    }

    double ageMultiplier(int age) => 1.0;

    double baseAdditive(Stat stat, double val) => val;
    double additional(Stat stat, double val) => val;
    double more(Stat stat, double val) => val;
    double flatAdditive(Stat stat, double val) => val;

    Buff copy();

    void tick() {
        if (this.life == BuffLife.TIMED) {
            this.age++;
        }
    }
    void combatTick() {
        if (this.life == BuffLife.COMBAT_TIMED) {
            this.age++;
        }
    }

    bool shouldRemove() {
         if(this.life == BuffLife.TIMED || this.life == BuffLife.COMBAT_TIMED) {
             if (this.age >= this.maxAge) {
                 return true;
             }
         }
         return false;
    }
}