import '../SBURBSim.dart';
import 'dart:html';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';
import "StoryController.dart";

//replaces the poorly named scenario_controller2.js
num initial_seed = 0;
Random rand;
SessionFinderController self; //want to access myself as more than just a sim controller occasionally
main() {
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
  rand = new Random(initial_seed);
  self.formInit();
}



class SessionFinderController extends StoryController { //works exactly like Sim unless otherwise specified.
  SessionFinderController() : super();

  void percentBullshit(){
    var pr = 90+rand.nextDouble()*10; //this is not consuming randomness. what to do?
    querySelector("#percentBullshit").setInnerHtml("$pr%");
  }

  void formInit(){
    (querySelector("#button")as ButtonInputElement).disabled =false;
    (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;

    querySelector("#num_sessions").onChange.listen(onData)
    querySelector("#num_sessions").change((){
      querySelector("#num_sessions_text").val(querySelector("#num_sessions").val());
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