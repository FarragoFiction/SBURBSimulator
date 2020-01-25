import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:async';
import 'dart:html';
//import 'dart:typed_data';
//import 'dart:collection';

//import "../../GameEntities/GameEntity.dart";

import "StoryController.dart";

/*void main() {
    print("test?");
}*/

//replaces the poorly named scenario_controller2.js
Future<void> main() async {
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
    if(getParameterByName("seed",null) == "owowhatsthis") {
      String message = "ERROR: UNAUTHORIZED ROOT ACCESS DETECTED.  ASPECT OF VIOLATION DETECTED:  LIFE. REPORT <a href = 'http://www.farragofiction.com/PaldemicSim/login?username=owowhatsthis'>SUBMITTED</a> TO LOCAL DOOM PLAYER.";
      SimController.instance.storyElement.setInnerHtml("$message <br><Br>");
      AnchorElement a = new AnchorElement(href: "http://www.farragofiction.com/PaldemicSim/login?username=owowhatsthis")..text = "View Report?";
      SimController.instance.storyElement.append(a);
      throw(message);
    }else if(getParameterByName("seed",null) == "3") {
      String message = "<img src = 'images/mysteriousrogue.png'<br><br></br>The <font color = '#ffcc66'>Rogue of Hope</font> enters the game first. They manage to prototype their kernel sprite with a Sheep pre-entry. They have many INTERESTS, including:<br><br> ERROR: JR here, why don't you leave the poor rogue alone? AB was telling me about ethics last night and it really stuck this time. Its sort of like the bro code, right? Let the man have some privacy.";
      SimController.instance.storyElement.setInnerHtml("$message <br><Br>");
      throw(message);
    }
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

Future<void> startSession() async {
  Session session = new Session(SimController.instance.initial_seed);
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

//class StoryController extends SimController {
//  StoryController() : super();
//}