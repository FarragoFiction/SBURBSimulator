import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
Future<Null> main() async {
  await globalInit();
  sowChaos();

  //maybe if i define it here it won't be the same as end time
  startTime =new DateTime.now();
  //;
  new DateTime.now();
  new Timer(new Duration(milliseconds: 1000), () =>window.scrollTo(0, 0));

  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((Event event){
  	ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(SimController.instance.currentSessionForErrors,e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  loadNavbar();
  new StoryController(); //will set this as SimController's instance variable.
  if(getParameterByName("seed",null) != null){
   // Math.seed = getParameterByName("seed");  //TODO replace this somehow
    SimController.instance.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
   // Math.seed = tmp; //TOdo do something else here but rand is inside of session......
    SimController.instance.initial_seed = tmp;
  }

  SimController.instance.shareableURL();
  startSession();

}

Future<Null> startSession() async {
  Session session = new Session(SimController.instance.initial_seed);
  checkEasterEgg(session);
  await session.startSession();
  print("I think the session stopped!");
}

//sauce jr, what are you doing. stahp.
void sowChaos() {
  DateTime now = new DateTime.now();
  if(now.month == 4 && now.day == 1) {
    window.alert("You know. I think I can do better than this.  Why not just....meteor shit. Start from scratch??? Get a sweet graphical update.");
    window.location.href = "http://www.farragofiction.com/LifeSim/";
  }
}

class StoryController extends SimController {
  StoryController() : super();
}