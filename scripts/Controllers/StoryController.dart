import '../SBURBSim.dart';
import 'dart:html';
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';

//replaces the poorly named scenario_controller2.js
num initial_seed = 0;
main() {
  //TODO scroll the window up
  //make a new StoryController (which will auto set itself as it's parent's singleton instance
  window.onError.listen((ErrorEvent e){
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
  });
  loadNavbar();
  new StoryController(); //will set this as SimController's instance variable.
  if(getParameterByName("seed",null) != null){
   // Math.seed = getParameterByName("seed");  //TODO replace this somehow
    initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    var tmp = getRandomSeed();
   // Math.seed = tmp; //TOdo do something else here
    initial_seed = tmp;
  }

  SimController.instance.shareableURL();

  SimController.instance.startSession();
}

class StoryController extends SimController {
  StoryController() : super();
  @override
  void callNextIntroWithDelay() {
    // TODO: implement callNextIntroWithDelay
  }

  @override
  void checkSGRUB() {
    bool sgrub = true;
    for(num i = 0; i<curSessionGlobalVar.players.length; i++){
      if(curSessionGlobalVar.players[i].isTroll == false){
        sgrub = false;
      }
    }
    //can only get here if all are trolls.
    if(sgrub){
      document.title ="SGRUB Story Generator by jadedResearcher";
      querySelector("#heading").setInnerHtml("SGRUB Story Generator by jadedResearcher (art assistance by karmicRetribution) ");
    }

    if(getParameterByName("nepeta",null)  == ":33"){
      document.title = "NepetaQuest by jadedResearcher";
      querySelector("#heading").setInnerHtml("NepetaQuest by jadedResearcher (art assistance by karmicRetribution) ");
    }
    if(curSessionGlobalVar.session_id == 33){
      document.title = "NepetaQuest by jadedResearcher";
      querySelector("#heading").setInnerHtml("NepetaQuest by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&nepeta=:33'>The furryocious huntress makes sure to bat at this link to learn a secret!</a>");
    }else if(curSessionGlobalVar.session_id == 420){
      document.title ="FridgeQuest by jadedResearcher";
      querySelector("#heading").setInnerHtml("FridgeQuest by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&honk=:o)'>wHoA. lIkE. wHaT If yOu jUsT...ReAcHeD OuT AnD ToUcHeD ThIs? HoNk!</a>");
    }else if(curSessionGlobalVar.session_id == 88888888){
      document.title ="SpiderQuuuuuuuuest!!!!!!!! by jadedResearcher";
      querySelector("#heading").setInnerHtml("SpiderQuuuuuuuuest!!!!!!!!  by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&luck=AAAAAAAALL'>Only the BEST Observers click here!!!!!!!!</a>");
    }else if(curSessionGlobalVar.session_id == 0){
      document.title = "0_0 by jadedResearcher";
      querySelector("#heading").setInnerHtml("0_0 by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&temporal=shenanigans'>Y0ur inevitabile clicking here will briefly masquerade as free will, and I'm 0kay with it.</a>");
    }else if(curSessionGlobalVar.session_id == 413){//why the hell is this one not triggering?
      "Homestuck Simulator by jadedResearcher";
      querySelector("#heading").setInnerHtml("Homestuck Simulator by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&home=stuck'>A young man stands next to a link. Though it was 13 years ago he was given life, it is only today he will click it.</a>");
    }else if(curSessionGlobalVar.session_id == 111111){//why the hell is this one not triggering?
      document.title ="Homestuck Simulator by jadedResearcher";
      querySelector("#heading").setInnerHtml("Homestuck Simulator by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&home=stuck'>A young lady stands next to a link. Though it was 16 years ago she was given life, it is only today she will click it.</a>");
    }else if(curSessionGlobalVar.session_id == 613){
      document.title ="OpenBound Simulator by jadedResearcher";
      querySelector("#heading").setInnerHtml("OpenBound Simulator by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&open=bound'>Rebubble this link?.</a>");
    }else if(curSessionGlobalVar.session_id == 612){
      document.title ="HiveBent Simulator by jadedResearcher";
      querySelector("#heading").setInnerHtml("HiveBent Simulator by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&hive=bent'>A young troll stands next to a click horizon. Though it was six solar sweeps ago that he was given life, it is only today that he will click it.</a>");
    }else if(curSessionGlobalVar.session_id == 1025){
      document.title ="Fruity Rumpus Asshole Simulator by jadedResearcher";
      querySelector("#heading").setInnerHtml("Fruity Rumpus Asshole Simulator by jadedResearcher (art assistance by karmicRetribution) ");
      querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed}&rumpus=fruity'>I will have order in this RumpusBlock!!!</a>");
    }
  }

  @override
  void easterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.
    checkSGRUB();
    load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players),""); //in loading.js
  }

  @override
  void easterEggCallBackRestart() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //initializePlayers
    intro();  //<-- instead of load, bc don't need to load.

  }

  @override
  void getSessionType() {
    throw "TODO";
    // TODO: implement getSessionType
  }

  @override
  void intro() {
    throw "TODO";
    // TODO: implement intro
  }

  @override
  void processCombinedSession() {
    throw "TODO";
    // TODO: implement processCombinedSession
  }

  @override
  void reckoning() {
    throw "TODO";
    // TODO: implement reckoning
  }

  @override
  void recoverFromCorruption() {
    throw "TODO";
    // TODO: implement recoverFromCorruption
  }

  @override
  void reinit() {
    available_classes = new List<String>.from(classes);
    available_aspects = new List<String>.from(nonrequired_aspects);
    available_aspects.addAll(required_aspects);
    curSessionGlobalVar.reinit();
  }

  @override
  void renderAfterlifeURL() {
    throw "TODO";
    // TODO: implement renderAfterlifeURL
  }

  @override
  void renderScratchButton(Session session) {
    throw "TODO";
    // TODO: implement renderScratchButton
  }

  @override
  void restartSession() {
    throw "TODO";
    // TODO: implement restartSession
  }

  @override
  void shareableURL() {
    var params = window.location.href.substring(window.location.href.indexOf("?")+1);
    if (params == window.location.href) params = "";
    String str = '<div class = "links"><a href = "index2.html?seed=${initial_seed}&' + params + ' ">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed${initial_seed}&' + params + ' " target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href ;= "index2.html">Random Session URL </a> </div>';
    querySelector("#seedText").setInnerHtml(str);
    querySelector("#story").appendHtml("Session: ${initial_seed}");
  }

  @override
  void startSession() {
    curSessionGlobalVar = new Session(initial_seed);
    reinit();
    Scene.createScenesForSession(curSessionGlobalVar);
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();
    //authorMessage();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    //easter egg ^_^
    if(getParameterByName("royalRumble",null)  == "true"){
      debugRoyalRumble();
    }

    if(getParameterByName("COOLK1D",null)  == "true"){
      cool_kid = true;
      coolK1DMode();
    }

    if(getParameterByName("pen15",null)  == "ouija"){
      pen15Ouija();
    }

    if(getParameterByName("faces",null)  == "off"){
      faceOffMode();
    }

    if(getParameterByName("tier",null)  == "cod"){
      bardQuestMode();
    }

    if(getParameterByName("lollipop",null)  == "true"){
      tricksterMode();
    }

    if(getParameterByName("robot",null)  == "true"){
      roboMode();
    }

    if(getParameterByName("sbajifier",null)  == "true"){
      sbahjMode();
    }

    if(getParameterByName("babyStuck",null)  == "true"){
      babyStuckMode();
    }

    checkEasterEgg(easterEggCallBack,null);
  }

  @override
  void tick() {
    throw "TODO";
    // TODO: implement tick
  }
}