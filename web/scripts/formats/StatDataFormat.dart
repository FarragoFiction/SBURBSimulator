import "dart:async";
import 'dart:typed_data';

import '../GameEntities/Stats/sampler/statsampler.dart';
import "../SBURBSim.dart";
import '../includes/bytebuilder.dart';

abstract class StatDataFormat extends BinaryFileFormat<Iterable<DataPoint>> {
    static final List<StatDataFormat> formatVersions = <StatDataFormat>[
        new StatDataFormatV0(),
    ];

    final int version;

    StatDataFormat(int this.version);

    @override
    String mimeType() => "application/octet-stream";

    @override
    String header() => "SimStat$version";

    @override
    Future<ByteBuffer> write(Iterable<DataPoint> data) async {
        ByteBuilder builder = new ByteBuilder();

        builder.appendAllBytes(header().codeUnits);
        builder.appendInt32(data.length);

        for(DataPoint point in data) {
            writeDataPoint(builder, point);
        }

        ByteBuffer buffer = builder.toBuffer();
        //ByteBuilder.prettyPrintByteBuffer(buffer);
        return buffer;
    }

    void writeDataPoint(ByteBuilder builder, DataPoint data);

    @override
    Future<List<DataPoint>> read(ByteBuffer buffer) async {
        ByteReader reader = new ByteReader(buffer);

        //print("${header()}: ${header().codeUnits.map((int i) => "0x${i.toRadixString(16).padLeft(2,"0")}")}");
        //ByteBuilder.prettyPrintByteBuffer(buffer);

        for (int i=0; i<header().codeUnits.length; i++) {
            reader.readByte();
        }

        int count = reader.readInt32();

        List<DataPoint> data = <DataPoint>[];

        for (int i=0; i<count; i++) {
            data.add(readDataPoint(reader));
        }

        return data;
    }

    DataPoint readDataPoint(ByteReader reader);
}

class StatDataFormatV0 extends StatDataFormat {
    static const double STATMULT = 100.0;

    StatDataFormatV0():super(0);

    @override
    void writeDataPoint(ByteBuilder builder, DataPoint data) {
        builder
            ..appendByte(data.sburbClass.id)
            ..appendByte(data.aspect.id)
            ..appendBits(data.interest1.id, 4)
            ..appendBits(data.interest2.id, 4)
            ..appendInt32(data.time);

        builder.appendExpGolomb(data.statsold.length);

        for (String stat in data.statsold.keys) {
            builder.appendExpGolomb(stat.codeUnits.length);
            builder.appendAllBytes(stat.codeUnits);
            int value = (data.statsold[stat] * STATMULT).toInt();
            builder.appendBit(value<0);
            builder.appendExpGolomb(value.abs());
        }
    }

    @override
    DataPoint readDataPoint(ByteReader reader) {
        SBURBClass sburbClass = SBURBClassManager.findClassWithID(reader.readByte());
        Aspect aspect = Aspects.get(reader.readByte());
        InterestCategory interest1 = InterestManager.get(reader.readBits(4));
        InterestCategory interest2 = InterestManager.get(reader.readBits(4));
        int time = reader.readInt32();

        int statcount = reader.readExpGolomb();
        Map<String, double> stats = <String, double>{};

        for(int i=0; i<statcount; i++) {
            int namelength = reader.readExpGolomb();
            StringBuffer sb = new StringBuffer();
            for (int j=0; j<namelength; j++) {
                sb.writeCharCode(reader.readByte());
            }
            String stat = sb.toString();
            bool neg = reader.readBit();
            double value = reader.readExpGolomb() / STATMULT;
            if (neg) { value *= -1; }
            stats[stat] = value;
        }

        return new DataPoint(sburbClass, aspect, interest1, interest2, time, statsold: stats);
    }
}