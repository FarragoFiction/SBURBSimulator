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

    Buff(Stat this.stat, BuffLife this.life);

    double ageMultiplier(int age) => 1.0;

    double baseAdditive(double val) => val;
    double additional(double val) => val;
    double more(double val) => val;
    double flatAdditive(double val) => val;
}