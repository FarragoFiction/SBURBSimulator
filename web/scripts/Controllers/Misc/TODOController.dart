import '../../navbar.dart';
import 'CurrentUpdateProgress.dart';
import 'dart:html';
//bare minimum for a page.
void main() {
  loadNavbar();
  Element div = querySelector("#story");
  for(String s in TodoHandler.allTODOs) {
    TodoHandler todoHandler = new TodoHandler(s, div);
  }

}
