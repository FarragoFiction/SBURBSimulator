import 'dart:typed_data';
import "../../SBURBSim.dart";
import '../../includes/bytebuilder.dart';

class StatSampler {
    static Logger logger = Logger.get("Stat Sampler");

    int turn = 0;

    List<DataPoint> data = <DataPoint>[];

    void sample(Session session) {
        turn++;

        for (Player player in session.players) {
            data.add(new DataPoint(player, turn/session.players.length));
        }
    }

    void resetTurns() {
        this.turn = 0;
    }
}

class DataPoint {
    double time;

    SBURBClass sburbClass;
    Aspect aspect;
    InterestCategory interest1;
    InterestCategory interest2;

    Map<Stat, double> stats = <Stat, double>{};
    Map<String, double> statsold = <String, double>{};

    DataPoint(Player player, double this.time) {
        this.sburbClass = player.class_name;
        this.aspect = player.aspect;
        this.interest1 = player.interest1.category;
        this.interest2 = player.interest2.category;

        for (String stat in player.stats.keys) {
            statsold[stat] = player.stats[stat].toDouble();
        }

        StatSampler.logger.debug("Data point for $player at time $time");
    }
}

abstract class StatDataFormat {
    ByteBuffer write(Iterable<DataPoint> data) {
        ByteBuilder builder = new ByteBuilder();



        return builder.toBuffer();
    }

    List<DataPoint> read(ByteBuffer buffer) {
        ByteReader reader = new ByteReader(buffer);
        List<DataPoint> data = <DataPoint>[];



        return data;
    }
}