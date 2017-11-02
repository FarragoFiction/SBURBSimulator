@JS("opentype")
library opentype;

import "dart:html";
import "dart:typed_data";

import "package:js/js.dart";

export "opentype_extensions.dart";

@JS()
external Font parse(ByteBuffer myBuffer);

@JS()
class Font {
    external Path getPath(String text, num x, num y, num fontSize);

    external void draw(CanvasRenderingContext2D ctx, String text, num x, num y, num fontSize);

    external ByteBuffer toArrayBuffer();
}

@JS()
class Path {
    external String get fill;
    external void set fill(String val);

    external String get stroke;
    external void set stroke(String val);

    external num get strokeWidth;
    external void set strokeWidth(num val);

    external void draw(CanvasRenderingContext2D ctx);
}