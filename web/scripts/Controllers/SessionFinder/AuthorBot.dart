/*

Needed so multiple screens can all know how to quickly find sessions.
Rare session finder, tournament,  etc.
 */
import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import "dart:async";

abstract class AuthorBot extends SimController {

  List<int> sessionsSimulated = [];

  List<SessionSummary> allSessionsSummaries = [];
  //how filtering works
  List<SessionSummary> sessionSummariesDisplayed = [];

  int numSimulationsDone = 0;
  int numSimulationsToDo = 0;
  bool needToScratch = false;

  AuthorBot() : super() {
    storyElement = new DivElement(); //will not actually rendering to screen speed AB up?
    //TODO yes, in that all sessions crash

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
    startSession(); //my callback is what will be different
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
    //;
    Session newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
    if(newcurSessionGlobalVar != null){
     // //;
      curSessionGlobalVar = newcurSessionGlobalVar;
      appendHtml(SimController.instance.storyElement,"<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id.toString() + ". ");
      intro();
    }else{
      ////;
      needToScratch = false; //can't scratch if skaiai is a frog
      curSessionGlobalVar.stats.makeCombinedSession = false;
      summarizeSession(curSessionGlobalVar);
    }
  }

  //AB's reckoning is like the normal one, but if the session ends at the recknoing, ab knows what to do.
  @override
  void reckoning() {
    Scene s = new Reckoning(curSessionGlobalVar);
    s.trigger(curSessionGlobalVar.players);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString()));
    if(!curSessionGlobalVar.stats.doomedTimeline){
      ////;
      reckoningTick();
      return null;
    }else{
      ////;
      if(needToScratch){
       // //;
        scratchAB(curSessionGlobalVar);
        return null;
      }
     // //;
      //////;
      List<Player> living = findLiving(curSessionGlobalVar.players);
      if(curSessionGlobalVar.stats.scratched || living.length == 0){ //can't scrach so only way to keep going.
        ////;
        summarizeSession(curSessionGlobalVar);
        return null;
      }

    }
    //;
  }

  @override
  void reckoningTick([num time]) {
   // //;
    ////print("Reckoning Tick: " + curSessionGlobalVar.timeTillReckoning);
    if(curSessionGlobalVar.timeTillReckoning > -10){
      curSessionGlobalVar.timeTillReckoning += -1;
      curSessionGlobalVar.processReckoning(curSessionGlobalVar.players);
      window.requestAnimationFrame(reckoningTick);
      //new Timer(new Duration(milliseconds: 10), () => reckoningTick()); //sweet sweet async
      return null;
    }else{
     // //;
      Scene s = new Aftermath(curSessionGlobalVar);
     // //;

      s.trigger(curSessionGlobalVar.players);
      ////;

      s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString()));
      ////;
      if(curSessionGlobalVar.stats.makeCombinedSession == true){
        ;
        processCombinedSession();  //make sure everything is done rendering first
        return null;
      }else{
       // //;
        if(needToScratch){
        //  //;
          scratchAB(curSessionGlobalVar);
          return null;
        }
        List<Player> living = findLiving(curSessionGlobalVar.players);
       // //;
        if(curSessionGlobalVar.stats.won || living.length == 0 || curSessionGlobalVar.stats.scratched){
          ////;
          summarizeSession(curSessionGlobalVar);
          return null;
        }else {
         // //;
          return null;
        }
      }
    }

    //;
  }


  void scratchAB(Session session) {
    needToScratch = false;
    //treat myself as a different session that scratched one?
    List<Player> living = findLiving(session.players);
    if(!session.stats.scratched && living.length > 0){
      ////;
      //alert("AB sure loves scratching!");
      session.stats.scratchAvailable = true;
      summarizeSessionNoFollowup(session);
      scratch(); //not user input, just straight up do it.
    }else{
      ////;
      session.stats.scratchAvailable = false;
      summarizeSession(session);
    }

  }


  String getQuipAboutSession(SessionSummary sessionSummary) {
    String quip = "";
    num living = sessionSummary.getNumStat("numLiving");
    num dead = sessionSummary.getNumStat("numDead");
    Player strongest = sessionSummary.mvp;

    if(sessionSummary.session_id == 33 || getParameterByName("nepeta",null)  == ":33"){
      quip += "Don't expect any of my reports on those cat trolls to be accurate. They are random as fuck. " ;
      if(window.localStorage.containsKey("catTroll")) {
        quip += "I've seen ${window.localStorage["catTroll"]} cat trolls and it's all your fault. ";
      }
    }
    print ("is it nepeta? ${getParameterByName("nepeta",null)}");

    if(sessionSummary.getBoolStat("crashedFromSessionBug")){
      quip += Zalgo.generate("Fuck. Shit crashed hardcore. It's a good thing I'm a flawless robot, or I'd have nightmares from that. Just. Fuck session crashes.  Also, shout out to star.eyes: 'His palms are sweaty, knees weak, arms are heavy. There's vomit on his sweater already, mom's spaghetti'");
    }else if(sessionSummary.getBoolStat("crashedFromPlayerActions")){
      quip += Zalgo.generate("Fuck. God damn. Do Grim Dark players even KNOW how much it sucks to crash? Assholes.");
    }else if(sessionSummary.getBoolStat("cataclysmCrash")){
      quip += Zalgo.generate("Holy shit. JR. You NEED to keep those Wastes under control. Why did you ever enable them?");
    }else if(sessionSummary.getBoolStat("hasTier4GnosisEvents")){
      quip += "Oh my fucking god, who let the Wastes have this much power?  I am NOT guaranteeing the accuracy of this report, even with my 'anti-waste-magicks' JR gave me. I'm also not storing this data and risking corrupting my fucking cache.";
    }else if(sessionSummary.frogStatus == "Purple Frog" && sessionSummary.getBoolStat("blackKingDead")){
        quip += "Oh my fucking god is THAT what the Grim Dark players have been trying to do. Are organics really so dumb as to not realize how very little that benefits them?";
    }else if(!sessionSummary.scratched && dead == 0 && sessionSummary.frogStatus == "Full Frog" && sessionSummary.getBoolStat("ectoBiologyStarted") && !sessionSummary.getBoolStat("crashedFromCorruption") && !sessionSummary.getBoolStat("crashedFromPlayerActions")){
      quip += "Everything went better than expected." ; //???
    }else if(sessionSummary.getBoolStat("yellowYard") == true){
      quip += "Fuck. I better go grab JR. They'll want to see this. " ;
    }else if(living == 0) {
      quip += "Shit, you do not even want to KNOW how everybody died.";
    }else  if(strongest.getStat(Stats.POWER) > 3000 * Stats.POWER.coefficient){
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





  @override
  void recoverFromCorruption() {
    ;
    summarizeSession(curSessionGlobalVar); //well...THAT session ended
  }

  //this will be called once session has ended. it's up to each child to know what to do here.
  void summarizeSession(Session session);

  void summarizeSessionNoFollowup(Session session);


  @override
  void renderScratchButton(Session session) {
    needToScratch = true;
  }

  @override
  Future<Null> restartSession() async {
    setHtml(SimController.instance.storyElement, '');
    window.scrollTo(0, 0);
    await checkEasterEgg();
    easterEggCallBackRestart();
  }

  @override
  void shareableURL() {
    throw "AB doesn't do this";
  }


}