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
  self.checkSessions();
}



class SessionFinderController extends SimController { //works exactly like Sim unless otherwise specified.
  List<int> sessionsSimulated = [];

  List<SessionSummaryJunior> allSessionsSummaries = [];
  //how filtering works
  List<SessionSummaryJunior> sessionSummariesDisplayed = [];

  int numSimulationsDone = 0;

  num numSimulationsToDo = 0;
  SessionFinderController() : super();

  void checkSessions() {
    numSimulationsDone = 0; //but don't reset stats
    sessionSummariesDisplayed = [];
    for(num i = 0; i<allSessionsSummaries.length; i++){
      sessionSummariesDisplayed.add(allSessionsSummaries[i]);
    }
    querySelector("#story").setInnerHtml("");
    numSimulationsToDo = int.parse((querySelector("#num_sessions")as InputElement).value);
    (querySelector("#button")as ButtonElement).disabled =true;
    startSession(); //my callback is what will be different
  }

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
    //only diff from story is don't check SGRUB
    initializePlayers(curSessionGlobalVar.players,curSessionGlobalVar); //need to redo it here because all other versions are in case customizations
    if(doNotRender == true){
      intro();
    }else{
      load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players),""); //in loading.js
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
    throw "todo";
    // TODO: implement startSession
  }

  @override
  void tick() {
    throw "todo";
    // TODO: implement tick
  }
}