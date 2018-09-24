import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";
import "CurrentUpdateProgress.dart";


Element div;
SerializableScene scene = new SerializableScene(Session.defaultSession);
UListElement todoElement;
DivElement faqElement;
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  scene.session.setupMoons("BigBad setup");

  div = querySelector("#story");
  todoElement = new UListElement();
  todoElement.style.border = "1px solid black";
  div.append(todoElement);

  setUpForm();
  FAQHandler faqHandler = new FAQHandler(FAQHandler.SCENEFAQ, div);
  TodoHandler todoHandler = new TodoHandler(TodoHandler.BIGBADTODO, div);
}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  scene.renderForm(formElement);
}



