import "dart:async";
import "dart:math" as Math;
import "dart:typed_data";

import "../Rendering/sprite/SpriteEncoding.dart";
import "../Rendering/sprite/sprite.dart";
import "../includes/bytebuilder.dart";
import "Formats.dart";


class SpriteFormat extends BinaryFileFormat<PSprite> {

    @override
    String mimeType() => "application/octet-stream";

    @override
    Future<PSprite> read(ByteBuffer input) async {
        String headerText = this.header();

        ByteReader reader = new ByteReader(input);
        int offset = headerText.codeUnits.length + 3; // header, one for dimension size, one for palette size, one for encoder id

        StringBuffer sb = new StringBuffer();
        for (int i=0; i<headerText.codeUnits.length; i++) {
            sb.writeCharCode(reader.readByte());
        }
        String loadedheader = sb.toString();
        if(loadedheader != this.header()) {
            throw "Invalid header: $loadedheader";
        }

        int sizeBytes = reader.readByte(); // bytes for each dimension
        offset += sizeBytes * 6;

        int width = reader.readBits(8 * sizeBytes);
        int height = reader.readBits(8 * sizeBytes);

        int zonex = reader.readBits(8 * sizeBytes);
        int zoney = reader.readBits(8 * sizeBytes);
        int zoneWidth = reader.readBits(8 * sizeBytes);
        int zoneHeight = reader.readBits(8 * sizeBytes);
        int zoneLength = zoneWidth * zoneHeight;

        PSprite sprite = new PSprite(width, height);

        int paletteSize = reader.readByte(); // palette entry count

        for (int i=0; i<paletteSize; i++) {
            int paletteID = reader.readByte();
            int nameLength = reader.readByte();
            offset += nameLength + 2; // name in bytes plus palette ID and name length byte

            List<int> chars = new List<int>(nameLength);

            for (int j=0; j<nameLength; j++) {
                chars[j] = reader.readByte();
            }

            String name = new String.fromCharCodes(chars);

            sprite.paletteNames[paletteID] = name;
        }

        int encoding = reader.readByte();

        SpriteEncodingFormat format = SpriteEncodingFormat.formats[encoding];
        if (format == null) {
            throw "Sprite decoding error: Encoding id $encoding not supported.";
        }

        Uint8List data = format.decoder(input, offset, zoneLength, sprite);

        sprite.writeDataRegion(zonex, zoney, zoneWidth, data);
        sprite.recalculateBounds();

        return sprite;
    }

    @override
    Future<ByteBuffer> write(PSprite sprite) async {
        ByteBuilder builder = new ByteBuilder();

        builder.appendAllBytes(this.header().codeUnits);

        // calculate minimum bounds to minimise saved data
        int minx = sprite.width;
        int miny = sprite.height;
        int maxx = -1;
        int maxy = -1;

        for (int x=0; x<sprite.width; x++) {
            for (int y=0; y<sprite.height; y++) {
                int id = sprite.data[y * sprite.width + x];
                if (id != 0) {
                    if (x < minx) {
                        minx = x;
                    } else if (x > maxx) {
                        maxx = x;
                    }
                    if (y < miny) {
                        miny = y;
                    } else if (y > maxy) {
                        maxy = y;
                    }
                }
            }
        }

        int zonewidth = Math.max(0, maxx - minx + 1);
        int zoneheight = Math.max(0, maxy - miny + 1);

        // number of bytes for dimensions
        int bigdim = Math.max(sprite.width, sprite.height);

        int bits = (Math.log(bigdim)/Math.LN2).floor() +1;
        if (bits > 32) {
            throw new ArgumentError.value(bigdim, "Sprite dimensions may not exceed 2^32 pixels");
        }
        int bytecount = (bits / 8.0).ceil();

        builder.appendByte(bytecount);

        // dimensions
        builder.appendBits(sprite.width, bytecount*8);
        builder.appendBits(sprite.height, bytecount*8);

        // pixel zone location and width
        builder.appendBits(minx, bytecount*8);
        builder.appendBits(miny, bytecount*8);
        builder.appendBits(zonewidth, bytecount*8);
        builder.appendBits(zoneheight, bytecount*8);

        // number of colours in sprite palette
        builder.appendByte(sprite.paletteNames.length);

        // palette entries
        sprite.paletteNames.forEach((int id, String name) {
            builder.appendByte(id);
            builder.appendByte(name.codeUnits.length);
            for (int i = 0; i<name.codeUnits.length; i++) {
                builder.appendByte(name.codeUnitAt(i));
            }
        });

        ByteBuffer header = builder.toBuffer();

        // build data buffer
        Uint8List data = new Uint8List(zonewidth * zoneheight);

        sprite.forDataRegion(minx, miny, zonewidth, zoneheight, (PSprite sprite, int dataindex, int regionindex) {
            data[regionindex] = sprite.data[dataindex];
        });

        // check each encoding method to see which is the smallest result, or use the forced one
        ByteBuffer bestOutput = null;
        SpriteEncodingFormat bestmethod = null;

        double size = double.INFINITY;
        SpriteEncodingFormat.formats.forEach((int id, SpriteEncodingFormat format) {
            ByteBuffer potential = format.encoder(id, header, data.buffer, sprite);
            int length = potential.lengthInBytes;
            print("Encoding method $id - ${format.name}: $length bytes");
            if (length < size) {
                size = length.toDouble();
                bestmethod = format;
                bestOutput = potential;
            }
        });

        if (bestOutput == null) {
            throw new Error();
        }

        print("Encoding sprite: ${bestmethod.name}: ${bestOutput.lengthInBytes} bytes");

        return bestOutput;
    }


    @override
    String header() => "SPRITE";
}