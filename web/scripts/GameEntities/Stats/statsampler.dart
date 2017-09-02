import 'dart:typed_data';
import "../../SBURBSim.dart";
import '../../includes/bytebuilder.dart';

class StatSampler {
    static Logger logger = Logger.get("Stat Sampler", false);

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

    void savetest() {

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

    DataPoint._(SBURBClass this.sburbClass, Aspect this.aspect, InterestCategory this.interest1, InterestCategory this.interest2, Map<String, double> this.statsold, double this.time);
}

abstract class StatDataFormat {
    static const String HEADER = "SimData0";
    static const int DOUBLESHIFT = 1 << 16;
    static const double STATMULT = 100.0;

    static ByteBuffer write(Iterable<DataPoint> data) {
        ByteBuilder builder = new ByteBuilder();

        builder.appendAllBytes(HEADER.codeUnits);
        builder.appendInt32(data.length);

        for(DataPoint point in data) {
            writeDataPoint(builder, point);
        }

        return builder.toBuffer();
    }

    static void writeDataPoint(ByteBuilder builder, DataPoint data) {
        builder
            ..appendByte(data.sburbClass.id)
            ..appendByte(data.aspect.id)
            ..appendBits(data.interest1.id, 4)
            ..appendBits(data.interest2.id, 4)
            ..appendInt32((data.time * DOUBLESHIFT).floor());

        builder.appendExpGolomb(data.stats.length);

        for (String stat in data.statsold.keys) {
            builder.appendExpGolomb(stat.length);
            builder.appendAllBytes(stat.codeUnits);
            builder.appendExpGolomb((data.statsold[stat] * STATMULT).toInt());
        }
    }

    static List<DataPoint> read(ByteBuffer buffer) {
        ByteReader reader = new ByteReader(buffer);

        StringBuffer head = new StringBuffer();
        for (int i=0; i<HEADER.length; i++) {
            head.writeCharCode(reader.readByte());
        }
        if (head.toString() != HEADER) {
            throw "Invalid stat data file - header mismatch! ($head)";
        }

        int count = reader.readInt32();

        List<DataPoint> data = <DataPoint>[];

        for (int i=0; i<count; i++) {
            data.add(readDataPoint(reader));
        }

        return data;
    }

    static DataPoint readDataPoint(ByteReader reader) {
        SBURBClass sburbClass = SBURBClassManager.findClassWithID(reader.readByte());
        Aspect aspect = Aspects.get(reader.readByte());
        InterestCategory interest1 = InterestManager.get(reader.readBits(4));
        InterestCategory interest2 = InterestManager.get(reader.readBits(4));
        double time = reader.readInt32() / DOUBLESHIFT;

        int statcount = reader.readExpGolomb();
        Map<String, double> stats = <String, double>{};

        for(int i=0; i<statcount; i++) {
            int namelength = reader.readExpGolomb();
            StringBuffer sb = new StringBuffer();
            for (int j=0; j<namelength; j++) {
                sb.writeCharCode(reader.readByte());
            }
            String stat = sb.toString();
            double value = reader.readExpGolomb() / STATMULT;
            stats[stat] = value;
        }

        return new DataPoint._(sburbClass, aspect, interest1, interest2, stats, time);
    }
}