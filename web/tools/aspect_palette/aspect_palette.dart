
import "dart:html";

import "../../scripts/SBURBSim.dart";

import "../../scripts/includes/colour.dart";
import "../../scripts/includes/colour_picker.dart";


void main() {
    CanvasElement canvas = querySelector("#canvas");
    CanvasRenderingContext2D ctx = canvas.context2D;

    Colour col1 = new Colour.fromHex(0xFF0000);
    Colour col2 = new Colour.fromHex(0x00FF00);

    int w = canvas.width;
    int h = canvas.height;

    ImageData data = ctx.getImageData(0,0,w,h);

    for (int x = 0; x<w; x++) {
        for (int y = 0; y<h; y++) {
            int index = ((w*y) +x) * 4;

            double frac = x / (w*2) + y / (h*2);

            Colour mix = col1.mix(col2, frac);//, true);

            data.data[index] = mix.red;
            data.data[index+1] = mix.green;
            data.data[index+2] = mix.blue;
            data.data[index+3] = 255;
        }
    }

    ctx.putImageData(data, 0, 0);
}