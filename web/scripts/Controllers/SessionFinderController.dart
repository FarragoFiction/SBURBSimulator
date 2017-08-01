import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
num initial_seed = 0;
Random rand;
SessionFinderController self; //want to access myself as more than just a sim controller occasionally
void main() {
  window.alert("IMPORTANT: to get next session, session.rand.nextInt() to get what is the last unused seed from current session");
  doNotRender = true;
  loadNavbar();
  new SessionFinderController();
  self = SimController.instance;
  self.percentBullshit();

  if(getParameterByName("seed",null) != null){
    initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    initial_seed = tmp;
  }
  self.formInit();
}

void checkSessions() {
  window.alert("TODO");
}



class SessionFinderController extends SimController { //works exactly like Sim unless otherwise specified.
  SessionFinderController() : super();

  void percentBullshit(){
    double pr = 90+(new Random().nextDouble())*10; //this is not consuming randomness. what to do?
    querySelector("#percentBullshit").setInnerHtml("$pr%");
  }

  void formInit(){
    querySelector("#button").onClick.listen((e) => checkSessions());
    (querySelector("#button")as ButtonElement).disabled =false;
    (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;

    querySelector("#num_sessions").onChange.listen((Event e) {
      (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;
    });
  }


  @override
  void callNextIntro(int player_index) {
    throw "todo";
    // TODO: implement callNextIntro
  }

  @override
  void checkSGRUB() {
    throw "todo";
    // TODO: implement checkSGRUB
  }

  @override
  void createInitialSprites() {
    throw "todo";
    // TODO: implement createInitialSprites
  }

  @override
  void easterEggCallBack() {
    throw "todo";
    // TODO: implement easterEggCallBack
  }

  @override
  void easterEggCallBackRestart() {
    throw "todo";
    // TODO: implement easterEggCallBackRestart
  }

  @override
  void intro() {
    throw "todo";
    // TODO: implement intro
  }

  @override
  void processCombinedSession() {
    throw "todo";
    // TODO: implement processCombinedSession
  }

  @override
  void reckoning() {
    throw "todo";
    // TODO: implement reckoning
  }

  @override
  void reckoningTick() {
    throw "todo";
    // TODO: implement reckoningTick
  }

  @override
  void recoverFromCorruption() {
    throw "todo";
    // TODO: implement recoverFromCorruption
  }

  @override
  void reinit() {
    throw "todo";
    // TODO: implement reinit
  }

  @override
  void renderScratchButton(Session session) {
    throw "todo";
    // TODO: implement renderScratchButton
  }

  @override
  void restartSession() {
    throw "todo";
    // TODO: implement restartSession
  }

  @override
  void shareableURL() {
    throw "todo";
    // TODO: implement shareableURL
  }

  @override
  void startSession() {
    throw "todo";
    // TODO: implement startSession
  }

  @override
  void tick() {
    throw "todo";
    // TODO: implement tick
  }
}