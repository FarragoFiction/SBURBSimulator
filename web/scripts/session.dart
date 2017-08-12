import "dart:html";

import "SBURBSim.dart";

//okay, fine, yes, global variables are getting untenable.
class Session {
    int session_id; //initial seed
    //var sceneRenderingEngine = new SceneRenderingEngine(false); //default is homestuck  //comment this line out if need to run sim without it crashing
    List<Player> players = <Player>[];
    FraymotifCreator fraymotifCreator = new FraymotifCreator(); //as long as FraymotifCreator has no state data, this is fine.
    //TODO all these "session summary stats" things should just be a SessionSummary object I own.
    bool hasClubs = false;
    num sessionHealth = 500; //grimDark players work to lower it. at 0, it crashes.  maybe have it do other things at other levels, or effect other things.
    bool hasDiamonds = false;
    bool opossumVictory = false;
    bool hasBreakups = false; //sessions aren't in charge of denizens anymore, they are for players and set when they get in the medium
    List<Player> replayers = <Player>[]; //used for fan oc easter eggs.
    AfterLife afterLife = new AfterLife();
    GameEntity queensRing = null; //eventually have white and black ones.
    GameEntity kingsScepter = null;
    bool janusReward = false;
    bool badBreakDeath = false;
    bool jackGotWeapon = false;
    bool jackRampage = false;
    bool jackScheme = false;
    bool luckyGodTier = false;
    bool choseGodTier = false;
    bool plannedToExileJack = false;
    bool hasHearts = false;
    bool hasSpades = false;
    bool rocksFell = false;
    bool denizenBeat = false; //session no longer keeps track of guardians.
    //TODO eventually NPC engine will be responsible for these
    GameEntity king = null;
    GameEntity queen = null;
    GameEntity jack = null;
    num numScenes = 0;
    bool rapBattle = false;
    bool crashedFromSessionBug = false; //gets corrupted if an unrecoverable error gets caught.
    bool crashedFromPlayerActions = false;
    bool sickFires = false;
    bool dreamBubbleAfterlife = false;
    GameEntity democraticArmy = null;
    bool sbahj = false;
    bool heroicDeath = false;
    bool won = false;
    bool justDeath = false;
    bool mayorEnding = false;
    bool waywardVagabondEnding = false;
    num hardStrength = 1000;
    num minFrogLevel = 18;
    num goodFrogLevel = 28;
    bool reckoningStarted = false;
    List<Player> aliensClonedOnArrival = <Player>[]; //if i'm gonna do time shenanigans, i need to know what the aliens were like when they got here.
    bool murdersHappened = false;
    bool queenRejectRing = false;
    bool goodLuckEvent = false;
    bool badLuckEvent = false;
    bool hasFreeWillEvents = false;
    bool ectoBiologyStarted = false;
    bool doomedTimeline = false;
    bool makeCombinedSession = false; //happens if sick frog and few living players
    bool scratched = false;
    bool scratchAvailable = false;
    num timeTillReckoning = 0;
    num reckoningEndsAt = -15;
    bool godTier = false;
    bool grimDarkPlayers = false;
    bool questBed = false;
    bool sacrificialSlab = false;
    num sessionType = -999;
    List<String> doomedTimelineReasons = <String>[]; //am I even still using this?
    num currentSceneNum = 0;
    List<Scene> scenes = <Scene>[]; //scene controller initializes all this.
    List<Scene> reckoningScenes = <Scene>[];
    List<Scene> deathScenes = <Scene>[];
    List<Scene> available_scenes = <Scene>[];
    bool hadCombinedSession = false;
    Session parentSession = null;
    List<Player> availablePlayers = <Player>[]; //which players are available for scenes or whatever.
    List<ImportantEvent> importantEvents = <ImportantEvent>[];
    bool yellowYard = false;
    YellowYardResultController yellowYardController = new YellowYardResultController(); //don't expect doomed time clones to follow them to any new sessions

    // extra fields
    bool crashedFromCustomShit = false;
    num democracyStrength = 0;
    Random rand;


    Session(int this.session_id) {
        this.rand = new Random(session_id);
    }

    //  //makes copy of player list (no shallow copies!!!!)
    List<Player> setAvailablePlayers(List<Player> playerList) {
        this.availablePlayers = <Player>[];
        for (num i = 0; i < playerList.length; i++) {
            //dead players are always unavailable.
            if (!playerList[i].dead) {
                this.availablePlayers.add(playerList[i]);
            }
        }
        return this.availablePlayers;
    }

    //used to live in scene controller but fuck that noise (also used to be named processScenes2)
    void processScenes(List<Player> playersInSession) {
        //print("processing scene");
        //querySelector("#story").append("processing scene");
        setAvailablePlayers(playersInSession);
        for (num i = 0; i < this.available_scenes.length; i++) {
            Scene s = this.available_scenes[i];
            //var debugQueen = queenStrength;
            if (s.trigger(playersInSession)) {
                //session.scenesTriggered.add(s);
                this.numScenes ++;
                s.renderContent(this.newScene());
                if (!s.canRepeat) {
                    //removeFromArray(s,session.available_scenes);
                    this.available_scenes.remove(s);
                }
            }
        }

        for (num i = 0; i < this.deathScenes.length; i++) {
            Scene s = this.deathScenes[i];
            if (s.trigger(playersInSession)) {
                //	session.scenesTriggered.add(s);
                this.numScenes ++;
                s.renderContent(this.newScene());
            }
        }
    }

    void processReckoning(List<Player> playerList) {
        for (num i = 0; i < this.reckoningScenes.length; i++) {
            Scene s = this.reckoningScenes[i];
            if (s.trigger(playerList)) {
                //session.scenesTriggered.add(s);
                this.numScenes ++;
                s.renderContent(this.newScene());
            }
        }

        for (num i = 0; i < this.deathScenes.length; i++) {
            Scene s = this.deathScenes[i];
            if (s.trigger(playerList)) {
                //	session.scenesTriggered.add(s);
                this.numScenes ++;
                s.renderContent(this.newScene());
            }
        }
    }


    void destroyBlackRing() {
        this.queensRing = null;
        this.jack.crowned = null;
        this.queen.crowned = null;
    }

    Player findBestSpace() {
        List<Player> spaces = findAllAspectPlayers(this.players, "Space");
        if (spaces.isEmpty) return null;
        Player ret = spaces[0];
        for (num i = 0; i < spaces.length; i++) {
            if (spaces[i].landLevel > ret.landLevel) ret = spaces[i];
        }
        return ret;
    }

    Player findMostCorruptedSpace() {
        List<Player> spaces = findAllAspectPlayers(this.players, "Space");
        if (spaces.isEmpty) return null;
        Player ret = spaces[0];
        for (num i = 0; i < spaces.length; i++) {
            if (spaces[i].landLevel < ret.landLevel) ret = spaces[i];
        }
        return ret; //lowest space player.
    }

    ImportantEvent addImportantEvent(ImportantEvent important_event) {
        ImportantEvent alternate = this.yellowYardController.doesEventNeedToBeUndone(important_event);
        //	print("alternate i got from yellowYardController is: " + alternate);
        if (alternate != null) {
            //	print("returning alternate");
            if (doEventsMatch(important_event, this.afterLife.timeLineSplitsWhen, false)) this.afterLife.allowTransTimeLineInteraction();
            return alternate; //scene will use the alternate to go a different way. important event no longer happens.
        } else {
            //print(" pushing important event and returning null");
            this.importantEvents.add(important_event);
            return null;
        }
    }

    String frogStatus() {
        Player spacePlayer = this.findBestSpace();
        Player corruptedSpacePlayer = this.findMostCorruptedSpace();
        //var spacePlayer = findAspectPlayer(this.players, "Space");
        if (corruptedSpacePlayer != null && corruptedSpacePlayer.landLevel <= this.goodFrogLevel * -1) return "Purple Frog"; //is this...a REFRANCE???
        if (spacePlayer == null || spacePlayer.landLevel < this.minFrogLevel) {
            return "No Frog";
        } else if (spacePlayer.landLevel > this.goodFrogLevel) {
            return "Full Frog";
        } else {
            return "Sick Frog";
        }
    }

    void addEventToUndoAndReset(ImportantEvent e) {
        //when I reset, need things to go the same. that includes having no ghosts interact with the session. figure out how to renable them once my event happens again.
        this.afterLife.complyWithLifeTimeShenanigans(e);
        //print("undoing an event.");
        if (this.scratched) {
            this.addEventToUndoAndResetScratch(e); //works different
            return;
        }
        if (e != null) { //will be null if undoing an undo
            this.yellowYardController.eventsToUndo.add(e);
        }
        //reinit the seed and restart the session
        //var savedPlayers = curSessionGlobalVar.players;
        this.reinit();
        Scene.createScenesForSession(curSessionGlobalVar);
        //players need to be reinit as well.
        curSessionGlobalVar.makePlayers();
        curSessionGlobalVar.randomizeEntryOrder();
        curSessionGlobalVar.makeGuardians(); //after entry order established
        checkEasterEgg(this.easterCallBack, this); //in the controller.

        return;
    }

    void easterCallBack(Session that) {
        //now that i've done that, (for seed reasons) fucking ignore it and stick the actual players in
        //after alll, i could be from a combo session.
        //but don't just hardcore replace. need to...fuck. okay, cloning aliens now.
        curSessionGlobalVar.aliensClonedOnArrival = that.aliensClonedOnArrival;
        //print("adding this many clone aliens: " + curSessionGlobalVar.aliensClonedOnArrival.length);
        //print(getPlayersTitles(curSessionGlobalVar.aliensClonedOnArrival));
        List<Player> aliens = <Player>[]; //if don't make copy of aliensClonedOnArrival, goes into an infinite loop as it loops on it and adds to it inside of addAliens;
        for (num i = 0; i < that.aliensClonedOnArrival.length; i++) {
            aliens.add(that.aliensClonedOnArrival[i]);
        }
        that.aliensClonedOnArrival = <Player>[]; //jettison old clones.
        addAliensToSession(curSessionGlobalVar, aliens);

        SimController.instance.restartSession(); //in controller
    }

    void addEventToUndoAndResetScratch(ImportantEvent e) {
        print('yellow yard from scratched session');
        if (e != null) { //will be null if undoing an undo
            this.yellowYardController.eventsToUndo.add(e);
        }
        bool ectoSave = this.ectoBiologyStarted;
        reinit();
        //use seeds the same was as original session and also make DAMN sure the players/guardians are fresh.
        curSessionGlobalVar.makePlayers();
        curSessionGlobalVar.randomizeEntryOrder();
        curSessionGlobalVar.makeGuardians(); //after entry order established
        this.ectoBiologyStarted = ectoSave;
        this.scratched = true;
        this.switchPlayersForScratch();


        SimController.instance.restartSession(); //in controller
    }

    Session initializeCombinedSession() {
        this.aliensClonedOnArrival = <Player>[]; //PROBABLY want to do this.
        List<Player> living = findLivingPlayers(this.players);
        //nobody is the leader anymore.
        Session newSession = new Session(this.rand.nextInt()); //Math.seed);  //this is a real session that could have gone on without these new players.
        newSession
            ..currentSceneNum = this.currentSceneNum
            ..afterLife = this.afterLife //afterlife carries over.
            ..dreamBubbleAfterlife = this.dreamBubbleAfterlife //this, too
            ..reinit()
            ..makePlayers()
            ..randomizeEntryOrder()
            ..makeGuardians();
        if (living.length + newSession.players.length > 12) {
            //print("New session " + newSession.session_id +" cannot support living players. Already has " + newSession.players.length + " and would need to add: " + living.length);
            return null; //their child session is not able to support them
        }
        //	print("about to add: " + living.length + " aliens to new session.");
        //print(getPlayersTitles(living));
        addAliensToSession(newSession, this.players); //used to only bring players, but that broke shipping. shipping is clearly paramount to Skaia, because everything fucking crashes if shipping is compromised.

        this.hadCombinedSession = true;
        newSession.parentSession = this;
        Scene.createScenesForSession(newSession);
        //print("Session: " + this.session_id + " has made child universe: " + newSession.session_id + " child has this long till reckoning: " + newSession.timeTillReckoning);
        return newSession;
    }

    Player getVersionOfPlayerFromThisSession(Player player) {
        //can double up on classes or aspects if it's a combo session. god. why are their combo sessions?
        for (num i = 0; i < this.players.length; i++) {
            Player p = this.players[i];
            if (p.class_name == player.class_name && p.aspect == player.aspect) {
                return p; //yeah, technically there COULD be two players with the same claspect in a combo session, but i have ceased caring.
            }
        }
        print("Error finding session's: ${player.title()}");
        return null;
    }

    void reinit() {
        //Math.seed = this.session_id; //if session is reset,
        this.rand.setSeed(this.session_id);
        //print("reinit with seed: "  + Math.seed);
        this.timeTillReckoning = this.rand.nextIntRange(10, 30); //rand.nextIntRange(10,30);
        this.sessionType = this.rand.nextDouble(); //rand.nextDouble();
        this.available_scenes = <Scene>[]; //need a fresh slate because UpdateShippingGrid has MEMORY unlike all other scenes.
        Scene.createScenesForSession(this);
        //curSessionGlobalVar.available_scenes = curSessionGlobalVar.scenes.slice(0);
        //curSessionGlobalVar.doomedTimeline = false;
        this.doomedTimeline = false;
        this.setUpBosses();
        this.democracyStrength = 0;
        this.reckoningStarted = false;
        this.importantEvents = <ImportantEvent>[];
        this.rocksFell = false; //sessions where rocks fell screw over their scratched and yarded iterations, dunkass
        this.doomedTimelineReasons = <String>[];
        this.ectoBiologyStarted = false;
    }

    void makePlayers() {
        //print("Making players with seed: " + Math.seed);
        this.players = <Player>[];
        available_classes = classes.sublist(0); //re-initPlayers available classes.
        available_classes_guardians = classes.sublist(0);
        available_aspects = nonrequired_aspects.sublist(0);
        int numPlayers = this.rand.nextIntRange(2, 12); //rand.nextIntRange(2,12);
        this.players.add(randomSpacePlayer(this));
        this.players.add(randomTimePlayer(this));

        for (int i = 2; i < numPlayers; i++) {
            this.players.add(randomPlayer(this));
        }

        for (num j = 0; j < this.players.length; j++) {
            Player p = this.players[j];
            p.generateRelationships(this.players);
        }

        Relationship.decideInitialQuadrants(rand, this.players);

        this.hardStrength = 1000 + 50 * this.players.length;
    }

    String convertPlayerNumberToWords() {
        //alien players don't count
        List<Player> ps = findPlayersFromSessionWithId(this.players, this.session_id);
        if (ps.isEmpty) {
            ps = this.players;
        }
        int length = ps.length;
        if (length == 2) {
            return "TWO";
        } else if (length == 3) {
            return "THREE";
        } else if (length == 4) {
            return "FOUR";
        } else if (length == 5) {
            return "FIVE";
        } else if (length == 6) {
            return "SIX";
        } else if (length == 7) {
            return "SEVEN";
        } else if (length == 8) {
            return "EIGHT";
        } else if (length == 9) {
            return "NINE";
        } else if (length == 10) {
            return "TEN";
        } else if (length == 11) {
            return "ELEVEN";
        } else if (length == 12) {
            return "TWELVE";
        } else {
            return "???";
        }
    }

    void makeGuardians() {
        //print("Making guardians");
        available_classes = new List<String>.from(classes);
        available_aspects = new List<String>.from(nonrequired_aspects);
        available_aspects.addAll(new List<String>.from(required_aspects));
        List<Player> guardians = <Player>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            player.makeGuardian();
            guardians.add(player.guardian);
        }

        for (num j = 0; j < this.players.length; j++) {
            Player g = this.players[j].guardian;
            g.generateRelationships(guardians);
        }
        Relationship.decideInitialQuadrants(rand, guardians);
    }

    void randomizeEntryOrder() {
        this.players = shuffle(this.rand, this.players);
        this.players[0].leader = true;
    }

    void switchPlayersForScratch() {
        //var tmp = curSessionGlobalVar.players;
        //curSessionGlobalVar.players = curSessionGlobalVar.guardians;
        //curSessionGlobalVar.guardians = tmp;
        List<Player> nativePlayers = findPlayersFromSessionWithId(this.players, this.session_id);
        //print(nativePlayers);
        List<Player> guardians = getGuardiansForPlayers(nativePlayers);
        this.players = guardians;
    }

    String getSessionType() {
        if (this.sessionType > .6) {
            return "Human";
        } else if (this.sessionType > .3) {
            return "Troll";
        }
        return "Mixed";
    }

    void setUpBosses() {
        this.queensRing = new GameEntity("!!!RING!!! OMG YOU SHOULD NEVER SEE THIS!", this);
        Fraymotif f = new Fraymotif(<String>[], "Red Miles", 3);
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.flavorText = " You cannot escape them ";
        this.queensRing.fraymotifs.add(f);

        this.kingsScepter = new GameEntity("!!!SCEPTER!!! OMG YOU SHOULD NEVER SEE THIS!", this);
        f = new Fraymotif(<String>[], "Reckoning Meteors", 3); //TODO eventually check for this fraymotif (just lik you do troll psionics) to decide if you can start recknoing.;
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.flavorText = " The very meteors from the Reckoning rain down. ";
        this.kingsScepter.fraymotifs.add(f);

        this.king = new Carapace("The Black King", this);
        this.king.crowned = this.kingsScepter;

        king.grist = 1000;
        king.setStatsHash(<String, num>{"hp": 1000, "freeWill": -100, "power": 100});
        this.queen = new Carapace("The Black Queen", this);
        this.queen.crowned = this.queensRing;
        queen.setStatsHash(<String, num>{"hp": 500, "freeWill": -100, "power": 50});


        this.jack = new Carapace("Jack", this);
        //minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
        jack.setStatsHash(<String, num>{"minLuck": -500, "maxLuck": 10, "sanity": -100, "hp": 20, "freeWill": -100, "power": 30});
        f = new Fraymotif(<String>[], "Stab To Meet You", 1);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.flavorText = " It's pretty much how he says 'Hello'. ";
        this.jack.fraymotifs.add(f);

        this.democraticArmy = new Carapace("Democratic Army", this); //doesn't actually exist till WV does his thing.
        f = new Fraymotif(<String>[], "Democracy Charge", 2);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.flavorText = " The people have chosen to Rise Up against their oppressors. ";
        this.democraticArmy.fraymotifs.add(f);
    }

    @override
    String toString() {
        return "$session_id";
    }

    Element newScene() {
        this.currentSceneNum ++;
        String div;
        if (this.sbahj) {
            div = "<div class = 'scene' id='scene${this.currentSceneNum}' style='";
            div = "${div}background-color: #00ff00;";
            div = "${div}font-family: Comic Sans MS, cursive, sans-serif;";
            //querySelector("#scene"+this.currentSceneNum).css("background-color", "#00ff00");
            int reallyRand = getRandomIntNoSeed(1, 10);
            for (int i = 0; i < reallyRand; i++) {
                int indexOfTerribleCSS = getRandomIntNoSeed(0, terribleCSSOptions.length - 1);
                List<String> tin = terribleCSSOptions[indexOfTerribleCSS];
                if (tin[1] == "????") {
                    tin[1] = "${getRandomIntNoSeed(1, 100)}%";
                }
                div = "$div${tin[0]}${tin[1]};";
            }
            div = "$div' >";
            if (ouija == true) div = "$div<img class = 'pen15' src = 'images/pen15_bg1.png'>"; //can't forget the dicks;
            div = "$div</div>";
        } else if (ouija == true) {
            int trueRandom = getRandomIntNoSeed(1, 4);
            div = "<div class = 'scene' id='scene${this.currentSceneNum}'>";
            div = "$div<img class = 'pen15' src = 'images/pen15_bg$trueRandom.png'>";
            div = "$div</div>";
        } else {
            div = "<div class = 'scene' id='scene${this.currentSceneNum}'></div>";
        }
        appendHtml(querySelector("#story"), div);
        return querySelector("#scene${this.currentSceneNum}");
    }

    List<Session> getLineage() {
        print("Getting lineage for session: $session_id");
        if (this.parentSession != null) {
            List<Session> tmp = this.parentSession.getLineage();
            tmp.add(this);
            return tmp;
        }
        return <Session>[this];
    }

    SessionSummary generateSummary() {
        return SessionSummary.makeSummaryForSession(this);
    }

}

//save a copy of the alien (in case of yellow yard)
void addAliensToSession(Session newSession, List<Player> aliens) {
    //print("in method, adding aliens to session");
    for (num i = 0; i < aliens.length; i++) {
        Player survivor = aliens[i];
        survivor.land = null;
        survivor.dreamSelf = false;
        survivor.godDestiny = false;
        survivor.leader = false;
    }
    //save a copy of the alien players in case this session has time shenanigans happen

    for (num i = 0; i < aliens.length; i++) {
        Player survivor = aliens[i];
        newSession.aliensClonedOnArrival.add(clonePlayer(survivor, newSession, false));
    }
    //don't want relationships to still be about original players
    for (num i = 0; i < newSession.aliensClonedOnArrival.length; i++) {
        Player clone = newSession.aliensClonedOnArrival[i];
        Relationship.transferFeelingsToClones(clone, newSession.aliensClonedOnArrival);
    }
    //print("generated relationships between clones");
    //generate relationships AFTER saving a backup of hte player.
    //want clones to only know about other clones. not players.
    for (num i = 0; i < aliens.length; i++) {
        Player survivor = aliens[i];
        //print(survivor.title() + " generating relationship with new players ")
        survivor.generateRelationships(newSession.players); //don't need to regenerate relationship with your old friends
    }


    for (int j = 0; j < newSession.players.length; j++) {
        Player player = newSession.players[j];
        player.generateRelationships(aliens);
    }

    for (num i = 0; i < aliens.length; i++) {
        for (int j = 0; j < newSession.players.length; j++) {
            Player player = newSession.players[j];
            Player survivor = aliens[i];
            //survivors have been talking to players for a very long time, because time has no meaning between univereses.
            Relationship r1 = survivor.getRelationshipWith(player);
            Relationship r2 = player.getRelationshipWith(survivor);
            r1.moreOfSame();
            r1.moreOfSame();
            //been longer from player perspective
            r2.moreOfSame();
            r2.moreOfSame();
            r2.moreOfSame();
            r2.moreOfSame();
        }
    }

    newSession.players.addAll(aliens);
}
