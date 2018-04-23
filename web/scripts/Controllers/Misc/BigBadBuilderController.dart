import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";


Element div;
UListElement todoElement;
BigBad bigBad = new BigBad("Sample Big Bad", new Session(-13));
void main() {
  loadNavbar();
  globalInit();
  bigBad.session.setupMoons();
  SummonScene defaultSummon = new SummonScene(bigBad.session);
  defaultSummon.gameEntity = bigBad;
  bigBad.startMechanisms.add(defaultSummon);
  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);


  todo("scenes know how to put their trigger conditions into the big bads data string");
  todo("scenes know how to load their trigger conditions");
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




