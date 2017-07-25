import '../SBURBSim.dart';
import 'dart:html';

//replaces the poorly named scenario_controller2.js

main() {
  //scroll the window up
  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((ErrorEvent e){
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
  });
}

class StoryController extends SimController {
  StoryController() : super();
}