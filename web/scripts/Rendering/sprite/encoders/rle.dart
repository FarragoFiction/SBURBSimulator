import "dart:math";
import "dart:typed_data";

import "../../../includes/bytebuilder.dart";
import "../SpriteEncoding.dart";
import "../sprite.dart";

class EncodingRLE {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite, int blocksize) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		int blocklength = pow(256,blocksize);

		Uint8List datalist = data.asUint8List();

		int offset = 0;
		while(offset < datalist.length) {
			int id = datalist[offset];
			int length = 1;
			while (offset + length < datalist.length && datalist[length + offset] == id && length < blocklength) {
				length++;
			}

			builder.appendBits(length-1, 8*blocksize);
			builder.appendByte(id);

			offset += length;
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite, int blocksize) {
		Uint8List data = new Uint8List(length);

		ByteReader reader = new ByteReader(buffer, byteoffset);

		int offset = 0;

		while(offset < length) {
			int count = reader.readBits(blocksize * 8)+1;
			int id = reader.readByte();

			for (int i=0; i<count; i++) {
				data[offset+i] = id;
			}

			offset += count;
		}

		return data;
	}

	static SpriteDataEncoding encodeWithSize(int blocksize) => (int id, ByteBuffer header, ByteBuffer data, PSprite sprite) => encode(id, header, data, sprite, blocksize);
	static SpriteDataDecoding decodeWithSize(int blocksize) => (ByteBuffer buffer, int byteoffset, int length, PSprite sprite) => decode(buffer, byteoffset, length, sprite, blocksize);
}

class EncodingRLEBitPacked {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite, int blocksize) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		int blocklength = pow(256,blocksize);

		Uint8List datalist = data.asUint8List();

		int offset = 0;
		while(offset < datalist.length) {
			int id = datalist[offset];
			int length = 1;
			while (offset + length < datalist.length && datalist[length + offset] == id && length < blocklength) {
				length++;
			}

			builder.appendBits(length-1, 8*blocksize);
			builder.appendBits(id, bitcount);

			offset += length;
		}

		return builder.toBuffer(header);
	}

	static Uint8List decode(ByteBuffer buffer, int byteoffset, int length, PSprite sprite, int blocksize) {
		Uint8List data = new Uint8List(length);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		ByteReader reader = new ByteReader(buffer, byteoffset);

		int offset = 0;

		while(offset < length) {
			int count = reader.readBits(blocksize * 8)+1;
			int id = reader.readBits(bitcount);

			for (int i=0; i<count; i++) {
				data[offset+i] = id;
			}

			offset += count;
		}

		return data;
	}

	static SpriteDataEncoding encodeWithSize(int blocksize) => (int id, ByteBuffer header, ByteBuffer data, PSprite sprite) => encode(id, header, data, sprite, blocksize);
	static SpriteDataDecoding decodeWithSize(int blocksize) => (ByteBuffer buffer, int byteoffset, int length, PSprite sprite) => decode(buffer, byteoffset, length, sprite, blocksize);
}

class EncodingRLEDynamic {
	static ByteBuffer encode(int id, ByteBuffer header, ByteBuffer data, PSprite sprite) {
		ByteBuilder builder = new ByteBuilder();

		builder.appendByte(id);

		int bitcount = (log(sprite.paletteNames.length)/LN2).floor() +1;

		int maxlength = pow(2,32);

		Uint8List datalist = data.asUint8List();

		int offset = 0;
		while(offset < datalist.length) {
			int id = datalist[offset];
			int length = 1;
			while (offset + length < datalist.length && datalist[length + offset] == id && length < maxlength) {
				length++;
			}

			int lengthbitcount = (log(length)/LN2).floor() +1;

			builder.appendBits(lengthbitcount-1, 5);
			builder.appendBits(length-1, lengthbitcount);
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
			int countbits = reader.readBits(5)+1;
			int count = reader.readBits(countbits)+1;
			int id = reader.readBits(bitcount);

			for (int i=0; i<count; i++) {
				data[offset+i] = id;
			}

			offset += count;
		}

		return data;
	}
}