import 'dart:typed_data';
import 'dart:math';

/// Builds a compacted [ByteBuffer] of data with syntax similar to [StringBuffer].
class ByteBuilder {
	/// Internal buffer.
	StringBuffer _data = new StringBuffer();
	/// Current working byte, bits are appended to this up to 8, then it is added to the buffer.
	int _currentbyte = 0;
	/// Bit position within the current working byte.
	int _position = 0;

	/// Creates a new ByteBuilder with an empty buffer.
	ByteBuilder();

	/// Appends a single bit to the buffer.
	void appendBit(bool bit) {
		if (bit) {
			_currentbyte |= (1 << _position);
		}
		_position++;
		if (_position >= 8) {
			_position = 0;
			_data.writeCharCode(_currentbyte);
			_currentbyte = 0;
		}
	}

	/// Appends [length] bits of [bits] to the buffer.
	void appendBits(int bits, int length) {
		for (int i=0; i<length; i++) {
			appendBit(bits & (1 << i) > 0);
		}
	}

	/// Appends [length] bits of [bits] to the buffer, in reverse order.
	///
	/// Used by [appendExpGolomb].
	void appendBitsReversed(int bits, int length) {
		for (int i=0; i<length; i++) {
			appendBit(bits & (1 << ((length-1)-i)) > 0);
		}
	}

	/// Appends 8 bits of [byte] to the buffer.
	void appendByte(int byte) {
		appendBits(byte, 8);
	}

	/// Appends 16 bits of [i] to the buffer.
	void appendShort(int i) {
		appendBits(i, 16);
	}

	/// Appends 32 bits of [i] to the buffer.
	void appendInt32(int i) {
		appendBits(i, 32);
	}

	/// Appends [i] to the buffer using Exponential-Golomb encoding.
	///
	/// [Wikipedia reference](https://en.wikipedia.org/wiki/Exponential-Golomb_coding)
	void appendExpGolomb(int i) {
		i++;

		int bits = log(i)~/LN2;

		for (int i=0; i<bits; i++) {
			this.appendBit(false);
		}

		this.appendBitsReversed(i, bits+1);
	}

	/// Appends all numbers in [bits] to the buffer as [length] bit long segments.
	void appendAllBits(List<int> bits, int length) {
		for (int number in bits) {
			this.appendBits(number, length);
		}
	}

	/// Appends all numbers in [bytes] as bytes.
	void appendAllBytes(List<int> bytes) {
		this.appendAllBits(bytes, 8);
	}

	/// Appends all numbers in [numbers] using Exponential-Golomb encoding.
	void appendAllExpGolomb(List<int> numbers) {
		for (int number in numbers) {
			this.appendExpGolomb(number);
		}
	}

	/// Creates a new [ByteBuffer] containing the data in this ByteBuilder.
	ByteBuffer toBuffer([ByteBuffer toExtend = null]) {
		int length = _position > 0 ? _data.length+1 : _data.length;
		int offset = 0;

		////print(this._data.toString());

		if (toExtend != null) {
			length += toExtend.lengthInBytes;
			offset = toExtend.lengthInBytes;
		}

		Uint8List list = new Uint8List(length);

		if (toExtend != null) {
			Uint8List view = new Uint8List.view(toExtend);
			for (int i=0; i<view.length; i++) {
				list[i] = view[i];
			}
		}

		String data = _data.toString();

		for (int i=0; i<data.length; i++) {
			list[i+offset] = data.codeUnitAt(i);
		}
		if (_position > 0) {
			list[data.length+offset] = _currentbyte;
		}

		return list.buffer;
	}

	/// Convenience function for pretty-printing a [ByteBuffer].
	static void prettyPrintByteBuffer(ByteBuffer buffer) {
		Uint8List list = new Uint8List.view(buffer);

		StringBuffer sb = new StringBuffer("Bytes: ${buffer.lengthInBytes} [");

		for (int i=0; i<list.length; i++) {
			sb.write("0x${list[i].toRadixString(16).padLeft(2,"0").toUpperCase()}");
			if (i < list.length-1) {
				sb.write(", ");
			}
		}

		sb.write("]");

		print(sb.toString());
	}
}

/// Reads a [ByteBuffer] as a stream of bits.
class ByteReader {
	/// Source buffer.
	ByteData _bytes;
	/// Current bit position within the buffer.
	int _position = 0;

	/// Creates a new ByteReader reading from [bytes]. The start position will be offset by [offset] bytes.
	ByteReader(ByteBuffer bytes, [int offset = 0]) {
		this._bytes = bytes.asByteData(offset);
	}

	/// Internal method for reading a bit at a specific position. Use read for getting single bits from the buffer instead.
	bool _read(int position) {
		int bytepos = (position / 8.0).floor();
		int bitpos = position % 8;

		int byte = _bytes.getUint8(bytepos);

		return byte & (1 << bitpos) > 0;
	}

	/// Reads the next bit from the buffer.
	bool readBit() {
		bool val = this._read(this._position);
		_position++;
		return val;
	}

	/// Reads the next [bitcount] bits from the buffer.
	int readBits(int bitcount) {
		if (bitcount > 32) {
			throw new ArgumentError.value(bitcount,"bitcount may not exceed 32");
		}
		int val = 0;

		for (int i=0; i<bitcount; i++) {
			if (readBit()) {
				val |= (1 << i);
			}
		}

		return val;
	}

	/// Reads the next [bitcount] bits from the buffer, in reverse order.
	///
	/// Used by readExpGolomb.
	int readBitsReversed(int bitcount) {
		if (bitcount > 32) {
			throw new ArgumentError.value(bitcount,"bitcount may not exceed 32");
		}
		int val = 0;

		for (int i=0; i<bitcount; i++) {
			if (readBit()) {
				val |= (1 << ((bitcount-1)-i));
			}
		}

		return val;
	}

	/// Reads the next 8 bits from the buffer.
	int readByte() {
		return readBits(8);
	}

	/// Reads the next 16 bits from the buffer.
	int readShort() {
		return readBits(16);
	}

	/// Reads the next 32 bits from the buffer.
	int readInt32() {
		return readBits(32);
	}

	/// Reads a number encoded with Exponential-Golomb encoding from the buffer.
	///
	/// The bit length read depends upon the encoded number.
	///
	/// [Wikipedia reference](https://en.wikipedia.org/wiki/Exponential-Golomb_coding)
	int readExpGolomb() {
		int bits = 0;

		while (true) {
			if (this.readBit()) {
				this._position--;
				break;
			} else {
				bits++;
			}
		}

		return (this.readBitsReversed(bits+1))-1;
	}
}