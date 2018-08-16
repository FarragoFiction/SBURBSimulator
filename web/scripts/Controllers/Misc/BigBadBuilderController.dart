import '../../navbar.dart';
import 'CurrentUpdateProgress.dart';
import 'dart:html';
import "../../SBURBSim.dart";
import "dart:async";


Element div;
BigBad bigBad = new BigBad("Sample Big Bad", Session.defaultSession);
void main() {
  loadNavbar();
  start();

}

Future<Null> start() async {
  await globalInit();
  bigBad.session.setupMoons("BigBad setup");
  div = querySelector("#story");



  /**
   *  * Add flavor text to SummonScenes
   * Add effects to SerializableScenes
   * Text doc of a few Big Bads
   * BUG FIXES
   * Branch Main and Experimental
   * Big Bad Activation Loop
   * Test for crashes
   * Teach ShogunBot how to make cards for non Carapace Big Bads
   * Find sessions where the current Big Bads are being summoned
   */



  setUpForm();
  FAQHandler faqHandler = new FAQHandler(FAQHandler.BIGBADFAQ, div);
  TodoHandler todoHandler = new TodoHandler(TodoHandler.BIGBADTODO, div);
}

void setUpForm() {
  DivElement formElement = new DivElement();
  div.append(formElement);
  bigBad.drawForm(formElement);
}

