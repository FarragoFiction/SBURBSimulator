import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import '../includes/predicates.dart';

abstract class FileFormat<T,U> {
    List<String> extensions = <String>[];

    String mimeType();
    String header();

    bool identify(U data);

    Future<U> write(T data);
    Future<T> read(U input);

    Future<U> fromBytes(ByteBuffer buffer);

    Future<String> dataToDataURI(U data);
    Future<String> objectToDataURI(T object) async => dataToDataURI(await write(object));

    Future<U> readFromFile(File file);
    Future<T> readObjectFromFile(File file) async => read(await readFromFile(file));

    Future<U> requestFromUrl(String url);
    Future<T> requestObjectFromUrl(String url) async => read(await requestFromUrl(url));

    static Future<Element> loadButton<T,U>(FileFormat<T,U> format, Lambda<T> callback, {bool multiple = false, String caption = "Load file"}) {
        return loadButtonVersioned(<FileFormat<T,U>>[format], callback, multiple:multiple, caption:caption);
    }

    static Future<Element> loadButtonVersioned<T,U>(List<FileFormat<T,U>> formats, Lambda<T> callback, {bool multiple = false, String caption = "Load file"}) async {
        Element container = new DivElement();

        FileUploadInputElement upload = new FileUploadInputElement()..style.display="none"..multiple=multiple;

        upload..onChange.listen((Event e) async {
            if (upload.files.isEmpty) { return; }

            for (File file in upload.files) {
                for (FileFormat<T, U> format in formats) {
                    U output = await format.readFromFile(file);
                    if (output != null) {
                        callback(await format.read(output));
                        break;
                    }
                }
            }
            upload.value = null;
        });

        container.append(upload);

        container.append(new ButtonElement()..text=caption..onClick.listen((Event e) => upload.click()));

        return container;
    }
}

abstract class BinaryFileFormat<T> extends FileFormat<T,ByteBuffer> {
    @override
    bool identify(ByteBuffer buffer) {
        String head = this.header();
        List<int> headbytes = head.codeUnits;
        List<int> bytes = buffer.asUint8List();
        for (int i=0; i<headbytes.length; i++) {
            if (bytes[i] != headbytes[i]) {
                return false;
            }
        }
        return true;
    }

    @override
    Future<ByteBuffer> fromBytes(ByteBuffer buffer) async => buffer;

    @override
    Future<String> dataToDataURI(ByteBuffer buffer) async {
        return Url.createObjectUrlFromBlob(new Blob(<dynamic>[buffer.asUint8List()], mimeType()));
    }

    @override
    Future<ByteBuffer> readFromFile(File file) async {
        FileReader reader = new FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;
        if (reader.result is Uint8List) {
            return (reader.result as Uint8List).buffer;
        }
        return null;
    }

    @override
    Future<ByteBuffer> requestFromUrl(String url) async {
        Completer<ByteBuffer> callback = new Completer<ByteBuffer>();
        HttpRequest.request(url, responseType: "arraybuffer", mimeType: this.mimeType()).then((HttpRequest request) {
            callback.complete((request.response as ByteBuffer));
        });
        return callback.future;
    }
}

abstract class StringFileFormat<T> extends FileFormat<T,String> {
    @override
    bool identify(String data) => data.startsWith(header());

    @override
    Future<String> fromBytes(ByteBuffer buffer) async {
        StringBuffer sb = new StringBuffer();
        Uint8List ints = buffer.asUint8List();
        for (int i in ints) {
            sb.writeCharCode(i);
        }
        return sb.toString();
    }

    @override
    Future<String> dataToDataURI(String content) async {
        return new Uri.dataFromString(content, encoding:UTF8, base64:true).toString();
    }

    @override
    Future<String> readFromFile(File file) async {
        FileReader reader = new FileReader();
        reader.readAsText(file);
        await reader.onLoad.first;
        if (reader.result is String) {
            return reader.result;
        }
        return null;
    }

    @override
    Future<String> requestFromUrl(String url) async {
        return HttpRequest.getString(url);
    }
}