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
Random rand;
SessionFinderController self; //want to access myself as more than just a sim controller occasionally
void main() {
  print("remember to check to see if AB is reporting ALL hashes, or only most of them, like, romance is just straight up empty.");
  doNotRender = true;
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  new SessionFinderController();
  self = SimController.instance;
  self.percentBullshit();

  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  self.formInit();
}

void checkSessions() {
  self.checkSessions();
}

void toggleCorpse(){
  self.toggleCorpse();
}



void toggleRomance(){
  self.toggleRomance();
}



void toggleDrama(){
  self.toggleDrama();
}



void toggleMisc(){
  self.toggleMisc();
}



void toggleEnding(){
  self.toggleEnding();
}



void toggleAverage(){
  self.toggleAverage();
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

  void toggleCorpse() {
    toggle(querySelector('#multiSessionSummaryCorpseParty'));
    displayCorpse = !displayCorpse;
    if(displayCorpse){
      (querySelector("#avatar") as ImageElement).src = "images/corpse_party_robot_author.png";
    }else{
      (querySelector("#avatar") as ImageElement).src ="images/robot_author.png";
    }
  }

  void toggleAverage() {
    toggle(querySelector('#multiSessionSummaryAverage'));
    displayAverages = !displayAverages;
  }

  void toggleEnding() {
    toggle(querySelector('#multiSessionSummaryEnding'));
    displayEnding = !displayEnding;
  }

  void toggleMisc() {
    toggle(querySelector('#multiSessionSummaryMisc'));
    displayMisc = !displayMisc;
  }

  void toggleDrama() {
    toggle(querySelector('#multiSessionSummaryDrama'));
    displayDrama = !displayDrama;
  }

  void toggleRomance() {
    toggle(querySelector('#multiSessionSummaryRomance'));
    displayRomance = !displayRomance;
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
  void checkSGRUB() {
    throw "ab does not do this";
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
    initializePlayers(curSessionGlobalVar.players,curSessionGlobalVar); //need to redo it here because all other versions are in case customizations
    intro();
  }


  @override
  void processCombinedSession() {
    var newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
    if(newcurSessionGlobalVar){
      print("doing a combo session");
      curSessionGlobalVar = newcurSessionGlobalVar;
      appendHtml(querySelector("#story"),"<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id.toString() + ". ");
      intro();
    }else{
      print("can't combo, can't scratch. just do next session.");
      needToScratch = false; //can't scratch if skaiai is a frog
      curSessionGlobalVar.makeCombinedSession = false;
      summarizeSession(curSessionGlobalVar);
    }
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

  @override
    void reckoningTick() {

    //print("Reckoning Tick: " + curSessionGlobalVar.timeTillReckoning);
    if(curSessionGlobalVar.timeTillReckoning > -10){
      //TODO readd timeout, maybe (i think i was calling it with time of 0 b4
      curSessionGlobalVar.timeTillReckoning += -1;
      curSessionGlobalVar.processReckoning(curSessionGlobalVar.players);
      reckoningTick();
    }else{
      Scene s = new Aftermath(curSessionGlobalVar);
      s.trigger(curSessionGlobalVar.players);
      s.renderContent(curSessionGlobalVar.newScene());
      if(curSessionGlobalVar.makeCombinedSession == true){
        processCombinedSession();  //make sure everything is done rendering first
      }else{
        if(needToScratch){
          scratchAB(curSessionGlobalVar);
          return null;
        }
        List<Player> living = findLivingPlayers(curSessionGlobalVar.players);
        if(curSessionGlobalVar.won || living.length == 0 || curSessionGlobalVar.scratched){
          //print("victory or utter defeat");
          summarizeSession(curSessionGlobalVar);
        }
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

  //stripped out tournament stuff, that'll be a different controller.
  void summarizeSession(Session session) {
    //print("summarizing: " + curSessionGlobalVar.session_id + " please ignore: " +curSessionGlobalVar.pleaseIgnoreThisSessionAB);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if(sessionsSimulated.indexOf(session.session_id) != -1){
      print("should be skipping a repeat session: " + curSessionGlobalVar.session_id.toString());
      return;
    }
    sessionsSimulated.add(curSessionGlobalVar.session_id);

    SessionSummary sum = curSessionGlobalVar.generateSummary();
    querySelector("#story").setInnerHtml("");
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats(null,null,null); //no filters here
    numSimulationsDone ++;
    initial_seed = curSessionGlobalVar.rand.nextInt(); //child session
    print("num sim done is $numSimulationsDone vs todo of $numSimulationsToDo");
    if(numSimulationsDone >= numSimulationsToDo){
      (querySelector("#button")as ButtonElement).disabled =false;
      print("I think I am done now");
      window.alert("Notice: should be ready to check more sessions.");
      List<Element> filters = querySelectorAll("input[name='filter']");
      for(CheckboxInputElement e in filters) {
          e.disabled = false;
      }
    }else{
      //TODO used to have a timeout here, do i really need to?
        print("going to start new session");
        startSession();
    }

  }

  String getQuipAboutSession(SessionSummary sessionSummary) {
    String quip = "";
    num living = sessionSummary.getNumStat("numLiving");
    num dead = sessionSummary.getNumStat("numDead");
    Player strongest = sessionSummary.mvp;

    if(sessionSummary.session_id == 33 || getParameterByName("nepeta","")  == ":33"){
      quip += "Don't expect any of my reports on those cat trolls to be accurate. They are random as fuck. " ;
    }

    if(sessionSummary.getBoolStat("crashedFromSessionBug")){
      quip += Zalgo.generate("Fuck. Shit crashed hardcore. It's a good thing I'm a flawless robot, or I'd have nightmares from that. Just. Fuck session crashes.  Also, shout out to star.eyes: 'His palms are sweaty, knees weak, arms are heavy. There's vomit on his sweater already, mom's spaghetti'");
    }else if(sessionSummary.getBoolStat("crashedFromPlayerActions")){
      quip += Zalgo.generate("Fuck. God damn. Do Grim Dark players even KNOW how much it sucks to crash? Assholes.");
    }else if(sessionSummary.frogStatus == "Purple Frog" && sessionSummary.getBoolStat("blackKingDead")){
      quip += "Oh my fucking god is THAT what the Grim Dark players have been trying to do. Are organics really so dumb as to not realize how very little that benefits them?";
    }else if(!sessionSummary.scratched && dead == 0 && sessionSummary.frogStatus == "Full Frog" && sessionSummary.getBoolStat("ectoBiologyStarted") && !sessionSummary.getBoolStat("crashedFromCorruption") && !sessionSummary.getBoolStat("crashedFromPlayerActions")){
      quip += "Everything went better than expected." ; //???
    }else if(sessionSummary.getBoolStat("yellowYard") == true){
      quip += "Fuck. I better go grab JR. They'll want to see this. " ;
    }else if(living == 0){
      quip += "Shit, you do not even want to KNOW how everybody died." ;
    }else  if(strongest.getStat("power") > 3000){
      //alert([!sessionSummary.scratched,dead == 0,sessionSummary.frogStatus == "Full Frog",sessionSummary.ectoBiologyStarted,!sessionSummary.crashedFromCorruption,!sessionSummary.crashedFromPlayerActions ].join(","))
      quip += "Holy Shit, do you SEE the " + strongest.titleBasic() + "!?  How even strong ARE they?" ;
    }else if(sessionSummary.frogStatus == "No Frog" ){
      quip += "Man, why is it always the frogs? " ;
      if(sessionSummary.parentSession != null){
        quip += " You'd think what with it being a combo session, they would have gotten the frog figured out. ";
      }
    }else  if(sessionSummary.parentSession != null){
      quip += "Combo sessions are always so cool. " ;
    }else  if(sessionSummary.getBoolStat("jackRampage")){
      quip += "Jack REALLY gave them trouble." ;
    }else  if(sessionSummary.getNumStat("num_scenes") > 200){
      quip += "God, this session just would not END." ;
      if(sessionSummary.parentSession == null){
        quip += " It didn't even have the excuse of being a combo session. ";
      }
    }else  if(sessionSummary.getBoolStat("murderMode")){
      quip += "It always sucks when the players start trying to kill each other." ;
    }else  if(sessionSummary.getNumStat("num_scenes") < 50){
      quip += "Holy shit, were they even in the session an entire hour?" ;
    }else  if(sessionSummary.getBoolStat("scratchAvailable") == true){
      quip += "Maybe the scratch would fix things? Now that JR has upgraded me, I guess I'll go find out." ;
    }else{
      quip += "It was slightly less boring than calculating pi." ;
    }

    if(sessionSummary.getBoolStat("threeTimesSessionCombo")){
      quip+= " Holy shit, 3x SessionCombo!!!";
    }else if(sessionSummary.getBoolStat("fourTimesSessionCombo")){
      quip+= " Holy shit, 4x SessionCombo!!!!";
    }else if(sessionSummary.getBoolStat("fiveTimesSessionCombo")){
      quip+= " Holy shit, 5x SessionCombo!!!!!";
    }else if(sessionSummary.getBoolStat("holyShitMmmmmonsterCombo")){
      quip+= " Holy fuck, what is even HAPPENING here!?";
    }
    return quip;
  }

  void printStats(List<String> filters, List<String> classes, List<String> aspects) {
    var mms = MultiSessionSummary.collateMultipleSessionSummaries(sessionSummariesDisplayed);
    querySelector("#stats").setInnerHtml(mms.generateHTML());
    mms.wireUpCorpsePartyCheckBoxes();

    if(displayMisc) show(querySelector('#multiSessionSummaryMisc'));  //memory. don't always turn off when making new ones.
    if(!displayMisc) hide(querySelector('#multiSessionSummaryMisc'));

    if(displayRomance) show(querySelector('#multiSessionSummaryRomance'));  //memory. don't always turn off when making new ones.
    if(!displayRomance)hide(querySelector('#multiSessionSummaryRomance'));

    if(displayDrama) show(querySelector('#multiSessionSummaryDrama'));  //memory. don't always turn off when making new ones.
    if(!displayDrama)hide(querySelector('#multiSessionSummaryDrama'));

    if(displayEnding) show(querySelector('#multiSessionSummaryEnding'));  //memory. don't always turn off when making new ones.
    if(!displayEnding)hide(querySelector('#multiSessionSummaryEnding'));

    if(displayAverages)show(querySelector('#multiSessionSummaryAverage'));  //memory. don't always turn off when making new ones.
    if(!displayAverages)hide(querySelector('#multiSessionSummaryAverage'));

    if(displayCorpse) show(querySelector('#multiSessionSummaryCorpseParty')); //memory. don't always turn off when making new ones.
    if(!displayCorpse)hide(querySelector('#multiSessionSummaryCorpseParty'));

    if(filters != null){
      List<Element> allFilters = querySelectorAll("input[name='filter']");
      for(CheckboxInputElement e in allFilters) {
        e.disabled = false;
        if(filters.indexOf(e.value) != -1){
          e.checked = true;
        }else{
          e.checked = false;
        }
      }
    }

    if(classes != null && aspects != null){
      List<Element> filterClass = querySelectorAll("input[name='filterClass']");
      for(CheckboxInputElement e in filterClass) {
        e.disabled = false;
        if(classes.indexOf(e.value) != -1){
          e.checked = true;
        }else{
          e.checked = false;
        }

      }

      List<Element> filterAspect = querySelectorAll("input[name='filterAspect']");
      for(CheckboxInputElement e in filterAspect) {
        e.disabled = false;
        if(aspects.indexOf(e.value) != -1){
          e.checked = true;
        }else{
          e.checked = false;
        }

      }

    }

  }

  void summarizeSessionNoFollowup(Session session) {
    //print("no timeout summarizing: " + curSessionGlobalVar.session_id);
    //don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
    if(sessionsSimulated.indexOf(session.session_id) != -1){
      ////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);
      return;
    }
    sessionsSimulated.add(curSessionGlobalVar.session_id);
    querySelector("#story").setInnerHtml("");
    var sum = curSessionGlobalVar.generateSummary();
    allSessionsSummaries.add(sum);
    sessionSummariesDisplayed.add(sum);
    //printSummaries();  //this slows things down too much. don't erase and reprint every time.
    var str = sum.generateHTML();
    debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
    debug(str);
    printStats(null, null, null); //not filtering anything

  }



  @override
  void recoverFromCorruption() {
    print("AB thinks she should check a new session after finding a shitty crashed session");
    summarizeSession(curSessionGlobalVar); //well...THAT session ended
  }


  @override
  void renderScratchButton(Session session) {
    needToScratch = true;
  }

  @override
  void restartSession() {
    querySelector("#story").setInnerHtml('');
    window.scrollTo(0, 0);
    checkEasterEgg(easterEggCallBackRestart,null);
  }

  @override
  void shareableURL() {
    throw "AB doesn't do this";
  }


}