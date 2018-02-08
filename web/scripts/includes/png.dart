import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";

import "bytebuilder.dart";

class PayloadPng {
    /// 2^31 - 1, specified as max block length in png spec
    static const int MAX_BLOCK_LENGTH = 0x7FFFFFFF;

    final CanvasElement imageSource;

    Map<String, ByteBuffer> payload = <String, ByteBuffer>{};

    PayloadPng(CanvasElement this.imageSource) {

    }

    ByteBuffer build() {
        ByteBuilder builder = new ByteBuilder();
        this.header(builder);

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
        int blocks = (data.lengthInBytes / MAX_BLOCK_LENGTH).ceil();

        int start, length;
        for (int i=0; i<blocks; i++) {
            start = MAX_BLOCK_LENGTH * i;
            length = Math.min(data.lengthInBytes - start, MAX_BLOCK_LENGTH);
            writeDataBlock(builder, blockname, data.asUint8List(start,length));
        }
    }

    void writeDataBlock(ByteBuilder builder, String blockname, Uint8List data) {
        builder
            ..appendInt32(data.lengthInBytes)
            ..appendAllBytes(blockname.substring(0,3).codeUnits)
            ..appendAllBytes(data)
            ..appendInt32(this.calculateCRC(blockname, data))
        ;
    }

    int calculateCRC(String blockname, Uint8List data) {
        return 0;
    }
}