import '../../navbar.dart';
import 'dart:html';

//bare minimum for a page.
void main() {
  loadNavbar();
  //TODO hide all wranglers but the one passed in the command line. if none past, display error.
  displayBio();
}

void displayBio() {
  String staff = getParameterByName("staff",null);
  Element div = querySelector("#$staff");
  if(div != null) div.classes.remove("void");
}


