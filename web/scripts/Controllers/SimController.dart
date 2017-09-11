import "dart:html";
import '../GameEntities/Stats/sampler/statsampler.dart';
import "../SBURBSim.dart";
import "../navbar.dart";
/*
  Each way the sim is able to be used inherits from this abstract class.

  Things that inherit from this are set to a static singleton var here.

  The SBURBSim library knows about this, and ONLY this, while the controllers inherit from this and control running the sim.

 */

//StoryController inherits from this
//ABController inherits from Story Controller and only changes what she must.
//care about other controllers later.
abstract class SimController {
    static SimController instance;
    num initial_seed = 0;

    bool gatherStatData = false;
    StatSampler statData;

    SimController() {
        SimController.instance = this;

        if (getParameterByName("gatherStatData") == "true") {
            gatherStatData = true;
            statData = new StatSampler();
            statData.createSaveButton();
        }
    }

    void callNextIntro(int player_index) {
        if (player_index >= curSessionGlobalVar.players.length) {
            tick(); //NOW start ticking
            return;
        }
        Intro s = new Intro(curSessionGlobalVar);
        Player p = curSessionGlobalVar.players[player_index];
        //var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
        List<Player> playersInMedium = curSessionGlobalVar.players.sublist(0, player_index + 1);
        s.trigger(playersInMedium, p);
        s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString()), player_index); //new scenes take care of displaying on their own.
        curSessionGlobalVar.processScenes(playersInMedium);
        //player_index += 1;
        //new Timer(new Duration(milliseconds: 10), () => callNextIntro(player_index)); //sweet sweet async
        this.gatherStats();
        window.requestAnimationFrame((num t) => callNextIntro(player_index + 1));
    }

    void checkSGRUB() {
        bool sgrub = true;
        for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
            if (curSessionGlobalVar.players[i].isTroll == false) {
                sgrub = false;
            }
        }
        //can only get here if all are trolls.
        if (sgrub) {
            document.title = "SGRUB Story Generator by jadedResearcher";
        }

        if (getParameterByName("nepeta", null) == ":33") {
            document.title = "NepetaQuest by jadedResearcher";
        }
        if (curSessionGlobalVar.session_id == 33) {
            document.title = "NepetaQuest by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&nepeta=:33'>The furryocious huntress makes sure to bat at this link to learn a secret!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 420) {
            document.title = "FridgeQuest by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&honk=:o)'>wHoA. lIkE. wHaT If yOu jUsT...ReAcHeD OuT AnD ToUcHeD ThIs? HoNk!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 88888888) {
            document.title = "SpiderQuuuuuuuuest!!!!!!!! by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&luck=AAAAAAAALL'>Only the BEST Observers click here!!!!!!!!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 0) {
            document.title = "0_0 by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&temporal=shenanigans'>Y0ur inevitabile clicking here will briefly masquerade as free will, and I'm 0kay with it.</a>");
        } else if (curSessionGlobalVar.session_id == 413) { //why the hell is this one not triggering?
            "Homestuck Simulator by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&home=stuck'>A young man stands next to a link. Though it was 13 years ago he was given life, it is only today he will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 111111) { //why the hell is this one not triggering?
            document.title = "Homestuck Simulator by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&home=stuck'>A young lady stands next to a link. Though it was 16 years ago she was given life, it is only today she will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 613) {
            document.title = "OpenBound Simulator by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&open=bound'>Rebubble this link?.</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        } else if (curSessionGlobalVar.session_id == 612) {
            document.title = "HiveBent Simulator by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&hive=bent'>A young troll stands next to a click horizon. Though it was six solar sweeps ago that he was given life, it is only today that he will click it.</a>");
        } else if (curSessionGlobalVar.session_id == 1025) {
            document.title = "Fruity Rumpus Asshole Simulator by jadedResearcher";
            querySelector("#story").appendHtml(" <a href = 'index2.html?seed=${getRandomSeed()}&rumpus=fruity'>I will have order in this RumpusBlock!!!</a>", treeSanitizer: NodeTreeSanitizer.trusted);
        }
    }

    void easterEggCallBack() {
        initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //will take care of overriding players if need be.
        checkSGRUB();
        if (doNotRender == true) {
            intro();
        } else {
            load(curSessionGlobalVar.players, getGuardiansForPlayers(curSessionGlobalVar.players), ""); //in loading.js
        }
    }

    void easterEggCallBackRestart() {
        initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar); //initializePlayers
        intro(); //<-- instead of load, bc don't need to load.

    }

    void intro() {
        initGatherStats();
        createInitialSprites();
        //advertisePatreon(querySelector("#story"));
        callNextIntro(0);
    }

    void createInitialSprites() {
        //print("players: ${curSessionGlobalVar.players}");
        for (num i = 0; i < curSessionGlobalVar.players.length; i++) {
            Player player = curSessionGlobalVar.players[i];
            player.renderSelf();
        }
    }

    void processCombinedSession() {
        if(curSessionGlobalVar.mutator.spaceField) {
            return; //you will do combo a different route.
        }
        Session tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
        if (tmpcurSessionGlobalVar != null) {
            doComboSession(tmpcurSessionGlobalVar);
        } else {
            //scratch fuckers.
            curSessionGlobalVar.stats.makeCombinedSession = false; //can't make a combo session, and skiaia is a frog so no scratch.
            renderAfterlifeURL();
            //renderScratchButton(curSessionGlobalVar);
        }
    }

    void doComboSession(Session tmpcurSessionGlobalVar) {
        if(tmpcurSessionGlobalVar == null) tmpcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();  //if space field this ALWAYS returns something. this should only be called on null with space field
        curSessionGlobalVar = tmpcurSessionGlobalVar;
        //maybe ther ARE no corpses...but they are sure as shit bringing the dead dream selves.
        List<Player> living = findLivingPlayers(curSessionGlobalVar.aliensClonedOnArrival);
        if(living.isEmpty) {
            appendHtml(querySelector("#story"), "<br><Br>You feel a nauseating wave of space go over you. What happened? Wait. Fuck. That's right. The Space Player made it so that they could enter their own child Session. But. Fuck. Everybody is dead. This...god. Maybe...maybe the other Players can revive them? ");
        }else {
            appendHtml(querySelector("#story"), "<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Their sick frog may have screwed them over, but the connection it provides to their child universe will equally prove to be their salvation. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session <a href = 'index2.html?seed=${curSessionGlobalVar.session_id}'>${curSessionGlobalVar.session_id}</a>. You are a little scared to ask them why they are bringing the corpses with them. Something about...shipping??? That can't be right.");
        }
        checkSGRUB();
        if(curSessionGlobalVar.mutator.spaceField) {
            window.scrollTo(0, 0);
            querySelector("#charSheets").setInnerHtml("");
            querySelector("#story").setInnerHtml("You feel a nauseating wave of space go over you. What happened? Huh. Is that.... a new session? How did the Players get here? Are they joining it? Will...it...even FIT having ${curSessionGlobalVar.players.length} fucking players inside it? ");
        }
        load(curSessionGlobalVar.players, <Player>[], ""); //in loading.js
    }

    void reckoning() {
        ////print('reckoning');
        Scene s = new Reckoning(curSessionGlobalVar);
        s.trigger(curSessionGlobalVar.players);
        s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString(),));
        if (!curSessionGlobalVar.stats.doomedTimeline) {
            reckoningTick();
        } else {
            renderAfterlifeURL();
        }
    }

    void reckoningTick([num time]) {
        ////print("Reckoning Tick: " + curSessionGlobalVar.timeTillReckoning);
        if (curSessionGlobalVar.timeTillReckoning > -10) {
            curSessionGlobalVar.timeTillReckoning += -1;
            curSessionGlobalVar.processReckoning(curSessionGlobalVar.players);
            this.gatherStats();
            window.requestAnimationFrame(reckoningTick);
            //new Timer(new Duration(milliseconds: 10), () => reckoningTick()); //sweet sweet async
        } else {
            Scene s = new Aftermath(curSessionGlobalVar);
            s.trigger(curSessionGlobalVar.players);
            s.renderContent(curSessionGlobalVar.newScene(s.runtimeType.toString(), true));
            if (curSessionGlobalVar.stats.makeCombinedSession == true) {
                processCombinedSession(); //make sure everything is done rendering first
            } else {
                renderAfterlifeURL();
            }
            this.gatherStats();
        }
    }

    void recoverFromCorruption() {
        if(curSessionGlobalVar != null) curSessionGlobalVar.mutator.renderEndButtons(querySelector("#story"));
        if(curSessionGlobalVar != null) curSessionGlobalVar.stats.doomedTimeline = true; //TODO do i really need this, but the sim sometimes tries to keep running after grim crashes
        //print("Other controllers will do something after corruption, but the sim just ends.");
    }

    void reinit() {
        curSessionGlobalVar.reinit();
    }

    void renderScratchButton(Session session) {
        Player timePlayer = findAspectPlayer(curSessionGlobalVar.players, Aspects.TIME);
        if (timePlayer == null) throw "CAN'T SCRATCH WITHOUT A TIME PLAYER, JACKASS";
        //print("scratch possible, button");
        //alert("scratch [possible]");
        //can't scratch if it was a a total party wipe. just a regular doomed timeline.
        List<Player> living = findLivingPlayers(session.players);
        if (!living.isEmpty && (session.stats.makeCombinedSession == false && session.stats.hadCombinedSession == false)) {
            //print("gonna render scratch");
            //var timePlayer = findAspectPlayer(session.players, "Time");
            if (!session.stats.scratched) {
                //this is apparently spoilery.
                //alert(living.length  + " living players and the " + timePlayer.land + " makes a scratch available!");
                if (session.stats.scratchAvailable) {
                    String html = '<img src="images/Scratch.png" id="scratchButton"><br>Click To Scratch Session?';
                    appendHtml(querySelector("#story"), html);
                    querySelector("#scratchButton").onClick.listen((Event e) => scratchConfirm());
                    renderAfterlifeURL();
                }
            } else {
                //print("no more scratches");
                appendHtml(querySelector("#story"), "<br>This session is already scratched. No further scratches available.");
                renderAfterlifeURL();
            }
        } else {
            //print("what went wrong? is makecomo?${session.makeCombinedSession}is all dead: ${living.length} is had combo? ${session.hadCombinedSession}");
        }
    }

    void scratchConfirm() {
        bool scratchConfirmed = window.confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
        if (scratchConfirmed) {
            scratch();
        }
    }

    void restartSession() {
        setHtml(querySelector("#story"), '<canvas id="loading" width="1000" height="354"> ');
        window.scrollTo(0, 0);
        checkEasterEgg(easterEggCallBackRestart, null);
    }

    void shareableURL() {
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        String str = '<div class = "links"><a href = "index2.html?seed=$initial_seed&$params">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href = "character_creator.html?seed$initial_seed&$params" target="_blank">Replay Session  </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp<a href = "index2.html">Random Session URL </a> </div>';
        setHtml(querySelector("#seedText"), str);
        querySelector("#story").appendHtml("Session: $initial_seed", treeSanitizer: NodeTreeSanitizer.trusted);
    }

    void startSession() {
        globalInit(); // initialise classes and aspects if necessary


        // //print("Debugging AB: Starting session $initial_seed");
        curSessionGlobalVar = new Session(initial_seed);
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

    void tick([num time]) {
        ////print("Debugging AB: tick");
        ////print("Tick: " + curSessionGlobalVar.timeTillReckoning);
        if (curSessionGlobalVar.timeTillReckoning > 0 && !curSessionGlobalVar.stats.doomedTimeline) {
            curSessionGlobalVar.timeTillReckoning += -1;
            curSessionGlobalVar.processScenes(curSessionGlobalVar.players);
            this.gatherStats();
            window.requestAnimationFrame(tick);
            ////print("pastJR: I am going to annoy you until you make this animation frames instead of timers");
            //new Timer(new Duration(milliseconds: 10), tick); //timer is to get that sweet sweet asynconinity back, so i don't have to wait for EVERYTHING to be done to see anything.
        } else {
            ////print("Debugging AB: reckoning time.");
            reckoning();
        }
    }

    void gatherStats() {
        if (gatherStatData) {
            statData.sample(curSessionGlobalVar);
        }
    }

    void initGatherStats() {
        if (gatherStatData) {
            statData.resetTurns();
        }
    }
}