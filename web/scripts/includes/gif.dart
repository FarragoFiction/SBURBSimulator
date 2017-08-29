import 'dart:html';
import 'dart:typed_data';

import 'bytebuilder.dart';
import 'colour.dart';
import 'logger.dart';
import 'lzw.dart' as LZW;
import 'palette.dart';

/// Simplistic GIF encoder.
///
/// I am probably crazy for doing this. Fuck it.
///
/// No colour quantisation, no fancy dithering, not a whole lot really,
/// but it does have transparency!
/// Made for the animated text because I didn't want ANOTHER js library in here...
/// Luckily we already have pretty much everything needed to encode
/// a gif with Palette, ByteBuilder and LZ-String!
/// -PL
class Gif {
    static Logger logger = Logger.get("GIF");

    int width;
    int height;

    Palette palette;

    List<Uint8List> frames = <Uint8List>[];
    List<int> delays = <int>[];

    CanvasElement bufferCanvas;
    CanvasRenderingContext2D bufferContext;

    Gif(int this.width, int this.height, [Palette this.palette]) {
        if (this.palette == null) {
            this.palette = new Palette()..addHex("bg", 0x000000);
        }
        this.bufferCanvas = new CanvasElement(width:width, height:height);
        this.bufferContext = bufferCanvas.context2D;
    }

    /// Delay is measured in hundredths of a second.
    void addFrame(CanvasImageSource img, [int delay = 5]) {
        this.clearBuffer();
        this.bufferContext.drawImage(img, 0, 0);
        ImageData idata = this.bufferContext.getImageData(0, 0, width, height);

        Uint8List frame = new Uint8List(width*height);

        int index;
        for (int y=0; y<height; y++) {
            for (int x=0; x<width; x++) {
                index = (y * width + x);

                if (idata.data[index*4 + 3] == 0) {
                    frame[index] = 0;
                } else {
                    frame[index] = idata.data[index*4];
                }
            }
        }

        this.frames.add(frame);
        this.delays.add(delay);
    }

    void clearBuffer() {
        this.bufferContext.clearRect(0, 0, width, height);
    }

    ByteBuffer build() {
        ByteBuilder builder = new ByteBuilder();

        int colourBits = this.getColourBits();

        this.header(builder, colourBits);
        this.colourTable(builder, colourBits);

        if (frames.length <= 1) {
            if (frames.length == 1) {
                this.startImage(builder);
                this.frameData(builder, frames[0], colourBits);
            }
        } else {
            this.loop(builder, 0); // 0 repeats = forever

            for (int i=0; i<frames.length; i++) {
                this.delay(builder, this.delays[i]);
                this.startImage(builder);
                this.frameData(builder, frames[i], colourBits);
            }
        }
        this.footer(builder);

        return builder.toBuffer();
    }

    int getColourBits() {
        for (int bits=1; bits<=8; bits++) {
            int size = 1 << bits;
            if (size > this.palette.length) {
                return bits;
            }
        }
        return 8;
    }

    void header(ByteBuilder builder, int colourBits) {
        builder
            ..appendByte(0x47) // G
            ..appendByte(0x49) // I
            ..appendByte(0x46) // F
            ..appendByte(0x38) // 8
            ..appendByte(0x39) // 9
            ..appendByte(0x61) // a
            ..appendShort(width)
            ..appendShort(height);
    }

    void colourTable(ByteBuilder builder, int colourBits) {
        builder
            ..appendByte(0xF0 | (colourBits - 1)) // colour table follows, 1 << colourBits long
            ..appendByte(0x00) // colour 0 is the background
            ..appendByte(0x00); // default pixel ratio

        int colours = 1 << colourBits;
        for (int i=0; i<colours; i++) {
            if (i >= this.palette.length) {
                builder.appendBits(0, 24); // 0,0,0
            } else {
                Colour c = this.palette[i];
                builder
                    ..appendByte(c.red)
                    ..appendByte(c.green)
                    ..appendByte(c.blue);
            }
        }

        builder
            ..appendByte(0x21) // graphics control extension
            ..appendByte(0xF9)
            ..appendByte(0x04) // 4 bytes of GCE follows
            ..appendByte(0x01) // transparent background
            ..appendShort(0x0000) // delay, not used
            ..appendByte(0x00) // colour 0 is transparent
            ..appendByte(0x00);// GCE terminator
    }

    void startImage(ByteBuilder builder) {
        builder
            ..appendByte(0x2C) // Image Descriptor block
            ..appendShort(0x0000) // top
            ..appendShort(0x0000) // left
            ..appendShort(width) // width
            ..appendShort(height) // height
            ..appendByte(0x00); // no local colour table, no interlace
    }

    void frameData(ByteBuilder builder, Uint8List frame, int colourBits) {
        builder.appendAllBytes(LZW.compress(frame, colourBits));
    }

    void loop(ByteBuilder builder, int repeats) {
        builder
            ..appendByte(0x21) // Application Extension block
            ..appendByte(0xFF)
            ..appendByte(0x0B) // 11 bytes follow
            ..appendAllBytes("NETSCAPE2.0".codeUnits) // 11 bytes of app name and code
            ..appendByte(0x03) // 3 more bytes
            ..appendByte(0x01) // data sub-block index (always 1)
            ..appendShort(repeats) // repeat count
            ..appendByte(0x00); // end of AE
    }

    void delay(ByteBuilder builder, int delay) {
        builder
            ..appendByte(0x21) // Graphic Control Extension block
            ..appendByte(0xF9)
            ..appendByte(0x04) // 4 bytes follow
            ..appendByte(0x09) // 000|010|0|1 -> restore to background colour, has transparency
            ..appendShort(delay) // delay in hundredths of a second
            ..appendByte(0x00) // transparent colour
            ..appendByte(0x00); // end of GCE
    }

    void footer(ByteBuilder builder) {
        builder.appendByte(0x3B); // GIF terminator
    }

    static Uri dataUri(ByteBuffer data) {
        return new Uri.dataFromBytes(data.asUint8List(), mimeType: "image/gif");
    }

    Uri buildDataUri() {
        return dataUri(this.build());
    }
}