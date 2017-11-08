@JS("opentype")
library opentype;

import "dart:html";
import "dart:js";
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

@anonymous
@JS()
class PathCommand {
    external factory PathCommand({
        String type,
        num x,
        num y,
        num x1,
        num y1,
        num x2,
        num y2
    });

    external String get type;
    external num get x;
    external num get y;
    external num get x1;
    external num get y1;
    external num get x2;
    external num get y2;
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

    external JsArray<PathCommand> get commands;
}