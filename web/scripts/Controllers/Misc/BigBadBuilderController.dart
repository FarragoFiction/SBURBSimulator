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
  
  todo("start scenes know how to render a add trigger condition button");
  todo("adding a trigger condition adds it to the owning scene");

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




