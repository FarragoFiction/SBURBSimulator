import "dart:html";
import "dart:math" as Math;
import "dart:typed_data";

import '../SBURBSim.dart';
import "improvedbytebuilder.dart";

class PayloadPng {
    /// 2^31 - 1, specified as max block length in png spec
    static const int _MAX_BLOCK_LENGTH = 0x7FFFFFFF;
    static Uint32List _CRC_TABLE = null;

    final CanvasElement imageSource;

    Map<String, ByteBuffer> payload = <String, ByteBuffer>{};

    bool saveTransparency;

    PayloadPng(CanvasElement this.imageSource, [bool this.saveTransparency = true]) {

    }

    ByteBuffer build() {
        ImprovedByteBuilder builder = new ImprovedByteBuilder();

        this.header(builder);

        // image
        this.writeIHDR(builder);
        this.writeIDAT(builder);
        this.writeIEND(builder);

        return builder.toBuffer();
    }

    void header(ImprovedByteBuilder builder) {
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

    //################################## blocks

    /// Image Header Block
    void writeIHDR(ImprovedByteBuilder builder) {
        ImprovedByteBuilder ihdr = new ImprovedByteBuilder()
            ..appendInt32(imageSource.width)
            ..appendInt32(imageSource.height)
            ..appendByte(8) // 8 bits per channel
            ..appendByte(this.saveTransparency ? 6 : 2) // 2 = truecolour, 6 = truecolour with alpha
            ..appendByte(0) // compression mode 0, as per spec
            ..appendByte(0) // filter mode 0, as per spec
            ..appendByte(0) // no interlace
        ;

        writeDataToBlocks(builder, "IHDR", ihdr.toBuffer());
    }

    /// Image Data Block(s)
    void writeIDAT(ImprovedByteBuilder builder) {
        writeDataToBlocks(builder, "IDAT", processImage());
    }

    /// Image End Block
    void writeIEND(ImprovedByteBuilder builder) {
        writeDataBlock(builder, "IEND");
    }

    //################################## block writing methods

    /// Writes [data] to an appropriate number of blocks with the identifier [blockname].
    /// Splits the data across several blocks if required.
    void writeDataToBlocks(ImprovedByteBuilder builder, String blockname, ByteBuffer data) {
        int blocks = (data.lengthInBytes / _MAX_BLOCK_LENGTH).ceil();

        int start, length;
        for (int i=0; i<blocks; i++) {
            start = _MAX_BLOCK_LENGTH * i;
            length = Math.min(data.lengthInBytes - start, _MAX_BLOCK_LENGTH);
            writeDataBlock(builder, blockname, data.asUint8List(start,length));
        }
    }

    void writeDataBlock(ImprovedByteBuilder builder, String blockname, [Uint8List data = null]) {
        if (data == null) {
            data = new Uint8List(0);
        }

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

        Uint8List check = new Uint8List(data.length+4);
        for (int i=0; i<4; i++) {
            check[i] = blockname.codeUnits[i];
        }
        for (int i=0; i<data.length; i++) {
            check[i+4] = data[i];
        }

        return _updateCRC(0xFFFFFFFF, check) ^ 0xFFFFFFFF;
    }

    int _updateCRC(int crc, Uint8List data) {
        int length = data.lengthInBytes;

        for (int i=0; i<length; i++) {
            crc = _CRC_TABLE[(crc ^ data[i]) & 0xFF] ^ ((crc >> 8) & 0xFFFFFFFF);
        }

        return crc;
    }

    void _makeCRCTable() {
        _CRC_TABLE = new Uint32List(256);

        int c,n,k;

        for (n=0; n<256; n++) {
            c = n;
            for (k=0; k<8; k++) {
                if ((c & 1) == 1) {
                    c = 0xEDB88320 ^ ((c >> 1) & 0x7FFFFFFF);
                } else {
                    c = (c >> 1) & 0x7FFFFFFF;
                }
            }
            _CRC_TABLE[n] = c;
        }
    }

    //################################## image

    ByteBuffer processImage() {
        
    }

    //################################## test stuff

    void testBlockWriting(ImprovedByteBuilder builder) {
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
        ImprovedByteBuilder.prettyPrintByteBuffer(labelbytes);
        print("");
        print("Data:");
        ImprovedByteBuilder.prettyPrintByteBuffer(data);

        writeDataToBlocks(builder, testlabel, data);

        //print("CRC table:");
        //ImprovedByteBuilder.prettyPrintByteBuffer(_CRC_TABLE.buffer);
    }
}