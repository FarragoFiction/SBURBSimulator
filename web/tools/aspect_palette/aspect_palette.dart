
import "dart:html";

import "../../scripts/SBURBSim.dart";

import "../../scripts/includes/colour.dart";
import "../../scripts/includes/colour_picker.dart";


void main() {
    Element stuff = querySelector("#stuff");

    for (int i=0; i<100; i++) {
        stuff.append(makeGradientSwatch());
    }
}

CanvasElement makeGradientSwatch() {
    CanvasElement canvas = new CanvasElement(width: 200, height:200);
    CanvasRenderingContext2D ctx = canvas.context2D;

    Random rand = new Random();

    double brightness = rand.nextDouble() * 0.4 + 0.5;
    double sat = rand.nextDouble() * 0.2 + 0.5;

    Colour col1 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);
    Colour col2 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);

    //Colour col1 = new Colour.fromHex(0xFF0000);
    //Colour col2 = new Colour.fromHex(0x00FF00);

    int w = canvas.width;
    int h = canvas.height;

    ImageData data = ctx.getImageData(0,0,w,h);

    for (int x = 0; x<w; x++) {
        for (int y = 0; y<h; y++) {
            int index = ((w*y) +x) * 4;

            double frac = x / (w*2) + y / (h*2);

            Colour mix = col1.mix(col2, frac, true);

            data.data[index] = mix.red;
            data.data[index+1] = mix.green;
            data.data[index+2] = mix.blue;
            data.data[index+3] = 255;
        }
    }

    ctx.putImageData(data, 0, 0);

    return canvas;
}