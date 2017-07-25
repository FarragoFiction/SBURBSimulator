import '../SBURBSim.dart';
import 'dart:html';

//replaces the poorly named scenario_controller2.js

main() {
  //TODO scroll the window up
  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((ErrorEvent e){
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
  });
  loadNavbar();
  num initial_seed = 0;
  new StoryController(); //will set this as SimController's instance variable.
  if(getParameterByName("seed",null) != null){
   // Math.seed = getParameterByName("seed");  //TODO replace this somehow
    initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
   // Math.seed = tmp; //TOdo do something else here
    initial_seed = tmp;
  }

  SimController.instance.shareableURL();

  SimController.instance.startSession();
}

class StoryController extends SimController {
  StoryController() : super();
}