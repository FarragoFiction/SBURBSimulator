import "dart:math";
import "dart:typed_data";

import "../../../includes/bytebuilder.dart";
import "../sprite.dart";


class EncodingBasic {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		Uint8List datalist = data.asUint8List();

		for (int i in datalist) {
			builder.appendByte(i);
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite) {
		Uint8List data = new Uint8List(length);

		ByteReader reader = new ByteReader(buffer, byteoffset);

		for (int i=0; i<length; i++) {
			data[i] = reader.readByte();
		}

		return data;
	}
}

class EncodingBasicBitPack {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		Uint8List datalist = data.asUint8List();

		for (int i in datalist) {
			builder.appendBits(i, bitcount);
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite) {
		Uint8List data = new Uint8List(length);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		ByteReader reader = new ByteReader(buffer, byteoffset);

		for (int i=0; i<length; i++) {
			data[i] = reader.readBits(bitcount);
		}

		return data;
	}
}