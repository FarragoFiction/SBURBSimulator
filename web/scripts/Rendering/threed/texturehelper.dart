import 'dart:async';
import 'dart:html';

abstract class TextureHelper {
    static Map<ImageElement, ImageElement> _resized = <ImageElement, ImageElement>{};

    static Future<ImageElement> expandToNextPower(ImageElement img, [bool force = false]) async {
        if (!force && _resized.containsKey(img)) {
            return _resized[img];
        }
        int w = nextPowerOfTwo32(img.width);
        int h = nextPowerOfTwo32(img.height);

        CanvasElement canvas = new CanvasElement(width: w, height: h);
        canvas.context2D.drawImage(img, 0, 0);

        ImageElement out = new ImageElement();
        _resized[img] = out;
        out.src = canvas.toDataUrl("image/png");
        await out.onLoad.first;

        return out;
    }

    static int nextPowerOfTwo32(int n) {
        n--;
        n |= n >> 1;
        n |= n >> 2;
        n |= n >> 4;
        n |= n >> 8;
        n |= n >> 16;
        n++;
        return n;
    }
}