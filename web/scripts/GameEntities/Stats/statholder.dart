import "../../SBURBSim.dart";

class StatHolder {
    Map<Stat, double> _map = <Stat, double>{};

    double operator [](Stat key) => _map.containsKey(key) ? _map[key] : 0.0;
}

abstract class StatOwner extends StatHolder {
    StatHolder stats;
}