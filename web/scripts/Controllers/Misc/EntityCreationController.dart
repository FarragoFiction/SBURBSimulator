import '../../GameEntities/GameEntityForm.dart';
import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";
import "CurrentUpdateProgress.dart";


Element div;
UListElement todoElement;
DivElement faqElement;
GameEntity entity = new GameEntity("Sample Entity",Session.defaultSession);
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
  GameEntityForm form = new GameEntityForm(entity, formElement);
  form.drawForm();
}



