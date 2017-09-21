import "dart:async";
import "dart:typed_data";

import "package:archive/archive.dart";

import "../SBURBSim.dart";

class ZipFormat extends BinaryFileFormat<Archive> {
    static ZipDecoder _decoder = new ZipDecoder();
    static ZipEncoder _encoder = new ZipEncoder();

    @override
    String mimeType() => "application/x-tar";

    @override
    Future<Archive> read(ByteBuffer input) async => _decoder.decodeBytes(input.asUint8List());

    @override
    Future<ByteBuffer> write(Archive data) async => (_encoder.encode(data) as Uint8List).buffer;

    @override
    String header() => "";
}