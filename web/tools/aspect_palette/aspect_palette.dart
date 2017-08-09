
import "dart:html";
import "dart:math" as Math;

import "../../scripts/SBURBSim.dart";

import "../../scripts/includes/colour.dart";
import "../../scripts/includes/colour_picker.dart";


void main() {
    Element stuff = querySelector("#stuff");

    /*Random rand = new Random();
    for (int i=0; i<100; i++) {
        Colour test = new Colour.double(rand.nextDouble(), rand.nextDouble(), rand.nextDouble());

        print(test);

        print("${test.lab_lightness}, ${test.lab_a}, ${test.lab_b}");

        Colour test2 = new Colour.lab(test.lab_lightness, test.lab_a, test.lab_b);

        print(test2);
        print("-----");
    }*/

    for (int i=0; i<100; i++) {
        stuff.append(makeGradientSwatch());
    }

    //checkLABRanges();
}

void checkLABRanges() {
    double min_l = double.INFINITY;
    double max_l = double.NEGATIVE_INFINITY;

    double min_a = double.INFINITY;
    double max_a = double.NEGATIVE_INFINITY;

    double min_b = double.INFINITY;
    double max_b = double.NEGATIVE_INFINITY;

    for (int r = 0; r<256; r++) {
        for (int g = 0; g<256; g++) {
            for (int b = 0; b<256; b++) {
                Colour col = new Colour(r,g,b);

                min_l = Math.min(min_l, col.lab_lightness_scaled);
                max_l = Math.max(max_l, col.lab_lightness_scaled);

                min_a = Math.min(min_a, col.lab_a_scaled);
                max_a = Math.max(max_a, col.lab_a_scaled);

                min_b = Math.min(min_b, col.lab_b_scaled);
                max_b = Math.max(max_b, col.lab_b_scaled);
            }
        }
    }

    print("L: $min_l,$max_l, a: $min_a,$max_a, b: $min_b,$max_b");
}

CanvasElement makeGradientSwatch() {
    CanvasElement canvas = new CanvasElement(width: 200, height:200);
    CanvasRenderingContext2D ctx = canvas.context2D;

    Random rand = new Random();

    //double brightness = rand.nextDouble() * 0.4 + 0.5;
    //double sat = rand.nextDouble() * 0.2 + 0.5;

    //Colour col1 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);
    //Colour col2 = new Colour.hsv(rand.nextDouble(), rand.nextDouble() * 0.1 + sat, rand.nextDouble() * 0.3 + brightness);

    //Colour col1 = new Colour.fromHex(0xFF0000);
    //Colour col2 = new Colour.fromHex(0x00FF00);

    double lightness = rand.nextDouble() * 0.4 + 0.3;
    double l1 = (rand.nextDouble() * 0.6 - 0.3 + lightness);
    l1 = 1-((1-l1)*(1-l1));
    double l2 = (rand.nextDouble() * 0.6 - 0.3 + lightness);
    l2 = 1-((1-l2)*(1-l2));

    Colour col1 = new Colour.labScaled(l1, rand.nextDouble(), rand.nextDouble());
    Colour col2 = new Colour.labScaled(l2, rand.nextDouble(), rand.nextDouble());

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