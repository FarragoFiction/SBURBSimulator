import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
SessionFinderControllerJunior self; //want to access myself as more than just a sim controller occasionally

main() {
  doNotRender = true;
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  new SessionFinderControllerJunior();
  self = SimController.instance;

  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  self.formInit();
}

void checkSessionsJunior() {
  self.checkSessions();
}


class SessionFinderControllerJunior extends SimController {

  List<int> sessionsSimulated = [];
  Random rand;

  List<SessionSummaryJunior> allSessionsSummaries = [];
  //how filtering works
  List<SessionSummaryJunior> sessionSummariesDisplayed = [];

  int numSimulationsDone = 0;

  num numSimulationsToDo = 0;
  SessionFinderControllerJunior() : super() {
      rand = new Random();
  }

//kid boy and abj is canon
//you'll know that ABJ is thinking of kid boi every time she says "Interesting!!!"
//it will be secret code
//and definitely not terrifying at all
    void filterSessionsJunior(){
    //print("going to filter");
      int num_players =int.parse((querySelector("#num_players")as InputElement).value);
      List<dynamic> tmp = [];
      sessionSummariesDisplayed = [];
      for(int i = 0; i<allSessionsSummaries.length; i++){
        sessionSummariesDisplayed.add(allSessionsSummaries[i]);
      }

      for(int i = 0; i<sessionSummariesDisplayed.length; i++){
        var ss = sessionSummariesDisplayed[i];
        if(ss.players.length == num_players){
          tmp.add(ss);
        }
      }
      sessionSummariesDisplayed = tmp;
      printSummariesJunior();
      printStatsJunior();
    }


  void formInit(){
    querySelector("#button").onClick.listen((e) => checkSessionsJunior());
    (querySelector("#button")as ButtonElement).disabled =false;
    (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;

    querySelector("#num_sessions").onChange.listen((Event e) {
      (querySelector("#num_sessions_text")as InputElement).value =(querySelector("#num_sessions")as InputElement).value;
    });
  }

  void checkSessions() {
    numSimulationsDone = 0; //but don't reset stats
    sessionSummariesDisplayed = [];
    for(num i = 0; i<allSessionsSummaries.length; i++){
      sessionSummariesDisplayed.add(allSessionsSummaries[i]);
    }
    setHtml(SimController.instance.storyElement, "");
    numSimulationsToDo = int.parse((querySelector("#num_sessions")as InputElement).value);
    (querySelector("#button")as ButtonElement).disabled =true;
    startSession(); //im junior so deal with it
  }

  @override
  void callNextIntro([num time]) {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void checkSGRUB() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void createInitialSprites() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void easterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar);  //need to redo it here because all other versions are in case customizations
    //aaaaand. done.
    sessionsSimulated.add(curSessionGlobalVar.session_id);
    SessionSummary sum = curSessionGlobalVar.generateSummary();
    SessionSummaryJunior sumJR = sum.getSessionSummaryJunior();
    allSessionsSummaries.add(sumJR);
    sessionSummariesDisplayed.add(sumJR);
    var str = sumJR.generateHTML();
    debug("<br><hr><font color = 'orange'> ABJ: " + getQuipAboutSession() + "</font><Br>" );
    debug(str);
    printStatsJunior();
    numSimulationsDone ++;
    if(numSimulationsDone >= numSimulationsToDo){
      (querySelector("#button")as ButtonElement).disabled =false;
    }else{
      initial_seed = getRandomSeed();
      startSession();
    }
  }

  void printStatsJunior(){
    var mms = MultiSessionSummaryJunior.collateMultipleSessionSummariesJunior(sessionSummariesDisplayed);
    setHtml(querySelector("#stats"), mms.generateHTML());
    querySelector("#num_players").onChange.listen((Event e) {
      (querySelector("#num_players_text") as InputElement).value = (querySelector("#num_players")as InputElement).value;
    });
    //used to be an inline from generateHTML but no more.
    querySelector("#buttonFilter").onClick.listen((e) => filterSessionsJunior());

  }

  void printSummariesJunior(){
    setHtml(querySelector("#debug"), "");
    for(num i = 0; i<sessionSummariesDisplayed.length; i++){
      var ssd = sessionSummariesDisplayed[i];
      var str = ssd.generateHTML();
      debug("<br><hr><font color = 'orange'> AB: " + getQuipAboutSession() + "</font><Br>" );
      debug(str);
    }
  }


//oh Dirk/Lil Hal/Lil Hal Junior, why are you so amazing?
  dynamic getQuipAboutSession(){
    var quips = ["Hmmm","Yes.","Interesting!!!"];
    return rand.pickFrom(quips);
  }


  @override
  void easterEggCallBackRestart() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void intro() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void processCombinedSession() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void reckoning() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void reckoningTick([num time]) {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void recoverFromCorruption() {
    throw "ABJ does not actually simulate shit.";
  }


  @override
  void renderScratchButton(Session session) {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void restartSession() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void shareableURL() {
    throw "ABJ does not actually simulate shit.";
  }

  @override
  void tick([num time]) {
    throw "ABJ does not actually simulate shit.";
  }
}