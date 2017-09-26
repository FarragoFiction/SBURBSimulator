import "dart:async";
import "dart:html";
import "dart:typed_data";

import "FileFormat.dart";

abstract class ImageFileFormat extends BinaryFileFormat<ImageElement> {

    @override
    Future<String> objectToDataURI(ImageElement object) async => (new CanvasElement(width:object.width, height:object.height)..context2D.drawImage(object,0,0)).toDataUrl(this.mimeType());

    @override
    Future<ImageElement> requestObjectFromUrl(String url) async {
        ImageElement img = new ImageElement(src: url);
        await img.onLoad.first;
        return img;
    }
}

class PngFileFormat extends ImageFileFormat {
    @override
    String mimeType() => "image/png";

    @override
    Future<ImageElement> read(ByteBuffer input) async {
        String url = await this.dataToDataURI(input);
        ImageElement img = new ImageElement(src: url);
        await img.onLoad.first;
        return img;
    }

    @override
    Future<ByteBuffer> write(ImageElement data) => throw "NYI";

    @override
    String header() => new String.fromCharCodes(<int>[137, 80, 78, 71, 13, 10, 26, 10]);
}