import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  
  todo("Have Big Bad know how to load/save it's data string. have text area box");
  todo("Have a button (created by a static method) to add one of X different kinds of trigger conditions");
  todo("Have trigger conditions know how to draw themselves");
  todo("have a button (created by a a static method) to add one of X different AI ACTIONS");
  todo("have AI ACTION know how to draw themselves");
  setUpForm();

}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  bigBad.drawForm(formElement);
}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}




