/**
 *	Builds ArrayBuffers of data in an easy to use way.
 *
 *	@class
 */
function ByteBuilder() {
	this.data = "";
	this.currentByte = 0;
	this.position = 0;
}

/**
 *	Adds a single bit to the buffer. The basis of the other write methods.
 *
 *	@param {boolean} bit - Bit to be written to the buffer.
 */
ByteBuilder.prototype.appendBit = function(bit) {
	if (bit) {
		this.currentByte |= (1 << this.position);
	}
	this.position++;

	if (this.position >= 8) {
		this.position = 0;
		
		this.data += String.fromCharCode(this.currentByte);

		this.currentByte = 0;
	}
}

/**
 *	Appends multiple bits from an integer, up to a specified number of bits
 *
 *	@param {number} bits - The source number for the appended bits.
 *	@param {number} length - Number of bits from the number to append.
 */
ByteBuilder.prototype.appendBits = function(bits, length) {
	for (var i=0; i<length; i++) {
		this.appendBit((bits & (1 << i)) > 0);
	}
}

/**
 *	Appends multiple bits from an integer, but the resulting bit order is reversed. Added for the sake of Exp-Golomb encoding and endian problems.
 *
 *	@param {number} bits - The source number for the appended bits.
 *	@param {number} length - Number of bits from the number to append.
 */
ByteBuilder.prototype.appendBitsReversed = function(bits, length) {
	for (var i=0; i<length; i++) {
		this.appendBit((bits & (1 << ((length-1)-i))) > 0);
	}
}

/**
 *	Appends 8 bytes from the input to the buffer
 *
 *	@param {number} byte - The number from which 8 bits will be appended.
 */
ByteBuilder.prototype.appendByte = function(byte) {
	this.appendBits(byte, 8);
}

/**
 *	Appends 32 bytes from the input to the buffer
 *
 *	@param {number} num - The number from which 32 bits will be appended.
 */
ByteBuilder.prototype.appendInt32 = function(num) {
	this.appendBits(num, 32);
}

/**
 *  Appends a number to the buffer using exponential-Golomb encoding
 *
 *  @param {number} num - The number to encode
 */
ByteBuilder.prototype.appendExpGolomb = function(num) {
    num++;

    var bits = Math.floor(Math.log(num)/Math.LN2);

    for (var i=0; i<bits; i++) {
        this.appendBit(false);
    }

    this.appendBitsReversed(num, bits+1);
}

/**
 *	Returns an ArrayBuffer containing the data from the builder. 
 *
 *	@param {ArrayBuffer} [bufferToExtend] - Optional. If specified, the data from this will be at prepended to the builder's data.
 *
 *	@returns {ArrayBuffer} ArrayBuffer representing data collected by the ByteBuilder
 */
ByteBuilder.prototype.toBuffer = function(bufferToExtend) {
	var length = this.position > 0 ? this.data.length + 1 : this.data.length;
	var offset = 0;
	
	var extending = false;
	
	if (typeof(bufferToExtend) !== "undefined" && bufferToExtend != null) {
		length += bufferToExtend.byteLength;
		offset = bufferToExtend.byteLength;
		extending = true;
	}
	
	var list = new Uint8Array(length);
	
	if (extending) {
		var view = new Uint8Array(bufferToExtend);
		for (var i=0; i<view.length; i++) {
			list[i] = view[i];
		}
	}
	
	for (var i=0; i<this.data.length; i++) {
		list[i+offset] = this.data.charCodeAt(i);
	}
	if (this.position > 0) {
		list[this.data.length + offset] = this.currentByte;
	}
	
	return list.buffer;
}

//##################################################################################################################
//##################################################################################################################
//##################################################################################################################

/**
 *	Reads data from an ArrayBuffer in an easy to use way.
 *
 *	@class
 *	@param {ArrayBuffer} bytes - The source ArrayBuffer to read from.
 *	@param {number} [offset=0] - Optional. Byte offset to start reading from.
 */
function ByteReader(bytes, offset) {
	var o = 0;
	if (typeof(offset) !== "undefined") {
		o = offset;
	}

	this.bytes = new Uint8Array(bytes, o);
	this.position = 0;
}

/**
 *	Reads a single bit at a specified position. For internal use only.
 *
 *	@param {number} position - Bit offset to read from.
 *
 *	@returns {boolean} State of the bit at position.
 */
ByteReader.prototype.read = function(position) {
	var bytepos = Math.floor(position / 8);
	var bitpos = position % 8;

	if (bytepos >= this.bytes.length) {
	    throw "Attempted to read out of range: "+bytepos;
	}

	var byte = this.bytes[bytepos];
	
	return (byte & (1 << bitpos)) > 0;
}

/**
 *	Reads one bit from the buffer.
 *
 *	@returns {boolean} State of the next bit in the buffer.
 */
ByteReader.prototype.readBit = function() {
	var val = this.read(this.position);
	this.position++;
	return val;
}

/**
 *	Reads multiple bits from the buffer.
 *
 *	@param {number} bitcount - How many bits to read.
 *
 *	@returns {number} A number representing the next bitcount bits from the buffer.
 */
ByteReader.prototype.readBits = function(bitcount) {
	if (bitcount > 32) {
		throw "bitcount may not exceed 32";
	}
	var val = 0;
	
	for (var i=0; i<bitcount; i++) {
		if (this.readBit()) {
			val |= (1 << i);
		}
	}
	
	return val;
}

/**
 *	Reads multiple bits from the buffer, but in reverse order. Mostly added for Exp-Golomb encoding and endian issues.
 *
 *	@param {number} bitcount - How many bits to read.
 *
 *	@returns {number} A number representing the next bitcount bits from the buffer, read in reverse order.
 */
ByteReader.prototype.readBitsReversed = function(bitcount) {
		if (bitcount > 32) {
		throw "bitcount may not exceed 32";
	}
	var val = 0;
	
	for (var i=0; i<bitcount; i++) {
		if (this.readBit()) {
			val |= (1 << ((bitcount-1)-i));
		}
	}
	
	return val;
}

/**
 *	Reads 8 bits from the buffer.
 *
 *	@returns {number} A number representing the next 8 bits from the buffer.
 */
ByteReader.prototype.readByte = function() {
	return this.readBits(8);
}

/**
 *	Reads 32 bits from the buffer.
 *
 *	@returns {number} A number representing the next 32 bits from the buffer.
 */
ByteReader.prototype.readInt32 = function() {
	return this.readBits(32);
}

/**
 *  Reads a number encoded using exponential-Golomb encoding.
 */
ByteReader.prototype.readExpGolomb = function() {
    var bits = 0;

    while (true) {
        if (this.readBit()) {
            this.position--;
            break;
        } else {
            bits++;
        }
    }

    return (this.readBitsReversed(bits+1))-1;
}