import "dart:async";

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