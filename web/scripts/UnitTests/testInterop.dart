import "../lz-string.dart";
part "JRTestSuite.dart";

typedef dynamic Compression(String input);
typedef String Decompression(dynamic compressed);

// this one needs to be run via browser because the JS module is illegal in standalone, launch the associated page
void main() {
	testCompressionMethod("LZ", LZString.compress, LZString.decompress);
	testCompressionMethod("UTF16", LZString.compressToUTF16, LZString.decompressFromUTF16);
	testCompressionMethod("Uint8", LZString.compressToUint8Array, LZString.decompressFromUint8Array);
	testCompressionMethod("URI", LZString.compressToEncodedURIComponent, LZString.decompressFromEncodedURIComponent);
}

void testCompressionMethod(String name, Compression compress, Decompression decompress) {
	String input = "blah blah blah";
	dynamic compressed = compress(input);
	String decompressed = decompress(compressed);
	jRAssert(name, decompressed, input);
}