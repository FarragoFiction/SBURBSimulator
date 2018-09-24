import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";
import "CurrentUpdateProgress.dart";


Element div;
UListElement todoElement;
DivElement faqElement;
Fraymotif fraymotif = new Fraymotif("Sample Fraymotif",1,desc: "OWNER plays a 90s hit classic, and you can't help but tap your feet. ENEMY seems to not be able to stand it at all.");
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();

  div = querySelector("#story");
  setUpForm();

}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  fraymotif.renderForm(formElement);
}



