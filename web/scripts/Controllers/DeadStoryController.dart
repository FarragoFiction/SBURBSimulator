import '../SBURBSim.dart';
import '../navbar.dart';
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


//TODO: figure out how to have this make a DeadSession instead of a regular one.
class DeadStoryController extends SimController {
  DeadStoryController() : super();

  @override
  void startSession() {
    globalInit(); // initialise classes and aspects if necessary

    // //print("Debugging AB: Starting session $initial_seed");
    curSessionGlobalVar = new DeadSession(initial_seed);
    changeCanonState(getParameterByName("canonState",null));
    //  //print("made session with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    reinit();
    ////print("did reinit with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    Scene.createScenesForSession(curSessionGlobalVar);
    ////print("created scenes with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    curSessionGlobalVar.makePlayers();
    ////print("made players with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    curSessionGlobalVar.randomizeEntryOrder();
    //authorMessage();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    //easter egg ^_^
    if (getParameterByName("royalRumble", null) == "true") {
      debugRoyalRumble();
    }

    if (getParameterByName("COOLK1D", null) == "true") {
      cool_kid = true;
      coolK1DMode();
    }

    if (getParameterByName("pen15", null) == "ouija") {
      pen15Ouija();
    }



    if (getParameterByName("faces", null) == "off") {
      faceOffMode();
    }

    if (getParameterByName("tier", null) == "cod") {
      bardQuestMode();
    }

    if (getParameterByName("lollipop", null) == "true") {
      tricksterMode();
    }

    if (getParameterByName("robot", null) == "true") {
      roboMode();
    }

    if (getParameterByName("sbajifier", null) == "true") {
      sbahjMode();
    }

    if (getParameterByName("babyStuck", null) == "true") {
      babyStuckMode();
    }

    checkEasterEgg(easterEggCallBack, null);
  }

}