import '../SBURBSim.dart';
import 'dart:html';

//replaces the poorly named scenario_controller2.js
num initial_seed = 0;
main() {
  //TODO scroll the window up
  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((ErrorEvent e){
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
  });
  loadNavbar();
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
  @override
  void callNextIntroWithDelay() {
    // TODO: implement callNextIntroWithDelay
  }

  @override
  void checkSGRUB() {
    // TODO: implement checkSGRUB
  }

  @override
  void easterEggCallBack() {
    // TODO: implement easterEggCallBack
  }

  @override
  void easterEggCallBackRestart() {
    // TODO: implement easterEggCallBackRestart
  }

  @override
  void getSessionType() {
    // TODO: implement getSessionType
  }

  @override
  void intro() {
    // TODO: implement intro
  }

  @override
  void processCombinedSession() {
    // TODO: implement processCombinedSession
  }

  @override
  void reckoning() {
    // TODO: implement reckoning
  }

  @override
  void recoverFromCorruption() {
    // TODO: implement recoverFromCorruption
  }

  @override
  void reinit() {
    // TODO: implement reinit
  }

  @override
  void renderAfterlifeURL() {
    // TODO: implement renderAfterlifeURL
  }

  @override
  void renderScratchButton(Session session) {
    // TODO: implement renderScratchButton
  }

  @override
  void restartSession() {
    // TODO: implement restartSession
  }

  @override
  void shareableURL() {
    var params = window.location.href.substring(window.location.href.indexOf("?")+1);
    if (params == window.location.href) params = "";
    String str = '<div class = "links"><a href = "index2.html?seed=${initial_seed}&' + params + ' ">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed${initial_seed}&' + params + ' " target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href ;= "index2.html">Random Session URL </a> </div>';
    querySelector("#seedText").appendHtml(str); //TODO this used to be a 'replace' but can't figure out the Dart equivalent.
    querySelector("#story").appendHtml("Session: ${initial_seed}");
  }

  @override
  void startSession() {
    // TODO: implement startSession
  }

  @override
  void tick() {
    // TODO: implement tick
  }
}