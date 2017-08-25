import 'dart:html';
import '../../scripts/includes/gif.dart';

void main() {
    print("poot");

    testgif();
}

void testgif() {
    int w = 200;
    int h = 200;

    Gif gif = new Gif(w,h)..palette.addHex("red", 0xFF0000);

    CanvasElement canvas = new CanvasElement(width:w, height:h);
    CanvasRenderingContext2D ctx = canvas.context2D;
    ctx.fillStyle = "#010000";
    for (int i=0; i<10; i++) {
        ctx.clearRect(0, 0, w,h);

        ctx.fillRect(5 + 5 * i, 50, 100, 100);

        gif.addFrame(canvas, 10);
    }

    ImageElement img = new ImageElement()..src = gif.buildDataUri().toString();

    querySelector("#stuff").append(img);
}