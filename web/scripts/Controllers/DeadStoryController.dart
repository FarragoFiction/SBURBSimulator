import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
void main() {
  //maybe if i define it here it won't be the same as end time
  startTime =new DateTime.now();
  //print("If you are in dartium, make sure to select this file to access it's global vars");
  new DateTime.now();
  new Timer(new Duration(milliseconds: 1000), () =>window.scrollTo(0, 0));

  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((Event event){
  	ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  loadNavbar();
  //be dead looking
  querySelector("#story").style.backgroundColor = "grey";
  //querySelector("#links").style.backgroundColor = "grey";
  querySelector("#debug").style.backgroundColor = "grey";
  querySelector("#charSheets").style.backgroundColor = "grey";

  new DeadStoryController(); //will set this as SimController's instance variable.
  if(getParameterByName("seed",null) != null){
   // Math.seed = getParameterByName("seed");  //TODO replace this somehow
    SimController.instance.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
   // Math.seed = tmp; //TOdo do something else here but rand is inside of session......
    SimController.instance.initial_seed = tmp;
  }

  SimController.instance.shareableURL();

  SimController.instance.startSession();
}


//TODO: have custom intro tick and aftermath. make dead sessions have X number of planets depending on theme.
class DeadStoryController extends SimController {
  DeadStoryController() : super();

  @override
  void createInitialSprites() {
    //print("players: ${curSessionGlobalVar.players}");
    for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
      Player player = curSessionGlobalVar.players[i];
      player.renderSelf();
    }
    (curSessionGlobalVar as DeadSession).metaPlayer.renderSelf();
  }

  @override
  void startSession() {
    globalInit(); // initialise classes and aspects if necessary

    // //print("Debugging AB: Starting session $initial_seed");
    curSessionGlobalVar = new DeadSession(initial_seed);
    changeCanonState(getParameterByName("canonState",null));
    //  //print("made session with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    reinit();
    ////print("did reinit with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    Scene.createScenesForSession(curSessionGlobalVar);
    ////print("created scenes with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    curSessionGlobalVar.makePlayers();
    ////print("made players with next int of: ${curSessionGlobalVar.rand.nextInt()}");
    curSessionGlobalVar.randomizeEntryOrder();
    //authorMessage();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    //easter egg ^_^
    if (getParameterByName("royalRumble", null) == "true") {
      debugRoyalRumble();
    }

    if (getParameterByName("COOLK1D", null) == "true") {
      cool_kid = true;
      coolK1DMode();
    }

    if (getParameterByName("pen15", null) == "ouija") {
      pen15Ouija();
    }



    if (getParameterByName("faces", null) == "off") {
      faceOffMode();
    }

    if (getParameterByName("tier", null) == "cod") {
      bardQuestMode();
    }

    if (getParameterByName("lollipop", null) == "true") {
      tricksterMode();
    }

    if (getParameterByName("robot", null) == "true") {
      roboMode();
    }

    if (getParameterByName("sbajifier", null) == "true") {
      sbahjMode();
    }

    if (getParameterByName("babyStuck", null) == "true") {
      babyStuckMode();
    }

    checkEasterEgg(easterEggCallBack, null);
  }

  @override
  void reckoning() {
    ////print('reckoning');
    Scene s = new DeadReckoning(curSessionGlobalVar);
    s.trigger(curSessionGlobalVar.players);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString(),));
    renderAfterlifeURL();
  }

  @override
  void processCombinedSession() {
      //guaranteed to make one since it's a dead session
      Session tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
      SimController.instance = null;
      new StoryController();
      doComboSession(tmpcurSessionGlobalVar);

  }


  @override
  void callNextIntro(int player_index) {
    if (player_index >= curSessionGlobalVar.players.length) {
      tick(); //NOW start ticking
      return;
    }
    DeadIntro s = new DeadIntro(curSessionGlobalVar);
    Player p = curSessionGlobalVar.players[player_index];
    //var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
    List<Player> playersInMedium = curSessionGlobalVar.players.sublist(0, player_index + 1);
    s.trigger(<Player>[p]);
    s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString())); //new scenes take care of displaying on their own.
    curSessionGlobalVar.processScenes(playersInMedium);
    //player_index += 1;
    //new Timer(new Duration(milliseconds: 10), () => callNextIntro(player_index)); //sweet sweet async
    this.gatherStats();
    tick();
  }

  @override
  void doComboSession(Session tmpcurSessionGlobalVar) {
      if(tmpcurSessionGlobalVar == null) tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();  //if space field this ALWAYS returns something. this should only be called on null with space field
      curSessionGlobalVar = tmpcurSessionGlobalVar;
      //maybe ther ARE no corpses...but they are sure as shit bringing the dead dream selves.
      List<Player> living = findLivingPlayers(curSessionGlobalVar.aliensClonedOnArrival);
      if(living.isEmpty) {
          appendHtml(querySelector("#story"), "<br><Br>You feel a nauseating wave of space go over you. What happened? Wait. Fuck. That's right. The Space Player made it so that they could enter their own child Session. But. Fuck. Everybody is dead. This...god. Maybe...maybe the other Players can revive them? ");
      }else {
          appendHtml(querySelector("#story"), "<br><Br> Entering: session <a href = 'index2.html?seed=${curSessionGlobalVar.session_id}'>${curSessionGlobalVar.session_id}</a>");
      }
      checkSGRUB();
      if(curSessionGlobalVar.mutator.spaceField) {
          window.scrollTo(0, 0);
          querySelector("#charSheets").setInnerHtml("");
          querySelector("#story").setInnerHtml("You feel a nauseating wave of space go over you. What happened? Huh. Is that.... a new session? How did the Players get here? Are they joining it? Will...it...even FIT having ${curSessionGlobalVar.players.length} fucking players inside it? ");
      }
      load(curSessionGlobalVar.players, <Player>[(curSessionGlobalVar as DeadSession).metaPlayer], ""); //in loading.js
  }


}


class StoryController extends SimController {
    StoryController() : super();
}