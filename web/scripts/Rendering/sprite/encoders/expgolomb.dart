import "dart:math";
import "dart:typed_data";

import "../../../includes/bytebuilder.dart";
import "../sprite.dart";

class EncodingExpGolomb {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		Uint8List datalist = data.asUint8List();

		for (int i in datalist) {
			builder.appendExpGolomb(i);
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite) {
		Uint8List data = new Uint8List(length);

		ByteReader reader = new ByteReader(buffer, byteoffset);

		for (int i=0; i<length; i++) {
			data[i] = reader.readExpGolomb();
		}

		return data;
	}
}

class EncodingExpGolombRLE {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		Uint8List datalist = data.asUint8List();

		int offset = 0;
		while(offset < datalist.length) {
			int id = datalist[offset];
			int length = 1;
			while (offset + length < datalist.length && datalist[length + offset] == id) {
				length++;
			}

			builder.appendExpGolomb(length-1);
			builder.appendBits(id, bitcount);

			offset += length;
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite) {
		Uint8List data = new Uint8List(length);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		ByteReader reader = new ByteReader(buffer, byteoffset);

		int offset = 0;

		while(offset < length) {
			int count = reader.readExpGolomb()+1;
			int id = reader.readBits(bitcount);

			for (int i=0; i<count; i++) {
				data[offset+i] = id;
			}

			offset += count;
		}

		return data;
	}
}

class EncodingDoubleExpGolombRLE {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		Uint8List datalist = data.asUint8List();

		int offset = 0;
		while(offset < datalist.length) {
			int id = datalist[offset];
			int length = 1;
			while (offset + length < datalist.length && datalist[length + offset] == id) {
				length++;
			}

			builder.appendExpGolomb(length-1);
			builder.appendExpGolomb(id);

			offset += length;
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite) {
		Uint8List data = new Uint8List(length);

		ByteReader reader = new ByteReader(buffer, byteoffset);

		int offset = 0;

		while(offset < length) {
			int count = reader.readExpGolomb()+1;
			int id = reader.readExpGolomb();

			for (int i=0; i<count; i++) {
				data[offset+i] = id;
			}

			offset += count;
		}

		return data;
	}
}