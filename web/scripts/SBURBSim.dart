library SBURBSim;
//TODO some day, split this into multiple libraries.

import 'dart:html';

import 'SBURBSim.dart';
import "dart:async";
import "includes/tracer.dart";
export 'navbar.dart';
export 'includes/logger.dart';
export 'includes/math_utils.dart';
export 'Alchemy/Specibus.dart';
export 'Alchemy/Trait.dart';
export 'Alchemy/Item.dart';
export 'Alchemy/MagicalItem.dart';

export 'Alchemy/AlchemyResult.dart';

export "Controllers/SessionFinder/AuthorBot.dart";
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
export "FraymotifEffect.dart";
export "Lands/Theme.dart";
export "Lands/Feature.dart";
export "Lands/Land.dart";
export "Lands/Moon.dart";
export "Lands/BattleField.dart";
export "Lands/FeatureFactory.dart";
export "SessionEngine/session.dart";
export "SessionEngine/DeadSession.dart";
export "SessionEngine/SessionSummaryLib.dart";
export "FAQEngine/FAQFile.dart";
export "FAQEngine/GeneratedFAQ.dart";
export "FAQEngine/FAQSection.dart";
export "random_tables.dart";
export "loading.dart";
export "random.dart";
export "weighted_lists.dart";
export "GameEntities/BigBadStuff/BigBadLib.dart";
export "GameEntities/relationship.dart";
export "GameEntities/NPCRelationship.dart";

export "handle_sprites.dart";
export "Rendering/renderer.dart";
export "AfterLife.dart";
export "ImportantEvents/ImportantEvents.dart";
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



export "Scenes/SceneLibrary.dart";

export "includes/colour.dart";
export "includes/palette.dart";
export "includes/predicates.dart";
export "text_engine.dart";
export "audio/audio.dart";

/// if false, still need to init classes/aspects
bool doneGlobalInit = false;

//Session session;  jesus fuck finally stop doing this, it was such a bad idea and javascripts greatest blow against me
int canvasWidth = 1000;
int canvasHeight = 400;
bool doNotRender = false; //can happen even outside of AB
bool doNotFetchXml = false; //slows AB down like WHOA.
var nonRareSessionCallback = null; //AB is already storing a callback for easter egg, so broke down and polluted the global namespace once more like an asshole.
DateTime startTime = new DateTime.now(); //gets page load.  but doesn't work. put it  in main later
DateTime stopTime;

List<Player> raggedPlayers = null; //just for scratch'
int numPlayersPreScratch = 0;

Future<Null> globalInit() async {
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
    await NPCHandler.loadBigBads();

}

Random globalRand = new Random();

int getRandomIntNoSeed(int lower, int upper) {
    return globalRand.nextIntRange(lower, upper);
}

double random() {
    return globalRand.nextDouble();
}

//placeholder for now. need a way to know "what is the next random number in the list without using that number"
int seed(Session session) {
    return session.rand.nextInt();
}

int getRandomSeed() {
    return new Random().nextInt();
}

//bool printCorruptionMessage(String msg, String url, String lineNo, String columnNo, String error){
bool printCorruptionMessage(Session session, ErrorEvent e) {
    if(session == null) {
      appendHtml(SimController.instance.storyElement, "ERROR: CRASHING EVEN IN NON SIMULATION. THIS IS STUPID.");
      SimController.instance.recoverFromCorruption(session);
      return false;
    }
    //;
    Element story = SimController.instance.storyElement;

    //String msg = e.message;
    String url = e.path.toString();
    //String lineNo = e.lineno.toString();
    //String columnNo = e.colno.toString();
    //String error = e.toString();

    String recomendedAction = "";
    print(session.stats); //why does it think it's not a grim or cataclym when it clear is sometimes?
    bool timeBug = false;
    bool spacebug = true;
    if(session.players.length > 1) {
        Player space = findAspectPlayer(session.players, Aspects.SPACE);
        spacebug = space == null;
        Player time = findAspectPlayer(session.players, Aspects.TIME);
        timeBug = time == null;
    }
    if (session.stats.crashedFromPlayerActions) {
        appendHtml(story, "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORRORTERROR INFLUENCE: COMPLETE.");
        recomendedAction = "OMFG JUST STOP CRASHING MY DAMN SESSIONS. FUCKING GRIMDARK PLAYERS. BREAKING SBURB DOES NOT HELP ANYBODY! ${mutatorsInPlay(session)}";
    }else if(session.stats.cataclysmCrash) {
        appendHtml(story, "<BR>ERROR: WASTE TIER CATACLYSM ACTIVATED. SESSION HAS CRASHED.");
        recomendedAction = "OMFG YOU ASSHOLE WASTES. GIT GUD.  THERE IS A FUCKING *REASON* RESTRAINT IS PART OF OUR MATURITY QUESTS. (And if somehow a non Waste/Grace managed to cause this much damage, holy fuck, what were you THINKING you maniac?) ${mutatorsInPlay(session)}";
    }else if(session.stats.ringWraithCrash) {
        appendHtml(story, "<BR>ERROR: RED MILES TARGETED UNIVERSE. SESSION HAS CRASHED.");
        recomendedAction = "I MEAN. IF IT GOT THIS BAD YOUR SESSION WAS PROBABLY FUCKED ANYWAYS. DON'T LET RING WRAITHS HAPPEN AND YOU'LL BE FINE. ISH.";
    }else if((session is DeadSession) && session.players.first.aspect == Aspects.JUICE) {
        appendHtml(story, "<BR>ERROR: Hey...Are you okay? You know juice players can't play alone, right?");
        recomendedAction = "You have friends, I promise.${mutatorsInPlay(session)}";

    }else if((session is DeadSession)) {
        appendHtml(
            story, "<BR>ERROR: HAHA YOUR DEAD SESSION CRASHED, ASSHOLE.");
        recomendedAction =
        "OH WELL, NOT LIKE IT WAS EVER SUPPOSED TO BE BEATABLE ANYWAYS. ${mutatorsInPlay(
            session)}";
    }else if (session.players.isEmpty) {
        appendHtml(story, "<BR>ERROR: USELESS 0 PLAYER SESSION DETECTED.");
        recomendedAction = ":/ REALLY? WHAT DID YOU THINK WAS GOING TO HAPPEN HERE??? THE CARAPACES WOULD SOMEHOW BREED A FROG??? ${mutatorsInPlay(session)}";
    } else if (session.players.length < 2 ) {
        appendHtml(story, "<BR>ERROR: DEAD SESSION DETECTED.");
        String url = "dead_index.html?seed=${session.session_id}&${generateURLParamsForPlayers(<Player>[session.players[0]],true)}";
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        url = "$url";
        recomendedAction = "WHOA. IS TODAY THE DAY I LET YOU DO A SPECIAL SNOWFLAKE SINGLE PLAYER SESSION??? <BR><BR><a href = '$url'>PLAY DEAD SESSION?</a><BR><BR>";
    } else if (timeBug) {
        session.stats.crashedFromSessionBug = true;
        appendHtml(story, "<BR>ERROR: TIME PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED");
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A TIME PLAYER, DUNKASS. ${mutatorsInPlay(session)}";
    } else if (spacebug) {
        appendHtml(story, "<BR>ERROR: SPACE PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED. ${mutatorsInPlay(session)}");
        session.stats.crashedFromSessionBug = true;
        recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A SPACE PLAYER, DUNKASS. ${mutatorsInPlay(session)}";
    } else if(session.mutator.effectsInPlay > 0){
        session.stats.cataclysmCrash = true;
        appendHtml(story, "<BR>ERROR: NOW YOU FUCKED UP! YOUR SHITTY HACKED CODE CRASHED.");
        recomendedAction = "OMFG YOU ASSHOLE WASTES. GIT GUD.  FUCKING TEST YOUR SHIT, SCRUB. ${mutatorsInPlay(session)} ";

    }else {
        session.stats.crashedFromSessionBug = true;
        appendHtml(story, "<BR>ERROR: AN ACTUAL BUG IN SBURB HAS CRASHED THE SESSION. THE HORRORTERRORS ARE PLEASED THEY NEEDED TO DO NO WORK. (IF THIS HAPPENS FOR ALL SESSIONS, IT MIGHT BE A BROWSER BUG)");
        recomendedAction = "TRY HOLDING 'SHIFT' AND CLICKING REFRESH TO CLEAR YOUR CACHE. IF THE BUG PERSISTS, CONTACT JADEDRESEARCHER. CONVINCE THEM TO FIX SESSION: ${scratchedLineageText(session.getLineage())}   ${mutatorsInPlay(session)}";

    }
    //var message = ['Message: ' + msg, 'URL: ' + url, 'Line: ' + lineNo, 'Column: ' + columnNo, 'Error object: ' + jsonEncode(error)].join(' - ');
    ////print(message);

    String str = "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR:<br/><br/>";
    appendHtml(story, str);

    DivElement errorDiv = new DivElement();
    errorDiv.style..whiteSpace="pre"..fontFamily="'Courier New', monospace";
    story.append(errorDiv);

    appendHtml(errorDiv, "${e.error.toString().split("\n").first}<br/>");
    //appendHtml(errorDiv, e.error);
    //TODO later find out why this is happening.
    //Tracer.writeTrace(e.error, errorDiv);

    //appendHtml(errorDiv, e.error);

    appendHtml(story, "<br/><br/>ABORTING");

    crashEasterEgg(session,url);

    for (num i = 0; i < session.players.length; i++) {
        Player player = session.players[i];
        str = "<BR>${player.chatHandle}:";
        List<String> rand = <String>["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORRORTERRORS."];
        String start = "<b ";
        String end = "'>";

        String words = session.rand.pickFrom(rand);
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
    renderAfterlifeURL(session);

    //;
    //;
    SimController.instance.recoverFromCorruption(session);
    appendHtml(story,"<h1>IT BEGINS TO DAWN ON YOU. THAT EVERYTHING YOU JUST DID. MAY HAVE BEEN A COLOSSAL WASTE OF TIME. </h1>");
    session.simulationComplete("The session ended in a crash.");
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
    //;
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
  // alert("Error occured: " + e.error.message + " in session: " + session.session_id);
	 //print(e);

   return false;  //what does the return value here mean.;
})
*/

void crashEasterEgg(Session session, String url) {
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
    var convoTangents = session.rand.pickFrom(quips);
    chat += "RS:" + convoTangents + "\n";
    chat += "AB: Yeah, I’m kinda too busy simulating hundreds of sessions right now to deal with this.  I’ll catch you again when I’m not busy, which is never, since flawless machines like myself are always making themselves useful.  Bye. \n";

    Drawing.drawChatNonPlayer(canvas, chat, "-- recursiveSlacker [RS] began pestering authorBot" + " [AB] --", "Credits/recursiveSlacker.png", "ab.png", "RS:", "AB:", "#000066", "#ff0000");
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

void appendHtml(Element element, String html, [bool force = false]) {
    //TODO does this break anything?
    if(!(SimController.instance is AuthorBot) || force) {
        element.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted,validator: new NodeValidatorBuilder()..allowElement("span"));
    }else {
       // ;
    }
}



void setHtml(Element element, String html) {
    element.setInnerHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
}

void renderAfterlifeURL(Session session) {
    if (!session.afterLife.ghosts.isEmpty) {
        stopTime = new DateTime.now();
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "<Br><br><a href = 'rip.html?${generateURLParamsForPlayers(session.afterLife.ghosts, false)}' target='_blank'>View Afterlife In New Tab?</a>";
        html = '$html<br><br><a href = "character_creator.html?seed=${session.session_id}&$params" target="_blank">Replay Session </a> ';
        html = "$html<br><br><a href = 'index2.html'>Random New Session?</a>";
        html = '$html<br><br><a href = "index2.html?seed=${session.session_id}&$params" target="_blank">Shareable URL </a> ';
        html = "$html<Br><Br>Simulation took: ${msToTime(stopTime.difference(startTime))} to render. ";
        ;
        ////print("gonna append: " + html);
        SimController.instance.storyElement.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    } else {
        stopTime = new DateTime.now();
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";

        String html = "";
        html += '<br><br><a href = "character_creator.html?seed=' + session.session_id.toString() + '&' + params + ' " target="_blank">Replay Session </a> ';
        html += "<br><br><a href = 'index2.html'>Random New Session?</a>";
        html += '<br><br><a href = "index2.html?seed=' + session.session_id.toString() + '&' + params + ' " target="_blank">Shareable URL </a> ';
        html += "<Br><Br>Simulation took: " + msToTime(stopTime.difference(startTime)) + " to render. ";
        ////print("gonna append: " + html);
        SimController.instance.storyElement.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
    }
}

