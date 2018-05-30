import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";


Element div;
SerializableScene scene = new SerializableScene(new Session(-13));
UListElement todoElement;
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  scene.session.setupMoons("BigBad setup");

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px";
  div.append(todoElement);
  todo("button to add scene owner's name in, too");
  todo("ability to remove triggers/actions");
  todo("loaded scenes not fucking up if there were already triggers/actions");

  setUpForm();
}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  scene.renderForm(formElement);
}


void todo(String todo) {
  LIElement tmp = new LIElement();
  tmp.setInnerHtml("TODO: $todo");
  todoElement.append(tmp);
}

