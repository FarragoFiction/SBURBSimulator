import '../../GameEntities/BigBadStuff/BigBad.dart';
import '../../includes/lz-string.dart';
import '../../navbar.dart';
import '../../text_engine.dart';
import 'dart:html';

//bare minimum for a page.
Element div;
void main() {
  div = querySelector("#story");
  makeTextBox();
}

void makeTextBox() {
  TextAreaElement box = new TextAreaElement();
  div.append(box);
  box.cols = 60;
  box.rows = 10;

  box.onChange.listen((Event e) {
    try {
      DivElement blorp = new DivElement();
      blorp.style.border = "3px solid black";
      div.append(blorp);
      String data = box.value;
      blorp.setInnerHtml( "Value is: $data, Decrypted is: <br><br>");
      blorp.appendText(LZString.decompressFromEncodedURIComponent(data));
    }catch(e) {
      window.alert("error decrypting");
      print("error: $e");
    }
  });
}
