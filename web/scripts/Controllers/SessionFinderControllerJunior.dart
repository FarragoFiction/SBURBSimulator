import '../SBURBSim.dart';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
num initial_seed = 0;
SessionFinderControllerJunior self; //want to access myself as more than just a sim controller occasionally

main() {
  doNotRender = true;
  loadNavbar();
  new SessionFinderControllerJunior();
  self = SimController.instance;

  if(getParameterByName("seed",null) != null){
    initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    initial_seed = tmp;
  }
  self.formInit();
}

void checkSessionsJunior() {
  window.alert("TODO");
}


class SessionFinderControllerJunior extends SimController {
  Random rand = new Random(initial_seed);
  List<int> sessionsSimulated = [];
  SessionFinderControllerJunior() : super();

  void formInit(){
    querySelector("#button").onClick.listen((e) => checkSessionsJunior());
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
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar);  //need to redo it here because all other versions are in case customizations
    //aaaaand. done.
    sessionsSimulated.add(curSessionGlobalVar.session_id);
    var sum = curSessionGlobalVar.generateSummary();
    var sumJR = sum.getSessionSummaryJunior();
    allSessionsSummaries.add(sumJR);
    sessionSummariesDisplayed.add(sumJR);
    var str = sumJR.generateHTML();
    debug("<br><hr><font color = 'orange'> ABJ: " + getQuipAboutSessionJunior() + "</font><Br>" );
    debug(str);
    printStatsJunior();
    numSimulationsDone ++;
    if(numSimulationsDone >= numSimulationsToDo){
      querySelector("#button").prop('disabled', false);
    }else{
      Math.seed =  getRandomSeed();
      initial_seed = Math.seed;
      startSession();
    }
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
    super.startSession(); //the only difference is the callback.
  }

  @override
  void tick() {
    throw "todo";
    // TODO: implement tick
  }
}