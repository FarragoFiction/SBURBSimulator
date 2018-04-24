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

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);

  todo("trigger condition can be 'any' ");
  todo("big bads have intro mod flavor text (like dystopic empire)");
  todo("scenes should flavor text with replaceable words and shit. (how to do with such complex triggers?)");
  todo("split main and experimental, test spawning big bads. they won't DO anything yet, but thats okay");
  todo("big bads need 0 or more custom fraymotif names");
  todo("big bads need low, medium, high values for all stats. what am i saying i mean 'Planetary, Galactic, Cosmic'. sorry about that, shogun");
  todo("big bad needs to be in default state before loading still, need to refresh page to clear shit out");
  todo("big bads have outro mod flavor text (if they aren't defeated, how do they effect child universe, like dystopic empire)");
  todo("scenes shouldu have effects styled just like triggers");
  todo("way to test");
  todo("side apps, like big bad gotcha, or big bad betting battles");

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




