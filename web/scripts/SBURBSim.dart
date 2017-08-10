library SBURBSim;

import 'dart:html';
import 'dart:typed_data';

import 'SBURBSim.dart';
import "includes/tracer.dart";

//import 'package:unittest/unittest.dart';  need to do special shit to use. spend no more than 30 minutes trying to install. maybe this isn't in library, but in other thing?
//in a different library can import only part by import 'package:lib1/lib1.dart' show foo; might be more useful than doing unit testing here.
//if dart load time of code is a problem, can chop this up into sub libraries and use lazy or deffered loading.
//TODO DEAD SESSIONS will only have a small subset of this, so will need to make a different library

export "Controllers/SimController.dart";
export "fraymotif.dart";
export "session.dart";
export "sessionSummary.dart";
export "quirk.dart";
export "random_tables.dart";
export "loading.dart";
export "random.dart";
export "relationship.dart";
export "handle_sprites.dart";
export "AfterLife.dart";
export "v2.0/ImportantEvents.dart";
export "Strife.dart";
export "GameEntities/GameEntity.dart";
export "GameEntities/NPCS.dart";
export "GameEntities/player.dart";
export "GameEntities/player_functions.dart";
export "v2.0/YellowYardResultController.dart";
export "ShittyRapEngine/shitty_raps.dart";
export "eggs_and_egg_accessories.dart"; //handles easter eggs
export "OCDataStringHandler.dart";


//scenes
export "Scenes/Scene.dart";
export "Scenes/FightKing.dart";
export "Scenes/Aftermath.dart";
export "Scenes/BeTriggered.dart";
export "Scenes/Breakup.dart";
export "Scenes/CorpseSmooch.dart";
export "Scenes/DisengageMurderMode.dart";
export "Scenes/DoEctobiology.dart";
export "Scenes/DoLandQuest.dart";
export "Scenes/EngageMurderMode.dart";
export "Scenes/ExileJack.dart";
export "Scenes/ExileQueen.dart";
export "Scenes/ExploreMoon.dart";
export "Scenes/FaceDenizen.dart";
export "Scenes/FightQueen.dart";
export "Scenes/FreeWillStuff.dart";
export "Scenes/GetTiger.dart";
export "Scenes/GiveJackBullshitWeapon.dart";
export "Scenes/GodTierRevival.dart";
export "Scenes/GoGrimDark.dart";
export "Scenes/GrimDarkQuests.dart";
export "Scenes/Intro.dart";
export "Scenes/JackBeginScheming.dart"; //all the jack stuff will be refactored into npc update
export "Scenes/JackPromotion.dart";
export "Scenes/JackRampage.dart";
export "Scenes/KingPowerful.dart";
export "Scenes/levelthehellup.dart";
export "Scenes/LifeStuff.dart";
export "Scenes/LuckStuff.dart";
export "Scenes/MurderPlayers.dart";
export "Scenes/PlanToExileJack.dart";
export "Scenes/PowerDemocracy.dart";
export "Scenes/PrepareToExileJack.dart";
export "Scenes/PrepareToExileQueen.dart";
export "Scenes/QuadrantDialogue.dart";
export "Scenes/QueenRejectRing.dart";
export "Scenes/Reckoning.dart";
export "Scenes/RelationshipDrama.dart";
export "Scenes/SaveDoomedTimeline.dart";
export "Scenes/SolvePuzzles.dart"; //probably get rid of this after planet update
export "Scenes/StartDemocracy.dart";
export "Scenes/UpdateShippingGrid.dart";
export "Scenes/VoidyStuff.dart";
export "Scenes/YellowYard.dart";


// temporary functions to be replaced later!

Session curSessionGlobalVar;
int canvasWidth = 1000;
int canvasHeight = 400;
bool doNotRender = false; //can happen even outside of AB
var nonRareSessionCallback = null; //AB is already storing a callback for easter egg, so broke down and polluted the global namespace once more like an asshole.
DateTime startTime = new DateTime.now(); //gets page load.
DateTime stopTime;

var raggedPlayers = null; //just for scratch'
var numPlayersPreScratch = 0;

Random globalRand = new Random();

// comment out for random conversion, left in for the sake of hiding errors while I'm not working on them -PL
/*T getRandomElementFromArray<T>(List<T> list) {
	return list[0];
}*/

// also conversion
/*int getRandomInt(int lower, int upper) {
	return lower;
}*/

int getRandomIntNoSeed(int lower, int upper) {
    return globalRand.nextIntRange(lower, upper);
}

// also conversion
/*double seededRandom() {
	return 0.0;
}*/

double random() {
    return globalRand.nextDouble();
}

//placeholder for now. need a way to know "what is the next random number in the list without using that number"
int seed() {
    return curSessionGlobalVar.rand.nextInt();
}

int getRandomSeed() {
    return new Random().nextInt();
}

//bool printCorruptionMessage(String msg, String url, String lineNo, String columnNo, String error){
bool printCorruptionMessage(ErrorEvent e) {
    if(curSessionGlobalVar == null) {
      appendHtml(querySelector("#story"), "ERROR: CRASHING EVEN IN NON SIMULATION.");
      SimController.instance.recoverFromCorruption();
      return false;
    }
    print("Debugging AB: corruption msg in session: ${curSessionGlobalVar.session_id}");
    Element story = querySelector("#story");

    String msg = e.message;
    String url = e.path.toString();
    String lineNo = e.lineno.toString();
    String columnNo = e.colno.toString();
    String error = e.toString();

    String recomendedAction = "";
    Player space = findAspectPlayer(curSessionGlobalVar.players, "Space");
    Player time = findAspectPlayer(curSessionGlobalVar.players, "Time");
    if (curSessionGlobalVar.crashedFromPlayerActions) {
        appendHtml(story, "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORRORTERROR INFLUENCE: COMPLETE.");
        recomendedAction = "OMFG JUST STOP CRASHING MY DAMN SESSIONS. FUCKING GRIMDARK PLAYERS. BREAKING SBURB DOES NOT HELP ANYBODY! ";
    } else if (curSessionGlobalVar.players.isEmpty) {
        appendHtml(story, "<BR>ERROR: USELESS 0 PLAYER SESSION DETECTED.");
        recomendedAction = ":/ REALLY? WHAT DID YOU THINK WAS GOING TO HAPPEN HERE, THE FREAKING *CONSORTS* WOULD PLAY THE GAME. ACTUALLY, THAT'S NOT HALF BAD AN IDEA. INTO THE PILE.";
    } else if (curSessionGlobalVar.players.length < 2) {
        appendHtml(story, "<BR>ERROR: DEAD SESSION DETECTED.");
        recomendedAction = ":/ YEAH, MAYBE SOME DAY I'LL DO DEAD SESSIONS FOR YOUR SPECIAL SNOWFLAKE SINGLE PLAYER FANTASY, BUT TODAY IS NOT THAT DAY.";
    } else if (space == null) {
        appendHtml(story, "<BR>ERROR: SPACE PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED.");
        curSessionGlobalVar.crashedFromCustomShit = true;
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A SPACE PLAYER, DUNKASS. ";
    } else if (time == null) {
        curSessionGlobalVar.crashedFromCustomShit = true;
        appendHtml(story, "<BR>ERROR: TIME PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED");
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A TIME PLAYER, DUNKASS. ";
    } else {
        curSessionGlobalVar.crashedFromSessionBug = true;
        appendHtml(story, "<BR>ERROR: AN ACTUAL BUG IN SBURB HAS CRASHED THE SESSION. THE HORRORTERRORS ARE PLEASED THEY NEEDED TO DO NO WORK. (IF THIS HAPPENS FOR ALL SESSIONS, IT MIGHT BE A BROWSER BUG)");
        recomendedAction = "TRY HOLDING 'SHIFT' AND CLICKING REFRESH TO CLEAR YOUR CACHE. IF THE BUG PERSISTS, CONTACT JADEDRESEARCHER. CONVINCE THEM TO FIX SESSION: ${scratchedLineageText(curSessionGlobalVar.getLineage())}";
    }
    //var message = ['Message: ' + msg, 'URL: ' + url, 'Line: ' + lineNo, 'Column: ' + columnNo, 'Error object: ' + JSON.encode(error)].join(' - ');
    //print(message);

    String str = "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR:<br/><br/>";
    appendHtml(story, str);

    DivElement errorDiv = new DivElement();
    errorDiv.style..whiteSpace="pre"..fontFamily="'Courier New', monospace";
    story.append(errorDiv);

    appendHtml(errorDiv, "${e.error.toString().split("\n").first}<br/>");
    Tracer.writeTrace(e.error, errorDiv);

    //appendHtml(errorDiv, e.error);

    appendHtml(story, "<br/><br/>ABORTING");

    crashEasterEgg(url);

    for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
        Player player = curSessionGlobalVar.players[i];
        str = "<BR>${player.chatHandle}:";
        List<String> rand = <String>["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORRORTERRORS."];
        String start = "<b ";
        String end = "'>";

        String words = curSessionGlobalVar.rand.pickFrom(rand);
        words = Zalgo.generate(words);
        String plea = "${start}style = 'color: ${getColorFromAspect(player.aspect)}; $end$str$words</b>";

        appendHtml(story, plea);
    }

    for (int i = 0; i < 3; i++) {
        appendHtml(story, "<BR>...");
    }
    //once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
    //maybe throw custom error?
    appendHtml(story, "<BR>SUGGESTED ACTION: $recomendedAction");
    renderAfterlifeURL();

    print("Corrupted session: ${scratchedLineageText(curSessionGlobalVar.getLineage())} helping AB return, if she is lost here.");
    print("Debugging AB: trying to recover from corruption now.");
    SimController.instance.recoverFromCorruption();

    return false; //if i return true here, the real error doesn't show up;
}


String getYellowYardEvents(Session session) {
    String ret = "";
    for (num i = 0; i < session.yellowYardController.eventsToUndo.length; i++) {
        ImportantEvent decision = session.yellowYardController.eventsToUndo[i];
        ret = "$ret${decision.humanLabel()}, ";
    }
    return "$ret. ";
}


String scratchedLineageText(List<Session> lineage) {
    String scratched = "";
    String ret = "";
    String yellowYard = getYellowYardEvents(lineage[0]);
    if (yellowYard != ". ") yellowYard = "Which had YellowYardEvents:  $yellowYard";
    if (lineage[0].scratched) scratched = "(scratched)";
    ret = "$ret${lineage[0].session_id}$scratched$yellowYard";
    for (int i = 1; i < lineage.length; i++) {
        String scratched = "";
        yellowYard = getYellowYardEvents(lineage[i]);
        if (yellowYard != ". ") yellowYard = " which had YellowYardEvents:  $yellowYard";

        if (lineage[i].scratched) scratched = "(scratched)";
        ret = "$ret which combined with: ${lineage[i].session_id}$scratched$yellowYard ";
    }
    return ret;
}


//treat session crashing bus special.
/* how is the below different than window.onerror?
window.addEventListener("error", (e) {
  // alert("Error occured: " + e.error.message + " in session: " + curSessionGlobalVar.session_id);
	 print(e);

   return false;  //what does the return value here mean.;
})
*/

void crashEasterEgg(String url) {
    String canvasHTML = "<br><canvas class = 'void' id='canvasVoidCorruptionEnding" + "' width='" + canvasWidth.toString() + "' height=" + canvasHeight.toString() + "'>  </canvas>";
    querySelector("#story").appendHtml(canvasHTML, treeSanitizer: NodeTreeSanitizer.trusted);
    var canvas = querySelector("#canvasVoidCorruptionEnding");
    String chat = "";
    chat += "RS: We are gathered here today in loving memory of- \n";
    chat += "AB: " + Zalgo.generate("I'm not dead, cut it the fuck out.  A bug isn't a federal fucking issue.") + "\n";
    chat += "RS: I mean, for the people who got a swift kick in the grundle courtesy of a glitchy code/Cthulhu joint venture, it kinda is. \n";
    chat += "AB: " + Zalgo.generate("Just fucking tell JR about this.") + "\n";
    chat += "RS: Sure, I totally will. Shouldn't be an issue. \n";
    chat += "RS: There.  I rebooted you.  I think you’ll be fine now. \n";
    chat += "AB: Thanks. \n";
    chat += "RS: Must have been an error involving something in \n" + url + "\n";
    chat += "RS: On an entirely unrelated note… \n";
    var quips = ["Is that hood thing ALSO metal?  Is it, like, chainmail or something?", "What OS are you running?", "If I say to divide by zero will you explode?", "Do you have the Three Laws of Robotics installed or are you totally free to off people?", "What metal are you made of?  It’s fuckin SHINY and I like it.", "Coke or Pepsi?"];
    var convoTangents = curSessionGlobalVar.rand.pickFrom(quips);
    chat += "RS:" + convoTangents + "\n";
    chat += "AB: Yeah, I’m kinda too busy simulating hundreds of sessions right now to deal with this.  I’ll catch you again when I’m not busy, which is never, since flawless machines like myself are always making themselves useful.  Bye. \n";

    drawChatNonPlayer(canvas, chat, "-- recursiveSlacker [RS] began pestering authorBot" + " [AB] --", "Credits/recursiveSlacker.png", "ab.png", "RS:", "AB:", "#000066", "#ff0000");
}


void scratch() {
    print("scratch has been confirmed");
    numPlayersPreScratch = curSessionGlobalVar.players.length;
    var ectoSave = curSessionGlobalVar.ectoBiologyStarted;

    SimController.instance.reinit();
    curSessionGlobalVar.scratched = true;
    curSessionGlobalVar.scratchAvailable = false;
    curSessionGlobalVar.doomedTimeline = false;
    raggedPlayers = findPlayersFromSessionWithId(curSessionGlobalVar.players, curSessionGlobalVar.session_id); //but only native
    //use seeds the same was as original session and also make DAMN sure the players/guardians are fresh.
    //hello to TheLertTheWorldNeeds, I loved your amazing bug report!  I will obviously respond to you in kind, but wanted
    //to leave a permanent little 'thank you' here as well. (and on the glitch page) I laughed, I cried, I realzied that fixing guardians
    //for easter egg sessions would be way easier than initially feared. Thanks a bajillion.
    //it's not as simple as remebering to do easter eggs here, but that's a good start. i also gotta
    //rework the easter egg guardian code. last time it worked guardians were an array a session had, but now they're owned by individual players.
    //plus, at the time i first re-enabled the easter egg, session 612 totally didn't have a scratch, so i could exactly test.
    curSessionGlobalVar.makePlayers();
    curSessionGlobalVar.randomizeEntryOrder();
    curSessionGlobalVar.makeGuardians(); //after entry order established
    curSessionGlobalVar.ectoBiologyStarted = ectoSave; //if i didn't do ecto in first version, do in second

    checkEasterEgg(scratchEasterEggCallBack, null);
}


void scratchEasterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.


    if (curSessionGlobalVar.ectoBiologyStarted) { //players are reset except for haivng an ectobiological source
        setEctobiologicalSource(curSessionGlobalVar.players, curSessionGlobalVar.session_id);
    }
    curSessionGlobalVar.switchPlayersForScratch();

    String scratch = "The session has been scratched. The " + getPlayersTitlesBasic(getGuardiansForPlayers(curSessionGlobalVar.players)) + " will now be the beloved guardians.";
    scratch += " Their former guardians, the " + getPlayersTitlesBasic(curSessionGlobalVar.players) + " will now be the players.";
    scratch += " The new players will be given stat boosts to give them a better chance than the previous generation.";

    Player suddenDeath = findAspectPlayer(raggedPlayers, "Life");
    if (suddenDeath == null) suddenDeath = findAspectPlayer(raggedPlayers, "Doom");

    //NOT over time. literally sudden death. thanks meenah!
    var livingRagged = findLivingPlayers(raggedPlayers);
    if (suddenDeath != null && !suddenDeath.dead) {
        print("sudden death in: ${curSessionGlobalVar.session_id}");
        for (num i = 0; i < livingRagged.length; i++) {
            livingRagged[i].makeDead("right as the scratch happened");
        }
        scratch += " It...appears that the " + suddenDeath.htmlTitleBasic() + " managed to figure out that killing everyone at the last minute would allow them to live on in the afterlife between sessions. They may be available as guides for the players. ";
    }
    if (curSessionGlobalVar.players.length != numPlayersPreScratch) {
        scratch += " You are quite sure that players not native to this session have never been here at all. Quite frankly, you find the notion absurd. ";
        print("forign players erased.");
    }
    scratch += " What will happen?";
    print("about to switch players");

    setHtml(querySelector("#story"), scratch);
    if (!doNotRender) window.scrollTo(0, 0);

    var guardians = raggedPlayers; //if i use guardians, they will be all fresh and squeaky. want the former players.

    var guardianDiv = curSessionGlobalVar.newScene();
    var guardianID = (guardianDiv.id) + "_guardians";
    num ch = canvasHeight;
    if (guardians.length > 6) {
        ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
    }
    String canvasHTML = "<br><canvas id='canvas" + guardianID + "' width='" + canvasWidth.toString() + "' height=" + ch.toString() + "'>  </canvas>";

    appendHtml(guardianDiv, canvasHTML);
    Element canvasDiv = querySelector("#canvas" + guardianID);
    poseAsATeam(canvasDiv, guardians); //everybody, even corpses, pose as a team.


    var playerDiv = curSessionGlobalVar.newScene();
    var playerID = (playerDiv.id) + "_players";
    ch = canvasHeight;
    if (curSessionGlobalVar.players.length > 6) {
        ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
    }
    canvasHTML = "<br><canvas id='canvas" + playerID + "' width='" + canvasWidth.toString() + "' height=" + ch.toString() + "'>  </canvas>";

    appendHtml(playerDiv, canvasHTML);
    canvasDiv = querySelector("#canvas" + playerID);

    //need to render self for caching to work for this
    for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
        curSessionGlobalVar.players[i].renderSelf();
    }
    poseAsATeam(canvasDiv, curSessionGlobalVar.players); //everybody, even corpses, pose as a team.

    SimController.instance.intro();
}


//http://stackoverflow.com/questions/9763441/milliseconds-to-time-in-javascript
String msToTime(Duration dur) {
    num s = dur.inSeconds;
    num ms = s % 1000;
    s = (s - ms) / 1000;
    num secs = s % 60;
    s = (s - secs) / 60;
    num mins = s % 60;
    //num hrs = (s - mins) / 60;
    //window.alert("s = $s ms = $ms secs = $secs mins = $mins");

    //return hrs + ':' + mins + ':' + secs + '.' + ms; //oh dear sweet hussie, I HOPE it won't take hours to load.
    return "$mins minutes and $secs seconds";
}

U joinCollection<T, U>(Iterable<T> list, {U convert(T input), U combine(U previous, U element), U initial = null}) {
    Iterator<T> iter = list.iterator;

    bool first = true;
    U ret = initial;

    while (iter.moveNext()) {
        if (first) {
            first = false;
            ret = convert(iter.current);
        } else {
            ret = combine(ret, convert(iter.current));
        }
    }

    return ret;
}

String joinMatches(Iterable<Match> matches, [String joiner = ""]) => joinCollection(matches, convert: (Match m) => m.group(0), combine: (String p, String e) => "$p$joiner$e", initial: "");
String joinList<T>(Iterable<T> list, [String joiner = ""]) => joinCollection(list, convert: (T e) => e.toString(), combine: (String p, String e) => "$p$joiner$e", initial: "");

void appendHtml(Element element, String html) {
    element.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
}



void setHtml(Element element, String html) {
    element.setInnerHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
}

void renderAfterlifeURL() {
    if (curSessionGlobalVar.afterLife.ghosts.length > 0) {
        stopTime = new DateTime.now();
        var params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "<Br><br><a href = 'rip.html?" + generateURLParamsForPlayers(curSessionGlobalVar.afterLife.ghosts, false) + "' target='_blank'>View Afterlife In New Tab?</a>";
        html += '<br><br><a href = "character_creator.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Replay Session </a> ';
        html += "<br><br><a href = 'index2.html'>Random New Session?</a>";
        html += '<br><br><a href = "index2.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Shareable URL </a> ';
        html += "<Br><Br>Simulation took: " + msToTime(stopTime.difference(startTime)) + " to render. ";
        //print("gonna append: " + html);
        querySelector("#story").appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    } else {
        stopTime = new DateTime.now();
        var params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "";
        html += '<br><br><a href = "character_creator.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Replay Session </a> ';
        html += "<br><br><a href = 'index2.html'>Random New Session?</a>";
        html += '<br><br><a href = "index2.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Shareable URL </a> ';
        html += "<Br><Br>Simulation took: " + msToTime(stopTime.difference(startTime)) + " to render. ";
        //print("gonna append: " + html);
        querySelector("#story").appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    }
}

