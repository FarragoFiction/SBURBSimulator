import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";
import "CurrentUpdateProgress.dart";


Element div;
UListElement todoElement;
DivElement faqElement;
Item item = new Item("Test Item (make sure to add traits)", <ItemTrait>[]);
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
  item.renderForm(formElement);
}



