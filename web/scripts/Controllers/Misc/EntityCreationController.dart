import '../../GameEntities/GameEntityForm.dart';
import '../../navbar.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";
import "CurrentUpdateProgress.dart";


Element div;
UListElement todoElement;
DivElement faqElement;
GameEntity entity; //dont set here or there won't be any stats dunkass....or not. fuck.
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
   entity = new GameEntity("Sample Entity",Session.defaultSession);
  div = querySelector("#story");
  setUpForm();

}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  GameEntityForm form = new GameEntityForm(entity, formElement);
  form.drawForm();
}



