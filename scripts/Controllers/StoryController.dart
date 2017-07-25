import '../SBURBSim.dart';
import 'dart:html';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

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
    throw "TODO";
    // TODO: implement checkSGRUB
  }

  @override
  void easterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.
    checkSGRUB();
    load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players),""); //in loading.js
  }

  @override
  void easterEggCallBackRestart() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //initializePlayers
    intro();  //<-- instead of load, bc don't need to load.

  }

  @override
  void getSessionType() {
    throw "TODO";
    // TODO: implement getSessionType
  }

  @override
  void intro() {
    throw "TODO";
    // TODO: implement intro
  }

  @override
  void processCombinedSession() {
    throw "TODO";
    // TODO: implement processCombinedSession
  }

  @override
  void reckoning() {
    throw "TODO";
    // TODO: implement reckoning
  }

  @override
  void recoverFromCorruption() {
    throw "TODO";
    // TODO: implement recoverFromCorruption
  }

  @override
  void reinit() {
    available_classes = new List<String>.from(classes);
    available_aspects = new List<String>.from(nonrequired_aspects);
    available_aspects.addAll(required_aspects);
    curSessionGlobalVar.reinit();
  }

  @override
  void renderAfterlifeURL() {
    throw "TODO";
    // TODO: implement renderAfterlifeURL
  }

  @override
  void renderScratchButton(Session session) {
    throw "TODO";
    // TODO: implement renderScratchButton
  }

  @override
  void restartSession() {
    throw "TODO";
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
    curSessionGlobalVar = new Session(initial_seed);
    reinit();
    Scene.createScenesForSession(curSessionGlobalVar);
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();
    //authorMessage();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    //easter egg ^_^
    if(getParameterByName("royalRumble",null)  == "true"){
      debugRoyalRumble();
    }

    if(getParameterByName("COOLK1D",null)  == "true"){
      cool_kid = true;
      coolK1DMode();
    }

    if(getParameterByName("pen15",null)  == "ouija"){
      pen15Ouija();
    }

    if(getParameterByName("faces",null)  == "off"){
      faceOffMode();
    }

    if(getParameterByName("tier",null)  == "cod"){
      bardQuestMode();
    }

    if(getParameterByName("lollipop",null)  == "true"){
      tricksterMode();
    }

    if(getParameterByName("robot",null)  == "true"){
      roboMode();
    }

    if(getParameterByName("sbajifier",null)  == "true"){
      sbahjMode();
    }

    if(getParameterByName("babyStuck",null)  == "true"){
      babyStuckMode();
    }

    checkEasterEgg(easterEggCallBack,null);
  }

  @override
  void tick() {
    throw "TODO";
    // TODO: implement tick
  }
}