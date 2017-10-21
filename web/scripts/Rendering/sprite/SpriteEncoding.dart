import "dart:typed_data";

import "encoders/basic.dart";
import "encoders/expgolomb.dart";
import "encoders/rle.dart";

import "sprite.dart";

typedef ByteBuffer SpriteDataEncoding(int id, ByteBuffer header, ByteBuffer data, PSprite sprite);
typedef Uint8List SpriteDataDecoding(ByteBuffer buffer, int byteoffset, int length, PSprite sprite);

class SpriteEncodingFormat {
    static Map<int, SpriteEncodingFormat> formats = <int,SpriteEncodingFormat>{
         0: new SpriteEncodingFormat( "Pixels -> Bytes",                 EncodingBasic.encode,                   EncodingBasic.decode                    ),
         1: new SpriteEncodingFormat( "Pixels -> Packed bits",           EncodingBasicBitPack.encode,            EncodingBasicBitPack.decode             ),
         2: new SpriteEncodingFormat( "RLE 1 byte",                      EncodingRLE.encodeWithSize(1),          EncodingRLE.decodeWithSize(1)           ),
         3: new SpriteEncodingFormat( "RLE 2 bytes",                     EncodingRLE.encodeWithSize(2),          EncodingRLE.decodeWithSize(2)           ),
         4: new SpriteEncodingFormat( "RLE 3 bytes",                     EncodingRLE.encodeWithSize(3),          EncodingRLE.decodeWithSize(3)           ),
         5: new SpriteEncodingFormat( "RLE packed 1 byte",               EncodingRLEBitPacked.encodeWithSize(1), EncodingRLEBitPacked.decodeWithSize(1)  ),
         6: new SpriteEncodingFormat( "RLE packed 2 bytes",              EncodingRLEBitPacked.encodeWithSize(2), EncodingRLEBitPacked.decodeWithSize(2)  ),
         7: new SpriteEncodingFormat( "RLE packed 3 bytes",              EncodingRLEBitPacked.encodeWithSize(3), EncodingRLEBitPacked.decodeWithSize(3)  ),
         8: new SpriteEncodingFormat( "RLE dynamic",                     EncodingRLEDynamic.encode,              EncodingRLEDynamic.decode               ),
         9: new SpriteEncodingFormat( "Exponential-Golomb pixels",       EncodingExpGolomb.encode,               EncodingExpGolomb.decode                ),
        10: new SpriteEncodingFormat( "Exponential-Golomb run RLE",      EncodingExpGolombRLE.encode,            EncodingExpGolombRLE.decode             ),
        11: new SpriteEncodingFormat( "Exponential-Golomb run/data RLE", EncodingDoubleExpGolombRLE.encode,      EncodingDoubleExpGolombRLE.decode       ),
    };

    final String name;
    final SpriteDataEncoding encoder;
    final SpriteDataDecoding decoder;

    SpriteEncodingFormat(String this.name, SpriteDataEncoding this.encoder, SpriteDataDecoding this.decoder);
}