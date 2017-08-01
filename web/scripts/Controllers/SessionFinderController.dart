import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
/*
  AB seems to treat sessions normally UNTIL they end. though I WILL override start session to avoid
  AB rewriting the page title.
 */
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

  List<SessionSummary> allSessionsSummaries = [];
  //how filtering works
  List<SessionSummary> sessionSummariesDisplayed = [];

  int numSimulationsDone = 0;
  int numSimulationsToDo = 0;
  bool needToScratch = false;
  bool displayRomance = true;
  bool displayEnding = true;
  bool displayDrama = true;
  bool displayCorpse = false;
  bool displayMisc = true;
  bool displayAverages = true;
  bool displayClasses = false;
  bool displayAspects = false;
  bool tournamentMode = false;
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

  //AB's reckoning is like the normal one, but if the session ends at the recknoing, ab knows what to do.
  @override
  void reckoning() {
    Scene s = new Reckoning(curSessionGlobalVar);
    s.trigger(curSessionGlobalVar.players);
    s.renderContent(curSessionGlobalVar.newScene());
    if(!curSessionGlobalVar.doomedTimeline){
      reckoningTick();
    }else{
      if(needToScratch){
        scratchAB(curSessionGlobalVar);
        return null;
      }
      ////print("doomed timeline prevents reckoning");
      List<Player> living = findLivingPlayers(curSessionGlobalVar.players);
      if(curSessionGlobalVar.scratched || living.length == 0){ //can't scrach so only way to keep going.
        //print("doomed scratched timeline");
        summarizeSession(curSessionGlobalVar);
      }

    }
  }

  void scratchAB(Session session) {
    needToScratch = false;
    //treat myself as a different session that scratched one?
    List<Player> living = findLivingPlayers(session.players);
    if(!session.scratched && living.length > 0 && !tournamentMode){
      //print("scartch");
      //alert("AB sure loves scratching!");
      session.scratchAvailable = true;
      summarizeSessionNoFollowup(session);
      scratch(); //not user input, just straight up do it.
    }else{
      //print("no scratch");
      session.scratchAvailable = false;
      summarizeSession(session);
    }

  }

  void summarizeSession(Session session) {
    //print("summarizing: " + curSessionGlobalVar.session_id + " please ignore: " +curSessionGlobalVar.pleaseIgnoreThisSessionAB);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if(sessionsSimulated.indexOf(session.session_id) != -1){
      ////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);
      //return;
    }
    sessionsSimulated.add(curSessionGlobalVar.session_id);

    SessionSummary sum = curSessionGlobalVar.generateSummary();
    if(nonRareSessionCallback) return nonRareSessionCallback(sum); //it will handle calling next session.
    querySelector("#story").html("");
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats();
    numSimulationsDone ++;
    initial_seed = curSessionGlobalVar.rand.nextInt(); //child session
    if(numSimulationsDone >= numSimulationsToDo){
      querySelector("#button").prop('disabled', false);

          window.alert("Notice: should be ready to check more sessions.");
        querySelector("input[name='filter']").each((){;
        querySelector(this).prop('disabled', false);
        });
    }else{
      //TODO used to have a timeout here, do i really need to?
        startSession();
    }

  }

  void printStats() {

  }

  void summarizeSessionNoFollowup(Session session) {
    //print("no timeout summarizing: " + curSessionGlobalVar.session_id);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if(sessionsSimulated.indexOf(session.session_id) != -1){
      ////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);

      //return;
    }
    sessionsSimulated.add(curSessionGlobalVar.session_id);
    querySelector("#story").html("");
    var sum = curSessionGlobalVar.generateSummary();
    if(nonRareSessionCallback) return null; //tournament doens't support scratches.
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats();

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


}