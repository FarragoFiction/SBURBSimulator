import '../../navbar.dart';
import '../../text_engine.dart';
import 'dart:html';

//bare minimum for a page.
void main() {
  loadNavbar();
  //TODO hide all wranglers but the one passed in the command line. if none past, display error.
  displayBio();
}

void displayBio() {
  String staff = getParameterByName("staff",null);
  DateTime now = new DateTime.now();

  if(now.month == 4 && now.day == 1) {
    changeAvatar(staff);
  }
  Element div = querySelector("#$staff");
  if(div != null) div.classes.remove("void");

  ButtonElement button = querySelector("#layWaste") as ButtonElement;
  button.onClick.listen((e)
  {
    TextAreaElement t =  querySelector("#myHeadCanon") as TextAreaElement;
    DivElement canon =  querySelector("#canon") as DivElement;

    DivElement newFact = new DivElement();
    newFact.text = t.value;
    canon.append(newFact);
  });

  TextEngine text = new TextEngine()..loadList("headcanon");

  querySelector("#askAB").onClick.listen((Event e){
    querySelector("#canon")..append(new DivElement()..text = "AB: ${text.phrase("JRheadcanon")}")..style.color ="#ff0000"..style.backgroundColor = "#888888";
  });
}


void changeAvatar(String staff) {
  ImageElement img = querySelector("#${staff}Avatar");
  img.src = img.src.replaceAll(".png", "_sauce.png");
}



