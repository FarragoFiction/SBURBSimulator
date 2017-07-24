@JS()
library lzstring;

import 'package:js/js.dart';
import 'dart:typed_data';

@JS()
abstract class LZString {
	external static String compress(String string);
	external static String decompress(String compressed);

	external static String compressToUTF16(String string);
	external static String decompressFromUTF16(String compressed);

	external static Uint8List compressToUint8Array(String string);
	external static String decompressFromUint8Array(Uint8List compressed);

	external static String compressToEncodedURIComponent(String string);
	external static String decompressFromEncodedURIComponent(String compressed);
}