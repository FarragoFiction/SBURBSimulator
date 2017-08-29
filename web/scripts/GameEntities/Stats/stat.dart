import "../../SBURBSim.dart";

abstract class Stats {

}

class Stat {
    int id;
    String name;

    double derived(StatHolder stats) { return stats[this]; }
}