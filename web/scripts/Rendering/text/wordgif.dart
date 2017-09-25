import 'dart:html';
import 'dart:math' as Math;

import '../../includes/colour.dart';
import '../../includes/gif.dart';
import 'bitmapfont.dart';
import 'fonts.dart';

abstract class WordGif {
    static Element dropText(String text, int size, List<Colour> foreground, List<Colour> background, [num ox = 1, num oy = 1, int depth = 3]) {
        Element container = new DivElement();

        BitmapFont.get(Fonts.courier_new_14px).then((BitmapFont font) {
            int frames = Math.min(foreground.length, background.length);

            Colour c1 = new Colour(1,0,0);
            Colour c2 = new Colour(2,0,0);
            CanvasElement first = _dropText(font, text, size, c1, c2, ox.toDouble(), oy.toDouble(), depth);

            Gif gif = new Gif(first.width, first.height);
            gif.palette.add("1", foreground[0]);
            gif.palette.add("2", background[0]);
            gif.addFrame(first);

            if (frames > 1) {
                for (int i = 1; i < frames; i++) {
                    Colour fore = new Colour(2 * i + 1, 0, 0);
                    Colour back = new Colour(2 * i + 2, 0, 0);
                    gif.palette.add((2 * i + 1).toString(), foreground[i]);
                    gif.palette.add((2 * i + 2).toString(), background[i]);

                    gif.addFrame(_dropText(font, text, size, fore, back, ox.toDouble(), oy.toDouble(), depth));
                }
            }

            ImageElement img = new ImageElement(src: gif.buildDataUri().toString());
            img.onLoad.listen((Event e) {
               container.append(img);
            });
        });

        return container;
    }

    static CanvasElement _dropText(BitmapFont font, String text, int size, Colour foreground, Colour background, double ox, double oy, int depth) {
        int border = Math.max(ox * depth, oy * depth).ceil();
        int w = font.def.textLength(text) * size + border * 2;
        int h = font.def.glyphHeight * size + border * 2;

        CanvasElement canvas = new CanvasElement(width: w, height:h);

        font.dropText(canvas.context2D, size, text, border, border, foreground, background, ox, oy, depth);

        return canvas;
    }
}