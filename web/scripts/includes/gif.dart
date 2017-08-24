import 'dart:html';
import 'dart:typed_data';

import 'bytebuilder.dart';
import 'colour.dart';
import 'lz-string.dart';
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
    int width;
    int height;

    Palette palette;

    List<Uint8List> frames = <Uint8List>[];
    List<int> delays = <int>[];

    Gif(int this.width, int this.height, [Palette this.palette]) {
        if (this.palette == null) {
            this.palette = new Palette();
        }
    }

    /// Delay is measured in hundredths of a second.
    void addFrame(CanvasImageSource img, [int delay = 5]) {

    }
}