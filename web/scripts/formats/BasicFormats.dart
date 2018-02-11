import "dart:async";
import "dart:typed_data";

import "FileFormat.dart";

class TextFileFormat extends StringFileFormat<String> {

    @override
    String mimeType() => "text/plain";

    @override
    Future<String> read(String input) async => input;

    @override
    Future<String> write(String data) async => data;

    @override
    String header() => "";
}

class RawBinaryFileFormat extends BinaryFileFormat<ByteBuffer> {

    @override
    String mimeType() => "application/octet-stream";

    @override
    Future<ByteBuffer> read(ByteBuffer input) async => input;

    @override
    Future<ByteBuffer> write(ByteBuffer data) async => data;

    @override
    String header() => "";
}