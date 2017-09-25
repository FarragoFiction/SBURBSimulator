import 'dart:async';
import 'dart:html';

import '../../includes/colour.dart';
import '../../includes/logger.dart';

import '../../loader/loader.dart';

class BitmapFontDefinition {
    final String path;
    final int glyphWidth;
    final int glyphHeight;
    final int spacing;
    Map<int, int> widthOverrides = <int,int>{};
    Map<int, int> offsets = <int,int>{};

    BitmapFontDefinition(String this.path, int this.glyphWidth, int this.glyphHeight, int this.spacing);

    void widthOverride(String character, int width) {
        widthOverrides[character.codeUnitAt(0)] = width;
    }

    void offset(String character, int o) {
        offsets[character.codeUnitAt(0)] = o;
    }

    int charWidth(int char, [bool useSpacing=true]) {
        if (useSpacing) {
            if (this.widthOverrides.containsKey(char)) {
                return this.widthOverrides[char];
            }
            return this.spacing;
        }
        return this.glyphWidth;
    }

    int charOffset(int char) {
        if (this.offsets.containsKey(char)) {
            return this.offsets[char];
        }
        return 0;
    }

    int textLength(String text) {
        int length = 0;
        for (int i=0; i<text.length; i++) {
            int code = text.codeUnitAt(i);
            int w = this.charWidth(code, i != text.length -1);
            length += w;
        }
        return length;
    }
}

class BitmapFont {
    BitmapFontData _data;
    BitmapFontDefinition def;

    BitmapFont._internal(BitmapFontDefinition this.def) {}

    static Future<BitmapFont> get(BitmapFontDefinition def) async {
        BitmapFont font = new BitmapFont._internal(def);
        font._data = await BitmapFontData.load(def.path, def.glyphWidth, def.glyphHeight);
        return font;
    }

    void drawGlyph(int char, CanvasRenderingContext2D ctx, ImageData data, int ox, int oy, int size, Colour colour) {
        if (!this._data.characterData.containsKey(char)) {
            return;
        }

        int w = this.def.glyphWidth;
        int h = this.def.glyphHeight;

        int gindex, tx, ty, index;
        for (int y = 0; y<h; y++) {
            for (int x = 0; x<w; x++) {
                gindex = y * w + x;
                if (!this._data.characterData[char][gindex]) { continue; }

                for (int py = 0; py<size; py++) {
                    for (int px = 0; px<size; px++) {
                        tx = ox + x * size + px;
                        ty = oy + y * size + py;
                        index = ty * data.width + tx;

                        data.data[index*4] = colour.red;
                        data.data[index*4+1] = colour.green;
                        data.data[index*4+2] = colour.blue;
                        data.data[index*4+3] = colour.alpha;
                    }
                }
            }
        }
    }

    void drawText(CanvasRenderingContext2D ctx, int size, String text, int x, int y, Colour colour) {
        int w = this.def.textLength(text) * size;
        int h = this.def.glyphHeight * size;

        ImageData idata = ctx.getImageData(x,y,w,h);

        int offset = 0;
        for (int i=0; i<text.length; i++) {
            int char = text.codeUnitAt(i);

            this.drawGlyph(char, ctx, idata, (offset + this.def.charOffset(char)) * size, 0, size, colour);

            offset += this.def.charWidth(char);
        }

        ctx.putImageData(idata, x, y);
    }

    void dropText(CanvasRenderingContext2D ctx, int size, String text, int x, int y, Colour foreground, Colour background, double ox, double oy, int depth) {
        for (int i=depth; i>0; i--) {
            int dx = x + (ox * i).round();
            int dy = y + (oy * i).round();

            this.drawText(ctx, size, text, dx, dy, background);
        }
        this.drawText(ctx, size, text, x, y, foreground);
    }
}

class BitmapFontData {
    static Logger logger = Logger.get("BitmapFontData");

    static Map<String, BitmapFontData> _fonts = <String,BitmapFontData>{};
    static Map<String, List<Completer<BitmapFontData>>> _callbacks = <String, List<Completer<BitmapFontData>>>{};

    Map<int, List<bool>> characterData;

    final int glyphWidth;
    final int glyphHeight;

    BitmapFontData(ImageElement sourceImage, int this.glyphWidth, int this.glyphHeight) {
        int w = sourceImage.width;
        int h = sourceImage.height;

        CanvasElement canvas = new CanvasElement(width:w, height:h);
        CanvasRenderingContext2D ctx = canvas.context2D;
        ctx.drawImage(sourceImage, 0, 0);

        ImageData idata = ctx.getImageData(0, 0, w, h);

        this.characterData = <int, List<bool>>{};

        for(int char=33; char<=126; char++) {
            int i = char-33;

            int ox = glyphWidth * i;

            List<bool> chardata = new List<bool>(glyphWidth * glyphHeight);
            for (int x = 0; x<glyphWidth; x++) {
                for (int y = 0; y<glyphHeight; y++) {
                    int index = y * w + ox + x;

                    chardata[y * glyphWidth + x] = idata.data[index*4] > 0;
                }
            }

            this.characterData[char] = chardata;
        }
    }

    static Future<BitmapFontData> load(String path, int glyphwidth, int glyphheight) async {
        if (_fonts.containsKey(path)) { return _fonts[path]; }

        Completer<BitmapFontData> completer = new Completer<BitmapFontData>();

        if (!_callbacks.containsKey(path)) {
            _callbacks[path] = <Completer<BitmapFontData>>[];

            logger.debug("Requesting $path");

            Loader.getResource(path).then((ImageElement img){
                BitmapFontData font = new BitmapFontData(img, glyphwidth, glyphheight);
                _fonts[path] = font;

                logger.debug("Callbacks for $path");

                for(Completer<BitmapFontData> callback in _callbacks[path]) {
                    callback.complete(font);
                }
                _callbacks[path] = null;
            });
        }
        _callbacks[path].add(completer);

        return completer.future;
    }
}