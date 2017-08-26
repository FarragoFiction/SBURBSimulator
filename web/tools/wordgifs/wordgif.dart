import 'dart:html';

import '../../scripts/Rendering/wordgif.dart';
import '../../scripts/includes/colour.dart';


void main() {
    int stops = 20;
    List<Colour> fore = <Colour>[];
    for (int i=0; i<stops; i++) {
        fore.add(new Colour.hsv((1.0/stops) * i, 1.0, 1.0));
    }
    List<Colour> back = fore.map((Colour c) => c * 0.5).toList();


    querySelector("#stuff").append(WordGif.dropText("2x CORPSESMOOCH COMBO!!", 3, fore,back, 1, 1, 5));

}
