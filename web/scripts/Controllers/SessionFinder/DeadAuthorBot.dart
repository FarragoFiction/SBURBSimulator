/*

Needed so multiple screens can all know how to quickly find sessions.
Rare session finder, tournament,  etc.
 */
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "../Misc/DeadSimController.dart";
import 'dart:html';
import "dart:async";
abstract class DeadAuthorBot extends DeadSimController {

  List<int> sessionsSimulated = [];

  List<SessionSummary> allSessionsSummaries = [];
  //how filtering works
  List<SessionSummary> sessionSummariesDisplayed = [];

  int numSimulationsDone = 0;
  int numSimulationsToDo = 0;
  bool needToScratch = false;

  DeadAuthorBot() : super();

  void checkSessions() {
    numSimulationsDone = 0; //but don't reset stats
    sessionSummariesDisplayed = [];
    for(num i = 0; i<allSessionsSummaries.length; i++){
      sessionSummariesDisplayed.add(allSessionsSummaries[i]);
    }
    setHtml(SimController.instance.storyElement, "");
    numSimulationsToDo = int.parse((querySelector("#num_sessions")as InputElement).value);
    (querySelector("#button")as ButtonElement).disabled =true;
    curSessionGlobalVar = new DeadSession(SimController.instance.initial_seed);
    startSessionThenSummarize();
  }






  @override
  void checkSGRUB() {
    //throw "ab does not do this";
  }


  @override
  void easterEggCallBack() {
    DeadSession ds = (curSessionGlobalVar as DeadSession);
    initializePlayers(curSessionGlobalVar.players,curSessionGlobalVar); //need to redo it here because all other versions are in case customizations
    ds.players[0].deriveLand = false;
    //ds.players[0].relationships.add(new Relationship(ds.players[0], -999, ds.metaPlayer)); //if you need to talk to anyone, talk to metaplayer.
    //ds.metaPlayer.relationships.add(new Relationship(ds.metaPlayer, -999, ds.players[0])); //if you need to talk to anyone, talk to metaplayer.

    if(doNotRender == true){
      curSessionGlobalVar.intro();
    }else{
      load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players),""); //in loading.js
    }
  }

  Future<Null> startSessionThenSummarize() async{
    await curSessionGlobalVar.startSession();
    print("I think the session stopped!");
    summarizeSession(curSessionGlobalVar);
  }

  @override
  void easterEggCallBackRestart() {
    initializePlayers(curSessionGlobalVar.players,curSessionGlobalVar); //need to redo it here because all other versions are in case customizations
    curSessionGlobalVar.intro();
  }


  //AB's reckoning is like the normal one, but if the session ends at the recknoing, ab knows what to do.
  @override
  void reckoning() {
    //unlike regular rare session finder it is ALWAYS over here. simple.
    Scene s = new DeadReckoning(curSessionGlobalVar);
    s.trigger(curSessionGlobalVar.players);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString(),));
    //renderAfterlifeURL();
    summarizeSession(curSessionGlobalVar);
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
    }else if(sessionSummary.getBoolStat("cataclysmCrash")){
      quip += Zalgo.generate("Holy shit. JR. You NEED to keep those Wastes under control. Why did you ever enable them?");
    }else if(sessionSummary.getBoolStat("won")){
      quip += "Welp, there goes another asshole with ultimate power.";
    }else {
      quip += "Oh look. A failed Dead Session. Who would have guessed.";
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