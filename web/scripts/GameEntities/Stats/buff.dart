import "../../SBURBSim.dart";

enum BuffLife {
    COMBAT,
    COMBAT_TIMED,
    TIMED,
    FOREVER
}

abstract class Buff {
    final BuffLife life;
    final Stat stat;
    int age = 0;
    int maxAge = 0;

    Buff._(Stat this.stat, BuffLife this.life);

    double ageMultiplier(int age) => 1.0;

    double baseAdditive(double val) => val;
    double additional(double val) => val;
    double more(double val) => val;
    double flatAdditive(double val) => val;

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