import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  bigBad.startMechanisms.add(new SummonScene(bigBad.session));
  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  
  todo("start scenes know how to render a add trigger condition button");
  todo("adding a trigger condition adds it to the owning scene");
  todo("big bads have intro mod flavor text (like dystopic empire)");
  todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)");
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




