library SBURBSim;
//TODO some day, split this into multiple libraries.

import 'dart:html';

import 'SBURBSim.dart';
import "includes/tracer.dart";
export 'includes/logger.dart';
export 'includes/math_utils.dart';
export 'Alchemy/Specibus.dart';
export 'Alchemy/Trait.dart';
export 'Alchemy/Item.dart';
export 'Alchemy/AlchemyResult.dart';


export "SessionEngine/SessionMutator.dart";
export "NPCEngine/NPCHandler.dart";
export "SessionEngine/SessionStats.dart";
export "Controllers/Misc/SimController.dart";
export "GameEntities/ClasspectStuff/Aspects/Aspect.dart";
export "GameEntities/ClasspectStuff/Classes/SBURBClass.dart";
export "GameEntities/ClasspectStuff/Interests/Interest.dart";
export "GameEntities/Stats/buff.dart";
export "GameEntities/Stats/stat.dart";
export "GameEntities/Stats/statholder.dart";
export "formats/FileFormat.dart";
export "loader/loader.dart";
export "fraymotif.dart";
export "Lands/Theme.dart";
export "Lands/Feature.dart";
export "Lands/Land.dart";
export "Lands/Moon.dart";
export "Lands/BattleField.dart";
export "Lands/FeatureFactory.dart";
export "SessionEngine/session.dart";
export "SessionEngine/DeadSession.dart";
export "SessionEngine/sessionSummary.dart";
export "FAQEngine/FAQFile.dart";
export "FAQEngine/GeneratedFAQ.dart";
export "FAQEngine/FAQSection.dart";
export "random_tables.dart";
export "loading.dart";
export "random.dart";
export "weighted_lists.dart";
export "relationship.dart";
export "handle_sprites.dart";
export "Rendering/renderer.dart";
export "AfterLife.dart";
export "v2.0/ImportantEvents.dart";
export "Strife.dart";
export "GameEntities/GameEntity.dart";
export "GameEntities/NPCS.dart";
export "GameEntities/player.dart";
export "GameEntities/player_functions.dart";
export "v2.0/YellowYardResultController.dart";
export "ShittyRapEngine/shitty_raps.dart";
export "EasterEggs/eggs_and_egg_accessories.dart"; //handles easter eggs
export "OCDataStringHandler.dart";
export "quirk.dart";


//scenes
export "Scenes/Scene.dart";
export "Scenes/Gristmas.dart";
export "Scenes/FightKing.dart";
export "Scenes/Aftermath.dart";
export "Scenes/BeTriggered.dart";
export "Scenes/Breakup.dart";
export "Scenes/CorpseSmooch.dart";
export "Scenes/DisengageMurderMode.dart";
export "Scenes/DoEctobiology.dart";
export "Scenes/QuestsAndStuff.dart";
export "Scenes/EngageMurderMode.dart";
export "Scenes/ExileJack.dart";
export "Scenes/ExileQueen.dart";
export "Scenes/FightQueen.dart";
export "Scenes/FreeWillStuff.dart";
export "Scenes/GetTiger.dart";
export "Scenes/GetWasted.dart";
export "Scenes/GiveJackBullshitWeapon.dart";
export "Scenes/GodTierRevival.dart";
export "Scenes/GoGrimDark.dart";
export "Scenes/GrimDarkQuests.dart";
export "Scenes/IntroNew.dart";
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
export "Scenes/StartDemocracy.dart";
export "Scenes/UpdateShippingGrid.dart";
export "Scenes/VoidyStuff.dart";
export "Scenes/YellowYard.dart";
export "Scenes/DeadScenes/DeadIntro.dart";
export "Scenes/DeadScenes/DeadReckoning.dart";
export "Scenes/DeadScenes/DeadMeta.dart";
export "Scenes/DeadScenes/DeadQuests.dart";

export "includes/colour.dart";
export "includes/palette.dart";
export "includes/predicates.dart";

/// if false, still need to init classes/aspects
bool doneGlobalInit = false;

Session curSessionGlobalVar;
int canvasWidth = 1000;
int canvasHeight = 400;
bool doNotRender = false; //can happen even outside of AB
bool doNotFetchXml = false; //slows AB down like WHOA.
var nonRareSessionCallback = null; //AB is already storing a callback for easter egg, so broke down and polluted the global namespace once more like an asshole.
DateTime startTime = new DateTime.now(); //gets page load.  but doesn't work. put it  in main later
DateTime stopTime;

List<Player> raggedPlayers = null; //just for scratch'
int numPlayersPreScratch = 0;

void globalInit() {
    if (doneGlobalInit) { return; }
    doneGlobalInit = true;

    Stats.init();
    ItemTraitFactory.init();
    SpecibusFactory.init();
    FeatureFactory.init(); //do BEFORE classes or aspects or you're gonna have a bad time (null features) PL figured this out
    SBURBClassManager.init();
    Aspects.init();

    InterestManager.init();

    Loader.init();
}

Random globalRand = new Random();

int getRandomIntNoSeed(int lower, int upper) {
    return globalRand.nextIntRange(lower, upper);
}

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
      appendHtml(SimController.instance.storyElement, "ERROR: CRASHING EVEN IN NON SIMULATION.");
      SimController.instance.recoverFromCorruption();
      return false;
    }
    //print("Debugging AB: corruption msg in session: ${curSessionGlobalVar.session_id}");
    Element story = SimController.instance.storyElement;

    //String msg = e.message;
    String url = e.path.toString();
    //String lineNo = e.lineno.toString();
    //String columnNo = e.colno.toString();
    //String error = e.toString();

    String recomendedAction = "";
    print(curSessionGlobalVar.stats); //why does it think it's not a grim or cataclym when it clear is sometimes?
    Player space = findAspectPlayer(curSessionGlobalVar.players, Aspects.SPACE);
    Player time = findAspectPlayer(curSessionGlobalVar.players, Aspects.TIME);
    if (curSessionGlobalVar.stats.crashedFromPlayerActions) {
        appendHtml(story, "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORRORTERROR INFLUENCE: COMPLETE.");
        recomendedAction = "OMFG JUST STOP CRASHING MY DAMN SESSIONS. FUCKING GRIMDARK PLAYERS. BREAKING SBURB DOES NOT HELP ANYBODY! ${mutatorsInPlay(curSessionGlobalVar)}";
    }else if(curSessionGlobalVar.stats.cataclysmCrash) {
        appendHtml(story, "<BR>ERROR: WASTE TIER CATACLYSM ACTIVATED. SESSION HAS CRASHED.");
        recomendedAction = "OMFG YOU ASSHOLE WASTES. GIT GUD.  THERE IS A FUCKING *REASON* RESTRAINT IS PART OF OUR MATURITY QUESTS. (And if somehow a non Waste/Grace managed to cause this much damage, holy fuck, what were you THINKING you maniac?) ${mutatorsInPlay(curSessionGlobalVar)}";
    }else if((curSessionGlobalVar is DeadSession)) {
        appendHtml(story, "<BR>ERROR: HAHA YOUR DEAD SESSION CRASHED, ASSHOLE.");
        recomendedAction = "OH WELL, NOT LIKE IT WAS EVER SUPPOSED TO BE BEATABLE ANYWAYS. ${mutatorsInPlay(curSessionGlobalVar)}";

    }else if (curSessionGlobalVar.players.isEmpty) {
        appendHtml(story, "<BR>ERROR: USELESS 0 PLAYER SESSION DETECTED.");
        recomendedAction = ":/ REALLY? WHAT DID YOU THINK WAS GOING TO HAPPEN HERE, THE FREAKING *CONSORTS* WOULD PLAY THE GAME. ACTUALLY, THAT'S NOT HALF BAD AN IDEA. INTO THE PILE. ${mutatorsInPlay(curSessionGlobalVar)}";
    } else if (curSessionGlobalVar.players.length < 2 ) {
        appendHtml(story, "<BR>ERROR: DEAD SESSION DETECTED.");
        String url = "dead_index.html?seed=${curSessionGlobalVar.session_id}&${generateURLParamsForPlayers(<Player>[curSessionGlobalVar.players[0]],true)}";
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        url = "$url";
        recomendedAction = "WHOA. IS TODAY THE DAY I LET YOU DO A SPECIAL SNOWFLAKE SINGLE PLAYER SESSION??? <BR><BR><a href = '$url'>PLAY DEAD SESSION?</a><BR><BR>";
    } else if (time == null) {
        curSessionGlobalVar.stats.crashedFromSessionBug = true;
        appendHtml(story, "<BR>ERROR: TIME PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED");
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A TIME PLAYER, DUNKASS. ${mutatorsInPlay(curSessionGlobalVar)}";
    } else if (space == null) {
        appendHtml(story, "<BR>ERROR: SPACE PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED. ${mutatorsInPlay(curSessionGlobalVar)}");
        curSessionGlobalVar.stats.crashedFromSessionBug = true;
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A SPACE PLAYER, DUNKASS. ${mutatorsInPlay(curSessionGlobalVar)}";
    } else if(curSessionGlobalVar.mutator.effectsInPlay > 0){
        curSessionGlobalVar.stats.cataclysmCrash = true;
        appendHtml(story, "<BR>ERROR: NOW YOU FUCKED UP! YOUR SHITTY HACKED CODE CRASHED.");
        recomendedAction = "OMFG YOU ASSHOLE WASTES. GIT GUD.  FUCKING TEST YOUR SHIT, SCRUB. ${mutatorsInPlay(curSessionGlobalVar)} ";

    }else {
        curSessionGlobalVar.stats.crashedFromSessionBug = true;
        appendHtml(story, "<BR>ERROR: AN ACTUAL BUG IN SBURB HAS CRASHED THE SESSION. THE HORRORTERRORS ARE PLEASED THEY NEEDED TO DO NO WORK. (IF THIS HAPPENS FOR ALL SESSIONS, IT MIGHT BE A BROWSER BUG)");
        recomendedAction = "TRY HOLDING 'SHIFT' AND CLICKING REFRESH TO CLEAR YOUR CACHE. IF THE BUG PERSISTS, CONTACT JADEDRESEARCHER. CONVINCE THEM TO FIX SESSION: ${scratchedLineageText(curSessionGlobalVar.getLineage())}   ${mutatorsInPlay(curSessionGlobalVar)}";

    }
    //var message = ['Message: ' + msg, 'URL: ' + url, 'Line: ' + lineNo, 'Column: ' + columnNo, 'Error object: ' + JSON.encode(error)].join(' - ');
    ////print(message);

    String str = "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR:<br/><br/>";
    appendHtml(story, str);

    DivElement errorDiv = new DivElement();
    errorDiv.style..whiteSpace="pre"..fontFamily="'Courier New', monospace";
    story.append(errorDiv);

    appendHtml(errorDiv, "${e.error.toString().split("\n").first}<br/>");
    //appendHtml(errorDiv, e.error);
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
        String plea = "${start}style = 'color: ${player.aspect.palette.text.toStyleString()}; $end$str$words</b>";

        appendHtml(story, plea);
    }

    for (int i = 0; i < 3; i++) {
        appendHtml(story, "<BR>...");
    }
    //once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
    //maybe throw custom error?
    appendHtml(story, "<BR>SUGGESTED ACTION: $recomendedAction");
    renderAfterlifeURL();

    //print("Corrupted session: ${scratchedLineageText(curSessionGlobalVar.getLineage())} helping AB return, if she is lost here.");
    //print("Debugging AB: trying to recover from corruption now.");
    SimController.instance.recoverFromCorruption();

    return false; //if i return true here, the real error doesn't show up;
}

String mutatorsInPlay(Session session) {
    if(session.mutator.effectsInPlay == 0) return "";
    List<String> fields = new List<String>();
    if(session.mutator.lifeField) fields.add("Life");
    if(session.mutator.hopeField) fields.add("Hope");
    if(session.mutator.doomField) fields.add("Doom");
    if(session.mutator.lightField) fields.add("Light");
    if(session.mutator.breathField) fields.add("Breath");
    if(session.mutator.spaceField) fields.add("Space");
    if(session.mutator.timeField) fields.add("Time");
    if(session.mutator.voidField) fields.add("Void");
    if(session.mutator.heartField) fields.add("Heart");
    if(session.mutator.bloodField) fields.add("Blood");
    if(session.mutator.mindField) fields.add("Mind");
    if(session.mutator.rageField) fields.add("Rage");
    return "Mutators in Play: ${fields.join(",")}";
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
    //print("Generating linage text for crash");
    String scratched = "";
    String ret = "";
    String yellowYard = getYellowYardEvents(lineage[0]);
    if (yellowYard != ". ") yellowYard = "Which had YellowYardEvents:  $yellowYard";
    if (lineage[0].stats.scratched) scratched = "(scratched)";
    ret = "$ret${lineage[0].session_id}$scratched$yellowYard";
    for (int i = 1; i < lineage.length; i++) {
        String scratched = "";
        yellowYard = getYellowYardEvents(lineage[i]);
        if (yellowYard != ". ") yellowYard = " which had YellowYardEvents:  $yellowYard";

        if (lineage[i].stats.scratched) scratched = "(scratched)";
        ret = "$ret which combined with: ${lineage[i].session_id}$scratched$yellowYard ";
    }
    return ret;
}


//treat session crashing bus special.
/* how is the below different than window.onerror?
window.addEventListener("error", (e) {
  // alert("Error occured: " + e.error.message + " in session: " + curSessionGlobalVar.session_id);
	 //print(e);

   return false;  //what does the return value here mean.;
})
*/

void crashEasterEgg(String url) {
    CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
    canvas.classes.add("void");
    SimController.instance.storyElement.append(canvas);
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

    Drawing.drawChatNonPlayer(canvas, chat, "-- recursiveSlacker [RS] began pestering authorBot" + " [AB] --", "Credits/recursiveSlacker.png", "ab.png", "RS:", "AB:", "#000066", "#ff0000");
}


void scratch() {
    //print("scratch has been confirmed");
    numPlayersPreScratch = curSessionGlobalVar.players.length;
    var ectoSave = curSessionGlobalVar.stats.ectoBiologyStarted;

    SimController.instance.reinit();
    Scene.createScenesForSession(curSessionGlobalVar);
    curSessionGlobalVar.stats.scratched = true;
    curSessionGlobalVar.stats.scratchAvailable = false;
    curSessionGlobalVar.stats.doomedTimeline = false;
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
    curSessionGlobalVar.stats.ectoBiologyStarted = ectoSave; //if i didn't do ecto in first version, do in second

    checkEasterEgg(scratchEasterEggCallBack, null);
}


void scratchEasterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.


    if (curSessionGlobalVar.stats.ectoBiologyStarted) { //players are reset except for haivng an ectobiological source
        setEctobiologicalSource(curSessionGlobalVar.players, curSessionGlobalVar.session_id);
    }
    curSessionGlobalVar.switchPlayersForScratch();

    String scratch = "The session has been scratched. The " + getPlayersTitlesBasic(getGuardiansForPlayers(curSessionGlobalVar.players)) + " will now be the beloved guardians.";
    scratch += " Their former guardians, the " + getPlayersTitlesBasic(curSessionGlobalVar.players) + " will now be the players.";
    scratch += " The new players will be given stat boosts to give them a better chance than the previous generation.";

    Player suddenDeath = findAspectPlayer(raggedPlayers, Aspects.LIFE);
    if (suddenDeath == null) suddenDeath = findAspectPlayer(raggedPlayers, Aspects.DOOM);

    //NOT over time. literally sudden death. thanks meenah!
    List<Player> livingRagged = findLivingPlayers(raggedPlayers);
    if (suddenDeath != null && !suddenDeath.dead) {
        //print("sudden death in: ${curSessionGlobalVar.session_id}");
        for (num i = 0; i < livingRagged.length; i++) {
            scratch += livingRagged[i].makeDead("right as the scratch happened");
        }
        scratch += " It...appears that the " + suddenDeath.htmlTitleBasic() + " managed to figure out that killing everyone at the last minute would allow them to live on in the afterlife between sessions. They may be available as guides for the players. ";
    }
    if (curSessionGlobalVar.players.length != numPlayersPreScratch) {
        scratch += " You are quite sure that players not native to this session have never been here at all. Quite frankly, you find the notion absurd. ";
        //print("forign players erased.");
    }
    scratch += " What will happen?";
   // //print("about to switch players");

    setHtml(SimController.instance.storyElement, scratch);
    if (!doNotRender) window.scrollTo(0, 0);

    List<Player> guardians = raggedPlayers; //if i use guardians, they will be all fresh and squeaky. want the former players.

    Element guardianDiv = curSessionGlobalVar.newScene("???");
    String guardianID = "${guardianDiv.id}_guardians";
    num ch = canvasHeight;
    if (guardians.length > 6) {
        ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
    }

    CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
    guardianDiv.append(canvasDiv);

    Drawing.poseAsATeam(canvasDiv, guardians); //everybody, even corpses, pose as a team.


    Element playerDiv = curSessionGlobalVar.newScene("???");
    String playerID = "${playerDiv.id}_players";
    ch = canvasHeight;
    if (curSessionGlobalVar.players.length > 6) {
        ch = canvasHeight * 1.5; //a little bigger than two rows, cause time clones
    }
    canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
    playerDiv.append(canvasDiv);


    //need to render self for caching to work for this
    for (int i = 0; i < curSessionGlobalVar.players.length; i++) {
        curSessionGlobalVar.players[i].renderSelf();
    }
    Drawing.poseAsATeam(canvasDiv, curSessionGlobalVar.players); //everybody, even corpses, pose as a team.
    if(curSessionGlobalVar.mutator.spaceField) curSessionGlobalVar.mutator.scratchedCombo(curSessionGlobalVar, raggedPlayers);
    SimController.instance.intro();
}


//http://stackoverflow.com/questions/9763441/milliseconds-to-time-in-javascript
String msToTime(Duration dur) {
    //i can't figure out a better way to use this.
    return "$dur";
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
    if (!curSessionGlobalVar.afterLife.ghosts.isEmpty) {
        stopTime = new DateTime.now();
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "<Br><br><a href = 'rip.html?${generateURLParamsForPlayers(curSessionGlobalVar.afterLife.ghosts, false)}' target='_blank'>View Afterlife In New Tab?</a>";
        html = '$html<br><br><a href = "character_creator.html?seed=${curSessionGlobalVar.session_id}&$params" target="_blank">Replay Session </a> ';
        html = "$html<br><br><a href = 'index2.html'>Random New Session?</a>";
        html = '$html<br><br><a href = "index2.html?seed=${curSessionGlobalVar.session_id}&$params" target="_blank">Shareable URL </a> ';
        html = "$html<Br><Br>Simulation took: ${msToTime(stopTime.difference(startTime))} to render. ";
        print("Start time is $startTime and stop time is $stopTime, seconds for stop time is ${stopTime.second}");
        ////print("gonna append: " + html);
        SimController.instance.storyElement.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    } else {
        stopTime = new DateTime.now();
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "";
        html += '<br><br><a href = "character_creator.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Replay Session </a> ';
        html += "<br><br><a href = 'index2.html'>Random New Session?</a>";
        html += '<br><br><a href = "index2.html?seed=' + curSessionGlobalVar.session_id.toString() + '&' + params + ' " target="_blank">Shareable URL </a> ';
        html += "<Br><Br>Simulation took: " + msToTime(stopTime.difference(startTime)) + " to render. ";
        ////print("gonna append: " + html);
        SimController.instance.storyElement.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    }
}

