import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";

import '../SBURBSim.dart';
import "bytebuilder.dart";

class PayloadPng {
    /// 2^31 - 1, specified as max block length in png spec
    static const int _MAX_BLOCK_LENGTH = 0x7FFFFFFF;
    static Uint32List _CRC_TABLE = null;

    final CanvasElement imageSource;

    Map<String, ByteBuffer> payload = <String, ByteBuffer>{};

    PayloadPng(CanvasElement this.imageSource) {

    }

    ByteBuffer build() {
        ByteBuilder builder = new ByteBuilder();
        this.header(builder);

        this.testBlockWriting(builder);

        return builder.toBuffer();
    }

    void header(ByteBuilder builder) {
        builder
            ..appendByte(0x89) // high bit set to help detect png vs text
            ..appendByte(0x50) // P
            ..appendByte(0x4E) // N
            ..appendByte(0x47) // G
            ..appendByte(0x0D) // dos line ending
            ..appendByte(0x0A)
            ..appendByte(0x1A) // dos EOF
            ..appendByte(0x0A) // unix line ending
        ;
    }

    /// Writes [data] to an appropriate number of blocks with the identifier [blockname].
    /// Splits the data across several blocks if required.
    void writeDataToBlocks(ByteBuilder builder, String blockname, ByteBuffer data) {
        int blocks = (data.lengthInBytes / _MAX_BLOCK_LENGTH).ceil();

        int start, length;
        for (int i=0; i<blocks; i++) {
            start = _MAX_BLOCK_LENGTH * i;
            length = Math.min(data.lengthInBytes - start, _MAX_BLOCK_LENGTH);
            writeDataBlock(builder, blockname, data.asUint8List(start,length));
        }
    }

    void writeDataBlock(ByteBuilder builder, String blockname, Uint8List data) {
        builder
            ..appendInt32(data.lengthInBytes)
            ..appendAllBytes(blockname.substring(0,4).codeUnits)
            ..appendAllBytes(data)
            ..appendInt32(this.calculateCRC(blockname, data))
        ;
    }

    int calculateCRC(String blockname, Uint8List data) {
        if (_CRC_TABLE == null) {
            _makeCRCTable();
        }

        return _updateCRC(0xFFFFFFFF, data) ^ 0xFFFFFFFF;
    }

    int _updateCRC(int crc, Uint8List data) {
        int length = data.lengthInBytes;

        for (int i=0; i<length; i++) {
            crc = (_CRC_TABLE[(crc ^ data[i]) & 0xFF] ^ (crc >> 8)) & 0xFFFFFFFF;
        }

        return crc;
    }

    void _makeCRCTable() {
        _CRC_TABLE = new Uint32List(256);

        int c,n,k;

        for (n=0; n<256; n++) {
            c = n;
            for (k=0; k<8; k++) {
                if (c & 1 != 0) {
                    c = 0xEDB88320 ^ ((c >> 1) & 0xFFFFFFFF);
                } else {
                    c = (c >> 1) & 0xFFFFFFFF;
                }
            }
            _CRC_TABLE[n] = c & 0xFFFFFFFF;
        }
    }

    //################################## test stuff

    void testBlockWriting(ByteBuilder builder) {
        String testlabel = "teST";
        int testlength = 4096;//32;

        ByteBuffer labelbytes = new Uint8List.fromList(testlabel.codeUnits).buffer;

        Uint8List testlist = new Uint8List(testlength);

        Random rand = new Random();

        for (int i=0; i<testlength; i++) {
            testlist[i] = rand.nextInt(256);
        }

        ByteBuffer data = testlist.buffer;

        print("Label: $testlabel");
        ByteBuilder.prettyPrintByteBuffer(labelbytes);
        print("");
        print("Data:");
        ByteBuilder.prettyPrintByteBuffer(data);

        writeDataToBlocks(builder, testlabel, data);

        //print("CRC table:");
        //ByteBuilder.prettyPrintByteBuffer(_CRC_TABLE.buffer);
    }
}