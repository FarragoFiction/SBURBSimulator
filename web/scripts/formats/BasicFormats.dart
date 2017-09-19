import "FileFormat.dart";

class TextFileFormat extends StringFileFormat<String> {

    @override
    String mimeType() => "text/plain";

    @override
    String read(String input) => input;

    @override
    String write(String data) => data;

    @override
    String header() => "";
}