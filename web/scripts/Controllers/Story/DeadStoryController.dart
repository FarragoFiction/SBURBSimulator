import '../../SBURBSim.dart';
import "../Misc/DeadSimController.dart";
import '../../navbar.dart';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
void main() {
  //maybe if i define it here it won't be the same as end time
  startTime =new DateTime.now();
  //print("If you are in dartium, make sure to select this file to access it's global vars");
  new DateTime.now();
  new Timer(new Duration(milliseconds: 1000), () =>window.scrollTo(0, 0));

  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((Event event){
  	ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  loadNavbar();
  //be dead looking
  querySelector("#story").style.backgroundColor = "grey";
  //querySelector("#links").style.backgroundColor = "grey";
  querySelector("#debug").style.backgroundColor = "grey";
  querySelector("#charSheets").style.backgroundColor = "grey";

  new DeadStoryController(); //will set this as SimController's instance variable.
  if(getParameterByName("seed",null) != null){
   // Math.seed = getParameterByName("seed");  //TODO replace this somehow
    SimController.instance.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
   // Math.seed = tmp; //TOdo do something else here but rand is inside of session......
    SimController.instance.initial_seed = tmp;
  }

  SimController.instance.shareableURL();

  SimController.instance.startSession();
}

//so dead session finder can use this without a main.
class DeadStoryController extends DeadSimController {
  DeadStoryController() : super();
}

class StoryController extends SimController {
    StoryController() : super();
}