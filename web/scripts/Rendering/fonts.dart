import 'bitmapfont.dart';

abstract class Fonts {
    static BitmapFontDefinition courier_new_14px = new BitmapFontDefinition("images/fonts/courier_new_14px.png", 10, 16, 8)
        ..widthOverride("!", 4)
        ..widthOverride("S", 7)
        ..widthOverride("O", 7)
        ..widthOverride("C", 7)
        ..widthOverride("X", 7)
        ..widthOverride("Y", 7)
        ..widthOverride("m", 9)

        ..offset("!", -1)
        ..offset("S", -1)
        ..offset("O", -1)
        ..offset("C", -1)
        ..offset("X", -1)
        ..offset("Y", -1);
}