import "../../SBURBSim.dart";

class StatHolder {
    final Map<Stat, double> base = <Stat, double>{};

    List<Buff> buffs = <Buff>[];

    double operator [](Stat key) => base.containsKey(key) ? base[key] : 0.0;


}

abstract class StatOwner extends StatHolder {
    StatHolder _stats;
}