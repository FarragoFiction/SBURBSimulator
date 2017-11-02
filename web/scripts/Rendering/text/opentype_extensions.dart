import "dart:async";
import "dart:html";

import "../../loader/loader.dart";
import "opentype.dart" as OT;

Future<ScriptElement> load() => Loader.loadJavaScript("scripts/Rendering/text/opentype.min.js");

Future<Null> drawText(String fontPath, CanvasRenderingContext2D ctx, String text, num x, num y, num fontSize, {String fill = null, String stroke = null}) async {
    OT.Font font = await Loader.getResource(fontPath);
    OT.Path path = font.getPath(text, x, y, fontSize);
    if (fill != null) {
        path.fill = fill;
    }
    if (stroke != null) {
        path.stroke = stroke;
    }
    path.draw(ctx);
}