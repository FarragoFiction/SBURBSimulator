import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import '../includes/predicates.dart';

abstract class FileFormat<T,U> {
    String mimeType();
    String header();

    bool identify(U data);

    U write(T data);
    T read(U input);

    Uri dataToDataURI(U data);
    Uri objectToDataURI(T object) => dataToDataURI(write(object));

    Future<U> readFromFile(File file);

    static Element loadButton<T,U>(FileFormat<T,U> format, Lambda<T> callback, {bool multiple = false, String caption = "Load file"}) {
        return loadButtonVersioned(<FileFormat<T,U>>[format], callback, multiple:multiple, caption:caption);
    }

    static Element loadButtonVersioned<T,U>(List<FileFormat<T,U>> formats, Lambda<T> callback, {bool multiple = false, String caption = "Load file"}) {
        Element container = new DivElement();

        FileUploadInputElement upload = new FileUploadInputElement()..style.display="none"..multiple=multiple;

        upload..onChange.listen((Event e) async {
            if (upload.files.isEmpty) { return; }

            for (File file in upload.files) {
                for (FileFormat<T, U> format in formats) {
                    U output = await format.readFromFile(file);
                    if (output != null) {
                        callback(format.read(output));
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
    Uri dataToDataURI(ByteBuffer buffer) {
        return new Uri.dataFromBytes(buffer.asUint8List(), mimeType: this.mimeType());
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
}

abstract class StringFileFormat<T> extends FileFormat<T,String> {
    @override
    bool identify(String data) => data.startsWith(header());

    @override
    Uri dataToDataURI(String content) {
        return new Uri.dataFromString(content, encoding:UTF8, base64:true);
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
}