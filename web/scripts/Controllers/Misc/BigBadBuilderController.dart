import '../../navbar.dart';
import 'dart:html';

Element div;
UListElement todoElement;
void main() {
  loadNavbar();
  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  
  todo("Create an Empty Big Bad");
  todo("Have that BigBad know how to draw it's own form, start with name");
  todo("Have Big Bad know how to load/save it's data string. have text area box");
  todo("Have a button (created by a static method) to add one of X different kinds of trigger conditions");
  todo("Have trigger conditions know how to draw themselves");
  todo("have a button (created by a a static method) to add one of X different AI ACTIONS");
  todo("have AI ACTION know how to draw themselves");

}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}




