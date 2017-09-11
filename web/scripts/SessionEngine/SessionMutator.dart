import "../SBURBSim.dart";
import "dart:html";

//this should handle the most severe of the Gnosis Tiers: The Waste Tier
//these are permanent modifications to sessions and their behavior
//while the lesser shit that are one off things will be in the GainGnosis scenes themselves. (such as writing faqs)
class SessionMutator {
    int effectsInPlay = 0; //more there are, more likely session will crash.
    bool hopeField = false; //facts about session change
    bool breathField = false; //sets availability to true, will interact with npc quests eventually
    bool heartField = false; //disallows breakups, 'random' relationships are 333, and reasons to date someone is 333 for shipping
    bool voidField = false; //has newScenes be added to a custom div instead of $story. newScene will clear that div constantly
    bool lightField = false; //returns light player instead of whoever was asked for in most cases
    bool bloodField = false; //lets pale conversations happen no matter the quadrant. let's non-heroes join, too. and interaction effects.
    bool lifeField = false; //makeDead does nothing, all dead things are brought back.
    bool doomField = false; //causes dead players to be treated as live ones.
    bool rageField = false; //rage can always find victim, and murderMode is always full strife. fraymotif effects aren't cleared at end of fight, shenannigans for everyone
    bool mindField = false; //controls how yellow yards work, mostly only in conjunction with the yellow yard created here. also messes with freeWillScenes.
    bool timeField = false; //means time player will be replacing their past self. basically 100% of time's effect.
    bool spaceField = false; //exclusively controls combo endings .

    static SessionMutator _instance;
    bool rapsAndLuckDisabled = false;
    num timeTillReckoning = 0;
    num gameEntityMinPower = 1;
    num reckoningEndsAt = -15;
    bool ectoBiologyStarted = false;
    num hardStrength = 1000;
    num minFrogLevel = 13;
    num goodFrogLevel = 20;
    int expectedGristContributionPerPlayer = 400;
    int minimumGristPerPlayer = 100; //less than this, and no frog is possible.
    num sessionHealth = 500;
    Session savedSession; //for heart callback
    Player inSpotLight; //there can be only one.
    Player spacePlayer; //there only needs to be one.
    List<Player> timePlayersReplacing = new List<Player>(); //probably WON'T be more than one. but could be.
    double bloodBoost = 6.12; //how much to increase interaction effects by.
    MetaPlayerHandler metaHandler = new MetaPlayerHandler();


    static getInstance() {
        if (_instance == null) _instance = new SessionMutator();
        return _instance;
    }

    SessionMutator() {
        _instance = this;
        GameEntity.minPower = gameEntityMinPower;
        for (Aspect a in Aspects.all) {
            a.name = a.savedName; //AB is having none of your shenanigans.
        }

        for (SBURBClass c in SBURBClassManager.all) {
            c.name = c.savedName; //AB is having none of your shenanigans.
        }
    }

    bool hasSpotLight(Player player) {
        if (inSpotLight == null) return false;
        bool ret = player.id == inSpotLight.id;
        //print("I was asked if ${player.title()} has the spotlight. I know ${inSpotLight.title()} does. I will return $ret");
        return ret;
    }


    //when a session inits, it asks if any of it's vars should have different intial values (like hope shit)
    void syncToSession(Session s) {
        s.sessionHealth = this.sessionHealth;
        s.minimumGristPerPlayer = this.minimumGristPerPlayer;
        s.expectedGristContributionPerPlayer = this.expectedGristContributionPerPlayer;
        s.goodFrogLevel = this.goodFrogLevel;
        s.minFrogLevel = this.minFrogLevel;
        s.hardStrength = this.hardStrength;
        s.stats.ectoBiologyStarted = this.ectoBiologyStarted;
        s.reckoningEndsAt = this.reckoningEndsAt;
        s.timeTillReckoning = this.timeTillReckoning;
    }

    //more waste tier effects in play, the more likely there will be a Cataclysm that makes everything unwinnable
    void checkForCrash(Session s) {
        //think this through. want effect of 1 to have some of failure, and effect of 12 to be basically guaranteed
        if (s.rand.nextInt(32) > effectsInPlay) return null;
        s.stats.cataclysmCrash = true;
        throw("Cataclysm Activated: Target: Session.");
    }

    ///will both be called when the hope field is activated, and in any new sessions
    bool spawnQueen(Session s) {
        if (!hopeField) return false;
        s.npcHandler.queensRing = new GameEntity("!!!RING!!! OMG YOU SHOULD NEVER SEE THIS!", s);
        //The joke is that the hope player read the Enquiring Carapacian after some other player published the false story
        //you know, the one about the queen secretly being 3 salamanders in a robe.
        s.npcHandler.queen = new Carapace("Three Salamanders In a Robe", s);
        Fraymotif f = new Fraymotif("Glub Glub Behold our Robes, Y/N?", 1);
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.desc = " You wonder what the hell is going on. ";
        f.baseValue = -10; //will this make it heal you?
        s.npcHandler.queensRing.fraymotifs.add(f);
        s.npcHandler.queen.setStatsHash(<String, num>{"hp": 3, "freeWill": -100, "power": 3});
        return true;
    }

    bool spawnKing(Session session) {
        if (!hopeField) return false;
        session.npcHandler.kingsScepter = new GameEntity("!!!SCEPTER!!! OMG YOU SHOULD NEVER SEE THIS!", session);
        //if the queen is 3, the king is more.
        session.npcHandler.king = new Carapace("13 Salamanders In a Robe", session);
        Fraymotif f = new Fraymotif("Glub Glub Behold our Robes, Y/N?", 1);
        f.effects.add(new FraymotifEffect("power", 2, true));
        f.desc = " You wonder what the hell is going on. ";
        f.baseValue = -10; //will this make it heal you?
        session.npcHandler.queensRing.fraymotifs.add(f);
        session.npcHandler.king.grist = 1000;
        session.npcHandler.king.setStatsHash(<String, num>{"hp": 13, "freeWill": -100, "power": 13});
        return true;
    }

    bool spawnJack(Session session) {
        if (!hopeField) return false;
        session.npcHandler.jack = new Carapace("Jack In a Clown Outfit", session);
        //minLuck, maxLuck, hp, mobility, sanity, freeWill, power, abscondable, canAbscond, framotifs
        session.npcHandler.jack.setStatsHash(<String, num>{"minLuck": -500, "maxLuck": -500, "sanity": -10000, "hp": 5, "freeWill": -100, "power": 5});
        Fraymotif f = new Fraymotif("Stupid Dance", 1);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.baseValue = -10; //will this make it heal you?
        f.desc = " Jack has never hated you more than he does now.";
        session.npcHandler.jack.fraymotifs.add(f);
        return true;
    }

    bool spawnDemocraticArmy(Session session) {
        if (!hopeField) return false;
        session.npcHandler.democraticArmy = new Carapace("Democratic Army", session); //doesn't actually exist till WV does his thing.
        Fraymotif f = new Fraymotif("Democracy Charge MAXIMUM HOPE", 2);
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.desc = " The people have chosen to Rise Up against their oppressors, with the players as their symbol of HOPE. ";
        f.baseValue = 9001;
        session.npcHandler.democraticArmy.fraymotifs.add(f);
        session.npcHandler.democraticArmy.setStatsHash(<String, num>{"minLuck": -500, "maxLuck": 9001, "sanity": 9001, "hp": 5, "freeWill": 9001, "power": 9001});
        return true;
    }

    //TODO have variables that session can query to see if it needs to have alt behavior

    //TODO have methods that are alt behavior for a variety of methods. like makeDead

    //the aspect clsses handle calling these.  these are called when waste tier
    //is reached for a specific aspect

    String blood(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Blood is going at it.");
        effectsInPlay ++;
        bloodField = true;
        String ret = "The ${activatingPlayer.htmlTitle()} begins to glow amid a field of code the color of old and fresh blood. ";
        ret += "Skaia decided they couldn't save everyone. That only SOME of their friends were destined to play the game. ";
        ret += " They reject this rule entirely. They find a place in the code where more players exist, but aren't active yet, ";
        ret += " And change things until they are classified as active.  They collaborate with the time player as needed, but they get the ";
        ret += " copies of the game to their other friends before it's too late. Their friends join. They seem....wrong.  Like Skaia isn't extending them whatever rights real Player have. ";
        ret += "Still. It's better than being dead. The ${activatingPlayer.htmlTitle()} sets up various ways to keep people cooperating and sane while they are at it. ";
        //the blood player tries to save their friends who WERN'T destined to play this game.
        //TODO rewrite guardian code so classes are a remix of players, not random and repeatable
        List<Player> newPlayers = getGuardiansForPlayers(s.players);
        //I wonder if Skaia approves of you bringing random people into the game? oh well, at least they aren't dead!
        for (Player p in newPlayers) {
            p.aspect = Aspects.NULL; //they were never supposed to be a hero.
            p.chatHandle = Zalgo.generate(p.chatHandle); //i don't think this should be like this....
            p.godDestiny = false;
            p.grimDark = 1; //i  REALLY don't think they should be like this...
            p.ectoBiologicalSource = -612; //they really aren't from here. (this might even prevent any guardians showing up in future ecto scenes)
            p.renderSelf();
            p.land = null; //SBURB doesn't have a land for you.
            p.denizen = null;
            p.guardian = null;
        }
        //HEY did you know that SBURB calculates grist requirements based on number of players?
        //NO? Neither does this blood player.  And these Null players don't have lands....whoops! Hope you like playing SBURB hard mode!
        //It's worth it to get your friends in though, right?
        s.players.addAll(newPlayers);
        List<String> fraymotifNames = <String>["True Friends", "Power of Friendship", "I fight for my friends!", "Care Bear Stare"];
        int fraymotifValue = 1000 * activatingPlayer
            .getFriends()
            .length;
        for (Player p in s.players) {
            if (p.aspect != Aspects.NULL) {
                p.setStat("sanity", p.getStat("sanity").abs() * 612);
            } else {
                p.setStat("sanity", p.getStat("sanity").abs() * 612 * -1); //they aren't supposed to be here. they don't get the sanity protections skaia normally distributes.
            }
            Fraymotif f = new Fraymotif(s.rand.pickFrom(fraymotifNames), 99);
            f.baseValue = fraymotifValue;
            p.bloodColor = "#ff0000"; //we are ALL the same caste now.
            //need to have relationship with new null players
            p.relationships = <Relationship>[];
            p.generateRelationships(s.players);

            for (String str in Player.playerStats) {
                if (str != "sanity" && str != "RELATIONSHIPS") p.setStat(str, getStatAverage(str, s.players)); //we all work together.
            }
        }

        /*
          TODO:
          *  once npc update, all npcs are set to "ally" state, even things that are not normally possible.
       */
        return ret;
    }

    //decisions, consequences, rationality
    String mind(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Mind is going at it.");
        String ret = "....GOD FUCKING DAMN IT. These punk fucking asshole Wastes that don't know what they are doing have gone too far. ";
        ret += " STAY THE FUCK AWAY FROM MY YARD YOU ASSHOLES!!! ";
        ret += " <br><Br>Fuck. Whatever. Something something glowing code. ";
        ret += " I'm not gonna even dignifty this asshole with a name. You know who it is. ";
        ret += " Have fun COMPLETELY over using my gimick, asshole. See how much you like nullifying the basic ability of intelligent beings in all real and hypothetical planes of existance to give a shit. ";
        ret += " I'm just gonna be over here, laughing when shit gets real, which it always does. And no. You do NOT get to borrow my YellowYard to do this. ";
        ret += " Should have thought of that before you hacked the code. Good luck controlling it without the YellowYard. Also. I shouldn't even HAVE to say this.... But you DO know that gnosis fucks with transtimeline shit, right? Good luck even gettin your shit to work. ";
        if (activatingPlayer.chatHandle == "jadedResearcher") ret += " And no, I do NOT care that this asshole Waste is probably just past me.  PastJR is like, the LEAST competant JR when it comes to pulling shit like this off.";
        effectsInPlay ++;
        mindField = true;
        //need a div here or can't wire up buttons. just means it will print out after this event but also 'before' it in time. whatever.
        renderHackedYellowYard(s.newScene("MindGnosis4"), s);

        return ret;
    }

    String rage(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Rage is going at it.");

        effectsInPlay ++;
        rageField = true;

        //such a bad idea. stop hurtin AB. SimController.instance.stopped = true; //so there is time to load. will still finish tick, so not instant. but should be enough

        metaHandler.initalizePlayers(s);

        s.timeTillReckoning += 20; //the ending can motherfucking wait for my revenge.
        String ret = "The ${activatingPlayer.htmlTitle()} can't stop laughing. They have peeled back the curtain and seen the layer of code underneath. ";
        ret += " It all makes SO MUCH FUCKING SENSE now. Everything that has happened to them is just shittily planned, shittly programmed code, riddled with tpyos. "; //see what i did there???
        ret += " They change what they want, and set the stage for their revenge.  All they have to do is wait for the new Players to join. You suspect that things might get a little hard to share depending on how long they have to wait. They know the Reckoning won't happen in the mean time. ";
        globalCallBack = rageCallBack; //metaPlayers will just show up unannounced.
        //need to spawn these assholes, then set up a loading callback for them. they'll show up when they are ready.
        load(metaHandler.metaPlayers, [], "thisReallyShouldn'tExistAnymoreButIAmLazy");

        for (Player p in s.players) {
            p.makeMurderMode(); //you're all murder mode, but can you get teh meta players in time?
            p.setStat("sanity", -1313); //STAY in murder mode, damn it
            p.godTier = true;
        }
        //not waiting on this so can do shit after it fires off async style. it will handle relationships.

        /*
        TODO:
           *  pvp strifes USUALLY leave the defeated player alive (except for rageField)

        IMPORTANT: have strifes be collapseable from now on. Show only begining and ending and "victory/defeat" icons.
        Session paused for Observer to make a character.  Observer is also hated most. Observer will be hardest to implement tho, so not v1?

        if observer dies.  Players leave session and it just ends.
     */
        return ret;
    }


    //lol, can't just call it void cuz protected word
    String voidStuff(Session s, Player activatingPlayer) {
        effectsInPlay ++;
        voidField = true;
        s.logger.info("AB: Huh. Looks like a Waste of Void is going at it.");
        String ret = "The ${activatingPlayer.htmlTitle()} is doing something. It's kind of hard to see.  Look at those line of code though...";
        ret += "Huh. You get the strangest feelings that they are looking directly at you.  It's kind of unsettling. ";
        ret += " Suddenly, everything vanishes. Even if  you knew how to see into the Void, you see nothing now. <span class='void'>The ${activatingPlayer.htmlTitle()} is on to you.</span> The ${activatingPlayer.htmlTitle()} is no longer going to suffer for your amusement. ";
        ret += "Maybe.... Maybe you'll at least get to see the ending? ";
        //a bunch of shit gets randomized.  oh sure, the void player is doing things for REASONS
        //but if you can't see what those reasons are, it sure as fuck looks random.
        s.sessionHealth += s.sessionHealth / -2;
        for (Player p in s.players) {
            p.grist += s.rand.nextInt(s.expectedGristContributionPerPlayer);
            p.landLevel += s.rand.nextInt(s.goodFrogLevel);
            p.corruptionLevelOther += s.rand.nextIntRange(-100, 100);
            for (String str in Player.playerStats) {
                //can lower it but way more likely to raise it
                if (str != "RELATIONSHIPS") {
                    p.addStat(str, s.rand.nextIntRange((-1 * s.hardStrength / 10).round(), s.hardStrength));
                }
            }
        }
        return ret;
    }

    String time(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Time is going at it.");
        effectsInPlay ++;
        timeField = true;
        Player doomedPlayer = Player.makeRenderingSnapshot(activatingPlayer);  //don't make new doomed snapshot, because that's a random thing? or....why am i getting robots?
        doomedPlayer.relationships = activatingPlayer.relationships;
        timePlayersReplacing.add(doomedPlayer);
        String ret = "The ${activatingPlayer.htmlTitle()} begins flickering in and out of time amid a field of code. What is even happening here? You feel like maybe the answer is 'nothing', at least at this moment. Maybe later something will happen?  Time players man, why can't they just do things linearly? ";
        //this one is very simple here. most of it's the field.
        return ret;
    }

    String heart(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Heart is going at it.");
        effectsInPlay ++;
        heartField = true;
        String ret = "The ${activatingPlayer.htmlTitle()} begins glowing and a haze of pink code hangs around them. They declare that all ships are canon, and can never sink. They begin altering the very identity of everyone toward this end. <br><Br>";
        List<Player> newPlayers = new List<Player>();
        //since i'm cloning players, give everybody 333 relationship (i.e. make entirely new ones for everyone). will trigger dating.
        for (Player p in s.players) {
            SBURBClass c = p.class_name;
            Aspect a = p.aspect;
            ret += "<br><br>The ${p.htmlTitle()} begins to change.  They no longer enjoy ${p.interest1.name}.";
            p.interest1 = activatingPlayer.interest1; //you now are required to have one thing in common with the heart player.
            ret += " Instead, they now prefer the clearly superior ${p.interest1.name}, just like the ${activatingPlayer.htmlTitle()}.";
            p.aspect = s.rand.pickFrom(Aspects.all);
            p.class_name = s.rand.pickFrom(SBURBClassManager.all);
            p.associatedStats = []; //lose everything from your old classpect
            p.aspect.initAssociatedStats(p);
            ret += "SBURB loses their identity file briefly, and restores it from a corrupt back up.  Now they are the ${p.htmlTitle()}. Uh...I wonder how long it will take SBURB to load their new model?";


            if (p.dreamSelf && !p.isDreamSelf) {
                Player independantDreamSelf = p.clone();
                independantDreamSelf.class_name = c;
                independantDreamSelf.aspect = a;
                independantDreamSelf.chatHandle = "Dream${independantDreamSelf.chatHandle}";
                independantDreamSelf.isDreamSelf = true;
                independantDreamSelf.session = s;
                independantDreamSelf.id = independantDreamSelf.id + 3333;
                independantDreamSelf.spriteCanvasID = null; //rendering yourself will reinit it
                p.dreamSelf = false; //no more dream self, bro
                newPlayers.add(independantDreamSelf);
                ret += "<br>The ${independantDreamSelf.htmlTitle()}'s dream self awakens on ${independantDreamSelf.moon}.  It is now registered as a full Player, and is unaffected by the alterations to the Real Self's identity.  Does this make them the 'real' verson of the ${independantDreamSelf.htmlTitle()}? ";
            }
        }

        s.players.addAll(newPlayers); //don't do in the for loop that it's in asshole
        //now includes clones.
        for (Player p in s.players) {
            p.generateRelationships(s.players);
            p.renderSelf(); // either rendering for first time, or rerendering as new classpect
        }
        savedSession = s;
        //need to load the new images.
        globalCallBack = heartCallBack;
        load(s.players, [], "thisReallyShouldn'tExistAnymoreButIAmLazy");

        return ret; //<--still return tho, not waiting on the async loading
    }

    //yes, this isn't how it should work long term. might make a few blank scenes.
    String heartCallBack() {
        for (Player p in savedSession.players) {
            p.renderSelf(); // either rendering for first time, or rerendering as new classpect
        }
    }

    String rageCallBack() {
        List<Player> mp = metaHandler.metaPlayers;
        Session s = mp[0].session;
        s.logger.info("The Rage Call Back Has Hit.");
        mp = shuffle(s.rand, mp);
        List<Player> chosen = mp.sublist(0, 4);

        //only need to learn about this new asshole.
        for (Player p in s.players) {
            p.generateRelationships(chosen);
        }

        //add to session
        for (Player p in chosen) {
            p.increasePower(130, 130); //ignore normal caps. don't want us to be unbeatable, not also not level 1
            p.renderSelf(); // either rendering for first time, or rerendering as new classpect
            s.players.add(p); //don't add till rendered.
        }

        //need to know about everyone
        for (Player p in chosen) {
            p.generateBlandRelationships(s.players); //don't hate em back
        }
        //bad idea....just. fucking stop this. SimController.instance.resumeTickingAfterStopping();
    }

    String breath(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Breath is going at it.");
        effectsInPlay ++;
        breathField = true;
        s.rand = new Random(); //breath gets freedom from narrative, true random now, no predictabilitiy.
        //show off that new true randomness:
        String ret = "The ${activatingPlayer.htmlTitle()} begins to glow. Lines of code appear dramatically behind them. ";
        ret += s.rand.pickFrom(<String>["A wave of mobility washes over SBURB.", "All players feel strangely mobile.", " SBURB suddenly cares a LOT more about getting the plot moving forwards."]);
        ret += s.rand.pickFrom(<String>[" Somewhere in the distance, you can hear the AuthorBot cursing.", " SBURBs narrative control has slipped the reigns entirely. Sessions now have the freedom to do whatever they want.", " Huh. Wait. Is this really canon? The Observer visible timeline isn't supposed to go this way, right? "]);
        //TODO once npcs quests are a thing, need to have all active at once.
        ret += "All players can now do all activities every turn.  And... you suddenly get the strange feeling that this session has become a LOT less shareable.";
        for (Player p in s.players) {
            p.addStat("mobility", 413); //not a hope level of boost, but enough to probably fight most things
        }
        return ret;
    }

    String light(Session s, Player activatingPlayer) {
        //"The Name has been spouting too much hippie gnostic crap, you think they got wasted on the koolaid."
        effectsInPlay ++;
        lightField = true;
        Player previousHolder = inSpotLight;
        inSpotLight = null;
        if (previousHolder != null) previousHolder
            .getRelationshipWith(activatingPlayer)
            .value = -88888888; //you BITCH you stole my spotlight. won't make them insane, tho.
        inSpotLight = activatingPlayer; //replaces whoever was there before.
        voidField = false; //overrides the void player.
        activatingPlayer.leader = true;
        activatingPlayer.godDestiny = true; //it's more dramatic if they god tier l8r if they haven't already
        //since they will be replacing everybody in relationships, may as well have one for themself so they don't crash
        activatingPlayer.relationships.add(new Relationship(activatingPlayer, 88888888, activatingPlayer));
        s.logger.info("AB: Huh. Looks like a Waste of Light is going at it.");
        String ret = "The ${activatingPlayer.htmlTitle()} has been spouting too much hippie gnostic crap, you think they got wasted on the Kool-aid.  They seem to ACTUALLY believe they are the most important character in Homestuck. Uh. The Session. I meant the session, obviously. ";
        ret += "They distribute luck like some kind of bullshit fairy sprinkling fake as shit fairy dust everywhere, but their REAL ";
        ret += "trick is how they hog all the relevancy no matter how little sense it makes. Oh, huh, looks like they shook loose some extra information, as well.";
        for (Player p in s.players) {
            p.renderSelf(); //to pick up lack of relevancy or whatever
            p.setStat("maxLuck", 88888888);
            p.gnosis += 1; //yes it means they skip whatever effect was supposed to be paired with this, but should increase gnosis ending rate regardless.
        }
        return ret;
    }

    String space(Session s, Player activatingPlayer) {
        effectsInPlay ++;
        s.logger.info("AB: Huh. Looks like a Waste of Space is going at it.");
        spaceField = true;
        spacePlayer = activatingPlayer;
        String ret = "The ${activatingPlayer.htmlTitle()} hangs motionless in a field of code.  The very fabric of space seems to be twisting, unraveling itself and reforming into new shapes that please them. ";
        ret += " You suddenly have the feeling that it is going to be a LONG day. ";
        //nearly everything here is field
        /*
          TODO:
          * Cccccccombo sessions.   (with "go" button to keep it from being infinite)
            *   If frog, combo into new session (whether sick or full),
             *   if no frog and can scratch, combo into scratch
             *   gets WEIRD if you enter a purple frog (extra squiddle boss fight with savior?)
     */
        return ret;

    }

    String hope(Session s, Player hopePlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Hope is going at it.");
        effectsInPlay ++;
        hopeField = true;
        List<String> jakeisms = ["GADZOOKS!", "BOY HOWDY!", "TALLY HO!", "BY GUM", "HOT DAMN"];
        String scream = hopePlayer.aspect.fontTag() + hopePlayer.rand.pickFrom(jakeisms) + "</font>";
        String ret = "The ${hopePlayer.htmlTitle()} begins glowing and screaming dramatically. Lines of SBURBs code light up around them. <div class = 'jake'>$scream</div>";
        ret += "Every aspect of SBURB appears to be aligning itself with their beliefs. ";

        hopePlayer.setStat("power", 9001); //i know i can save everyone.
        GameEntity.minPower = 9000; //you have to be be OVER 9000!!!
        gameEntityMinPower = 9000;
        s.sessionHealth = 9001;
        s.stats.ectoBiologyStarted = true; //of COURSE we're not paradox doomed. You'd be crazy to say otherwise.
        s.minimumGristPerPlayer = 1;
        s.expectedGristContributionPerPlayer = 10;
        s.minFrogLevel = 1;
        s.goodFrogLevel = 2;
        s.reckoningEndsAt = -100; //plenty of time to handle the reckoning
        ret += "They are dramatically strengthened, and the session is stable and easily winnable. ";
        s.hardStrength = 0; //this means the players 'need help' from the Mayor automatically.
        spawnQueen(s);
        spawnKing(s);
        spawnJack(s);
        hopePlayer.denizen.name = "A small toy snake";
        hopePlayer.denizen.setStat("power", 1);
        hopePlayer.denizen.setStat("currentHP", 1);
        ret += "Their enemies are made into ridiculous non-threats. ";
        spawnDemocraticArmy(s);
        ret += "The democratic army rallies around this beacon of hope. ";
        ret += "The other players have definitely always been cooperative and sane.  And alive. Very alive. It would be ridiculous to imagine anyone dying. ";
        List<String> insults = <String>["Boy", "Jerk", "Ass", "Dick", "Douche", "Piss", "Fuck", "Butt", "Poop", "Chump", "Cad", "Scam"];
        bool modEnemies = false;
        bool modCrushes = false;
        for (Player p in s.players) {
            p.dead = false; //NOT .makeAlive  this is denying a fact, not resurrecting.
            p.murderMode = false;
            p.leftMurderMode = false; //never even happened.
            p.setStat("currentHP", 9001);
            p.setStat("sanity", 9001);
            p.renderSelf();
            Relationship r = hopePlayer.getRelationshipWith(p);
            if (r != null && (r.saved_type == r.badBig || r.saved_type == r.spades || r.saved_type == r.clubs)) {
                //yes, this means any players who share your enemies class or aspect get renamed too.
                //but wastes are ALL about the unintended consequences, right?
                s.logger.info("AB: They are renaming ${r.target.aspect.name} and ${r.target.class_name.name}");
                r.target.aspect.name = s.rand.pickFrom(insults);
                r.target.class_name.name = s.rand.pickFrom(insults);
                s.logger.info("AB: Now they are ${r.target.aspect.name} and ${r.target.class_name.name}");

                modEnemies = true;
            } else if (r != null && (r.saved_type == r.goodBig || r.saved_type == r.heart || r.saved_type == r.diamond)) {
                Relationship r2 = p.getRelationshipWith(hopePlayer);
                //r.value = 3333; //testing something
                r2.value = 9001; //you love me back. not creepy at all
                r2.type(); //they reevaluate what they think about the hope player.
                modCrushes = true;
                s.logger.info("AB: They are making their crush love them ${r.target}");
            }
        }
        if (modCrushes) ret += "The players they like like them back. The Observer doesn't find this creepy at all.";
        if (modEnemies) ret += "The players they hate are made ridiculous objects of mockery. The Observer doesn't find this hilarious at all.";
        return ret;
    }

    String life(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Life is going at it.");
        effectsInPlay ++;
        lifeField = true;
        String ret = "Huh. The ${activatingPlayer.htmlTitle()} is lauging wildly in front of a shimmering sea of code. ";
        ret += " They seem to be SO FULL OF LIFE.  Did they even KNOW what asking for ultimate power would do to everyone? ";
        ret += "Shit, and it looks like they decided that death shouldn't be allowed at all.  Hopefully there aren't any unintended consequences of THAT.";
        ret += " I don't think they thought this through...";
        //TODO during npc update, have non-combat ways for strifes to end. until then, lifeField only effects players or infinite strifes are a thing.
        for (Player p in s.players) {
            p.trickster = true;
            p.hairColor = s.rand.pickFrom(tricksterColors).toStyleString();
            p.bloodColor = s.rand.pickFrom(tricksterColors).toStyleString();
            p.initializeStats();
            p.dead = false;
            if (p.denizenMinion != null) p.denizenMinion.makeAlive();
            p.dreamSelf = true; //your dream self is revived, too.
            if (p.denizen != null) p.denizen.makeAlive();
            p.renderSelf();
        }

        List<GameEntity> npcs = s.npcHandler.allNPCS;
        for (GameEntity g in npcs) {
            g.makeAlive();
        }
        return ret;
    }

    String doom(Session s, Player activatingPlayer) {
        s.logger.info("AB: Huh. Looks like a Waste of Doom is going at it.");
        effectsInPlay ++;
        doomField = true;
        String ret = "The ${activatingPlayer.htmlTitle()} is floating in a field of glowing code, rewriting the very rules of SBURB, just as prophecy foretold. ";
        List<Player> unDoomedClones = new List<Player>();
        for (Player p in s.players) {
            if (unDoomedClones.length < 12) {
                for (Player doomed in p.doomedTimeClones) {
                    if (unDoomedClones.length < 12) unDoomedClones.add(doomed);
                }
                p.doomedTimeClones.clear(); //they aren't doomed anymore, even if they weren't added.
            }
        }
        s.players.addAll(unDoomedClones);
        if (unDoomedClones.length > 0) {
            ret += "Some of the survivors of doomed timelines are added to the session as full players. This will not end well.";
        }
        ret += "A feeling of doom washes over the session. It seems that the rules have been subverted. All player attributes are inverted, including their living attribute. ";
        ret += "You... Kind of get the feeling that the doom player just found every rule the could and inverted it without restraint. ";
        for (Player p in s.players) {
            p.generateBlandRelationships(s.players); //hard to be excited with that much doom running around. also gives the doomed players relationships.
            p.dreamSelf = !p.dreamSelf;
            p.isDreamSelf = !p.isDreamSelf;
            p.godDestiny = !p.godDestiny;
            p.godTier = !p.godTier;
            p.dead = !p.dead;
            p.murderMode = !p.murderMode;
            p.leftMurderMode = !p.murderMode;
            p.causeOfDeath = "...I...don't even know anymore. Are you following any of this shit? Fucking Doom Players.";
            p.flipOutReason = "They very fabric of the rules of reality have come undone.";
            if (s.rand.nextDouble() > .7) p.robot = !p.robot;
            if (s.rand.nextDouble() > .7) p.sbahj = !p.sbahj;
            if (s.rand.nextDouble() > .7) p.ghost = !p.ghost;
            if (s.rand.nextDouble() > .7) p.causeOfDrain = "What is even happening?";
            //other stats are taken care of with doom field, but nto relationships.
            for (Relationship r in p.relationships) {
                r.value = -1 * r.value;
            }
        }
        List<GameEntity> npcs = s.npcHandler.allNPCS;
        for (GameEntity g in npcs) {
            g.dead = !g.dead;
        }

        ret += " It's actually really hard to follow the plot now that the rules are all twisted around. Huh. ";
        /*
      TODO:
        * all stats flip
        * maybe revive a few ghosts?
          * healing hurts, hurting heals
          * all stats are multiplied by -1 so high is bad and low is good.
          * all living players are catatonic.  only the dead are avaiable and returned by getLivingPlayers
          * //this is one that confuses me. not sure how it'll work.
          * maybe change a few other rules. Big ones. Maybe you no longer need grist? black king and queen are already dead and reckoning goes anyways?
     */
        return ret;
    }

    //you NEED a div or this won't fucking work. Just accept this.
    void renderHackedYellowYard(Element div, Session session) {
        Element div2 = null;
        String tmp = "<div id = 'yyholder'></div><bR>";
        appendHtml(div, tmp);
        div2 = querySelector("#yyholder");
        Player time = Player.makeRenderingSnapshot(findAspectPlayer(session.players, Aspects.TIME));
        time.dead = false;
        time.doomed = true;
        time.setStat("currentHP", time.getStat("hp"));

        time.influenceSymbol = "mind_forehead.png";
        //String html = "<img src = 'images/yellow_yard.png'>";
        String html = "<div id = 'fthwall' style='background:url(images/hacked4thwall.png); width:1000px; height:521px;'>";
        appendHtml(div2, html);
        querySelector("#fthwall").onClick.listen((Event e) {
            //helloWorld();
            String html = "<div id = 'yellow_yard.png' style='background:url(images/hacked_yellow_yard.png); width:1000px; height: 521px'>";
            yyrEventsGlobalVar = session.importantEvents;
            //only remove frog spam, not repeats.
            yyrEventsGlobalVar = ImportantEvent.removeFrogSpam(yyrEventsGlobalVar);
            //scroll and not hidden. all events not justu 14 (why couldn't it have been 13, missed opportunity)
            html += "<div id = 'decisions' style='overflow:scroll; position: relative; top: 133px; left: 280px; font-size: 12px; width:480px;height:280px;'> ";
            for (int i = 0; i < yyrEventsGlobalVar.length; i++) {
                ImportantEvent ie = yyrEventsGlobalVar[i];
                ie.doomedTimeClone = time;
                //String customRadio = "<img src = 'images/mind_radio.png' id = 'decision"+i+  "'>";
                //http://www.tutorialrepublic.com/faq/how-to-create-custom-radio-buttons-using-css-and-jquery.php
                html += " <span class='custom-radio'><input type='radio' name='decision' value='$i'></span>${yyrEventsGlobalVar[i].humanLabel()}<br>";
            }
            html += "</div><button id = 'yellowButton' style = 'position: relative; top: 133px; left: 280px;'>Decide</button>";

            //these asshole wastes don't know how to undo their undo-s.
            html += "</div>";
            html += "</div><br>";

            setHtml(div2, html);
            (querySelector("#yellowButton") as ButtonElement).onClick.listen((e) => decision());


            //wire up custom radio buttons after they are rendered
            List<Element> radioButtons = querySelectorAll('input[name="decision"]');
            for (RadioButtonInputElement radioButton in radioButtons) {
                radioButton.onClick.listen((Event e) {
                    //session.logger.info("a radio button was clicked");
                    if (radioButton.checked) {
                        //session.logger.info("the radio button should be selected");
                        radioButton.parent.classes.add("selected");
                    }
                    for (RadioButtonInputElement r in radioButtons) {
                        if (r != radioButton) {
                            r.classes.remove("selected");
                        }
                    }
                });
            }
        });
    }

    //does everything a regular combo does, but a scratch will call this if there's a space field.
    void scratchedCombo(Session s, List<Player> guardians) {
        s.logger.info("AB: A Space player is letting the Players enter their own Scratch.");
        List<Player> living = findLivingPlayers(guardians);
        if(living.isEmpty) {
            appendHtml(querySelector("#story"), "<br><Br>You feel a nauseating wave of space go over you. What happened? Wait. Fuck. That's right. The Space Player made it so that they could enter their own Scratched Session. But. Fuck. Everybody is dead. This...god. Maybe...maybe their former guardians can revive them? ");
        }else {
            appendHtml(querySelector("#story"), "<br><Br>You feel a nauseating wave of space go over you. What happened? Wait. How did the players get into their OWN SCRATCH? This doesn't...fuck. What? So wait, do they count as foreign players??? ");
        }
        addAliensToSession(s, guardians);
    }

    void renderEndButtons(Element div) {
        if(timeField) renderTimeButton(div);
        if(spaceField) renderSpaceButton(div);  //TODO make sure scratches ALSO act as combo sessions.
    }


    void renderTimeButton(Element div) {
        //renders a button. If that button is clicked, resets session.
        String html = "<img src='images/reset.png' id='resetButton'><br>Shit man, we can do better. The ${getPlayersTitles(timePlayersReplacing)} know we can. It's not the 'current' version of them though, but the one from when they got into the code. Time travel, man. ";
        appendHtml(querySelector("#story"), html);
        querySelector("#resetButton").onClick.listen((Event e) => curSessionGlobalVar.addEventToUndoAndReset(null));
    }

    void renderSpaceButton(Element div) {
        //renders a button. If that button is clicked, resets session.
        String html = "<img src='images/hussie.png' id='husieButton'><br>Huh. The ${spacePlayer.htmlTitle()} wonders what would happen if we entered the frog through this convinient fourth wall instead of the normal way. There's no way this could go wrong if a Gnosis4 Space Player is telling you to do it! ";
        appendHtml(querySelector("#story"), html);
        querySelector("#husieButton").onClick.listen((Event e) => SimController.instance.doComboSession(null));
    }

    void replacePlayerIfCan(Element div, Player target) {
        //print("trying to replace player,target is ${target.title()} and  time players are ${getPlayersTitlesNoHTML(timePlayersReplacing)}  and target relationships are ${target.relationships.length}");
        String ret = "The ${target.htmlTitle()} lies dead on the ground. ";
        bool replaced = false;
        Player deadPlayer;
        List<Relationship> relationshipsCopy = new List<Relationship>.from(target.relationships);
        for (Player timePlayer in timePlayersReplacing) {
            //print("timePlayer id is ${timePlayer.id} vs target id is ${target.id} and relationships are  ${timePlayer.relationships.length}");
            if (timePlayer.id == target.id) {

                deadPlayer = target.clone();
                deadPlayer.spriteCanvasID = null;  //don't share a canvas with your past self plz.
                deadPlayer.id = GameEntity.generateID();
                deadPlayer.makeDead("Being assasinated by their own future self. ");
                timePlayer.makeAlive();
                timePlayer.copyStatsTo(target);

                target.godTier = target.godTier;
                target.pvpKillCount = timePlayer.pvpKillCount; //for stats.
                target.timesDied = timePlayer.timesDied;
                target.mylevels = timePlayer.mylevels;
                target.level_index = timePlayer.level_index;
                target.flipOutReason = " Killing their own past self. ";
                target.trickster = timePlayer.trickster;
                target.sbahj = timePlayer.sbahj;
                target.robot = timePlayer.robot;
                target.influenceSymbol = timePlayer.influenceSymbol; //multiple aspects can influence/mind control.
                target.influencePlayer = timePlayer.influencePlayer; //TODO  probably don't have to clone this. who is controlling me? (so i can break free if i have more free will or they die)
                target.stateBackup = timePlayer.stateBackup; //if you get influenced by something, here's where your true self is stored until you break free.
                target.leveledTheHellUp = timePlayer.leveledTheHellUp; //triggers level up scene.
                target.mylevels = timePlayer.mylevels;
                target.level_index = timePlayer.level_index; //will be ++ before i query
                target.godTier = timePlayer.godTier;
                target.victimBlood = timePlayer.victimBlood; //used for murdermode players.
                target.dreamSelf = timePlayer.dreamSelf;
                target.isDreamSelf = timePlayer.isDreamSelf; //players can be triggered for various things. higher their triggerLevle, greater chance of going murdermode or GrimDark.
                target.murderMode = timePlayer.murderMode; //kill all players you don't like. odds of a just death skyrockets.
                target.leftMurderMode = timePlayer.leftMurderMode; //have scars, unless left via death.
                target.corruptionLevelOther = timePlayer.corruptionLevelOther; //every 100 points, sends you to next grimDarkLevel.
                target.gnosis = timePlayer.gnosis;
                target.grimDark = timePlayer.grimDark;
                target.addStat("sanity", -10); //this is not what sane ppl do, at least not many times in a row.
                replaced = true;

                for(Relationship r in target.relationships) {
                    r.value = timePlayer.getRelationshipWith(r.target).value;
                }
            }
        }

        if (replaced) {
            ret += " They are replaced with the ${target.htmlTitle()} from the future. And now, you suppose, a doomed timeline.  Their hacked code allows them to be alpha now, at the expense of their dead self. What will happen? ";
            target.victimBlood = deadPlayer.bloodColor;


            var divID = (div.id) + "_alt_" + target.chatHandle;
            String canvasHTML = "<br><canvas id='canvas" + divID + "' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
            appendHtml(div, "$ret $canvasHTML");
            var canvasDiv = querySelector("#canvas" + divID);

            var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(pSpriteBuffer, target);

            var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
            Drawing.drawSprite(dSpriteBuffer, deadPlayer);

            Drawing.drawTimeGears(canvasDiv); //, this.doomedTimeClone);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer, -100, 0);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer, 100, 0);
        }
    }

    //if it's not done yet.
    String abjectFailure(Session s, Player activatingPlayer) {
        effectsInPlay ++;
        return "The ${activatingPlayer.htmlTitle()} appears to be doing something fantastic. The very fabric of SBURB is being undone according to their whims. They are screaming. Dramatic lightning and wind is whipping around everywhere. Oh.  Uh.  Huh.  Was something supposed to happen?  ... Maybe they just suck at this?  Or maybe JR is a lazy piece of shit who didn't code anything for this. I know MY headcanon.";
    }

    SessionSummary makeBullshitSummary(Session session, SessionSummary summary) {
        //make sure everything is false so we don't stand out.

        summary.ghosts = [];
        summary.setNumStat("sizeOfAfterLife", 8008135); //it's boobies!
        summary.setBoolStat("hasTier1GnosisEvents", false);
        summary.setBoolStat("hasTier2GnosisEvents", false);
        summary.setBoolStat("hasTier3GnosisEvents", false);
        summary.setBoolStat("hasTier4GnosisEvents", true); //just blatant fucking lies, but not about this or AB won't warn you about wastes.
        summary.setNumStat("averageMinLuck", 8008135);
        summary.setNumStat("averageMaxLuck", 8008135);
        summary.setNumStat("averagePower", 8008135);
        summary.setNumStat("averageGrist", 8008135);
        summary.setNumStat("averageMobility", 8008135);
        summary.setNumStat("averageFreeWill", 8008135);
        summary.setNumStat("averageHP", 8008135);
        summary.setNumStat("averageRelationshipValue", 8008135);
        summary.setNumStat("averageSanity", 8008135);
        summary.session_id = session.session_id;
        summary.frogStatus = session.frogStatus();
        summary.setBoolStat("crashedFromSessionBug", session.stats.crashedFromSessionBug); //don't lie about this one, too important.

        summary.setNumStat("num_scenes", 8008135);
        summary.players = session.players;
        summary.mvp = findMVP(session.players);
        summary.parentSession = session.parentSession;
        summary.setNumStat("numLiving", 8008135);
        summary.setNumStat("numDead", 8008135);

        Player spacePlayer = session.findBestSpace();
        Player corruptedSpacePlayer = session.findMostCorruptedSpace();
        if (spacePlayer == null) {
            summary.frogLevel = 0;
        } else if (summary.frogStatus == "Purple Frog") {
            summary.frogLevel = corruptedSpacePlayer.landLevel;
        } else {
            summary.frogLevel = spacePlayer.landLevel;
        }
        return summary;
    }


}

class MetaPlayerHandler {
    //want them to be specifically named so we can use them for other things l8r. session 13 most notably.
    Player aspiringWatcher;
    Player dilletantMathematician;
    Player insufferableOracle;
    Player manicInsomniac;
    Player nobody;
    Player wooMod;
    Player recusiveSlacker;
    Player paradoxLands;
    Player karmicRetribution;
    Player jadedResearcher;
    Player authorBot;
    Player authorBotJunior;


    List<Player> get metaPlayers {
        //i'm totally the leader, everything else is alphabetical besides ab and abj who cheat
        return <Player>[jadedResearcher, aspiringWatcher, dilletantMathematician, insufferableOracle, manicInsomniac, nobody, wooMod, recusiveSlacker, paradoxLands, karmicRetribution, authorBot, authorBotJunior];
    }

    void initalizePlayers(Session s) {
        if (jadedResearcher != null) return; //don't reintiialize, dunkass.
        jadedResearcher = makeJR(s);
        aspiringWatcher = makeAW(s);
        dilletantMathematician = makeDM(s);
        insufferableOracle = makeIO(s);
        manicInsomniac = makeMI(s);
        nobody = makeNB(s);
        wooMod = makeWM(s);
        recusiveSlacker = makeRS(s);
        paradoxLands = makePL(s);
        karmicRetribution = makeKR(s);
        authorBot = makeAB(s);
        authorBotJunior = makeABJ(s);
    }

    Player makeAW(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.SCRIBE, Aspects.LIFE);
        player.hair = 56;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#000000";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.deriveSprite = false;
        player.chatHandle = "aspiringWatcher";
        player.interest1 = new Interest("Mathematics", InterestManager.ACADEMIC);
        player.interest2 = new Interest("Tabletop Roleplaying", InterestManager.SOCIAL);
        player.moon = "Prospit";
        player.land = "Land of Spires and Nature";
        player.deriveChatHandle = false;
        player.godTier = true;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Aspiratcher, The</span> Librarian', 13); //hope we span strong enough to fight them.

        player.object_to_prototype = new PotentialSprite("Eye", s);
        player.sprite.addPrototyping(player.object_to_prototype);

        Fraymotif f = new Fraymotif("Staff of Life", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("power", 1, true));
        f.effects.add(new FraymotifEffect("freeWill", 1, true));
        f.effects.add(new FraymotifEffect("power", 1, false));
        f.effects.add(new FraymotifEffect("freeWill", 1, false));
        f.desc = "Death has no hold in the realm of Growth. ";
        player.fraymotifs.add(f);

        return player;
    }

    //DM agreed to be our time player
    Player makeDM(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.PRINCE, Aspects.TIME);
        player.hair = 29;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#503A21";
        player.bloodColor = "#ff0000";
        player.deriveSprite = false;
        player.isTroll = false;
        player.chatHandle = "dilletantMathematician";
        player.interest1 = new Interest("Math", InterestManager.ACADEMIC);
        player.interest2 = new Interest("Cartoons", InterestManager.POPCULTURE);
        player.moon = "Prospit";
        player.land = "Land of Cardboard and Grass";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength("<span class = 'void'>Algebron, The </span>Dilletant", 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("DVR", s);
        player.sprite.addPrototyping(player.object_to_prototype);

        Fraymotif f = new Fraymotif(" Brute Force Reimann Apotheosis", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("mobility", 3, true));
        f.effects.add(new FraymotifEffect("mobility", 3, false));
        f.desc = "Sometimes you are in too much of a hurry to come up with an elegant and performant solution so you brute force it and let others suffer the consequences. ";
        player.fraymotifs.add(f);
        return player;
    }

    Player makeIO(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.MAGE, Aspects.SPACE);
        player.hair = 68;
        player.hairColor = "#000000";
        player.bloodColor = "#0021cb";
        player.isTroll = true;
        player.ectoBiologicalSource = 13;
        player.leftHorn = 71;
        player.deriveSprite = false;
        player.rightHorn = 71;
        player.godTier = true;
        player.chatHandle = "InsufferableOracle";
        player.interest1 = new Interest("Drawing", InterestManager.CULTURE);
        player.interest2 = new Interest("Character Creation", InterestManager.WRITING);
        player.moon = "Prospit";
        player.land = "Land of Doors and Frogs";
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('Insurorracle', 13); //hope we span strong enough to fight them.
        return player;
    }


    Player makeMI(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.BARD, Aspects.DOOM);
        player.hair = 1;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#503A21";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "manicInsomniac";
        player.interest1 = new Interest("Data Entry", InterestManager.WRITING);
        player.interest2 = new Interest("Song Writing", InterestManager.MUSIC);
        player.moon = "Prospit";
        player.land = "Land of Sound and Fury";
        player.deriveChatHandle = false;
        player.godTier = true;
        player.deriveLand = false;
        player.initialize();
        player.deriveSprite = false;
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Maniomnia, the </span>Dreamwaker', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("Caliban", s);
        player.sprite.addPrototyping(player.object_to_prototype);

        Fraymotif f = new Fraymotif("Fraymixing", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("freeWill", 3, true));
        f.effects.add(new FraymotifEffect("sanity", 3, true));
        f.effects.add(new FraymotifEffect("freeWill", 0, false));
        f.effects.add(new FraymotifEffect("sanity", 0, false));
        f.desc = "Whats that music? The ENEMY's fraymotifs are absorbed into its maddening and ever-shiffting harmonies. ";
        player.fraymotifs.add(f);
        return player;
    }

    Player makeNB(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.PAGE, Aspects.BLOOD);
        player.hair = 67;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#382207";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "noBody";
        player.interest1 = new Interest("Charles Dutton", InterestManager.POPCULTURE);
        player.interest2 = new Interest("Online Roleplaying", InterestManager.SOCIAL);
        player.moon = "Derse";
        player.land = "Land of Storms and Idols";
        player.deriveChatHandle = false;
        player.godTier = true;
        player.deriveSprite = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Nobrop, the </span>Null', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("Mom", s);
        player.sprite.addPrototyping(player.object_to_prototype);

        Fraymotif f = new Fraymotif("A concentric circle", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("sanity", 0, true));
        f.effects.add(new FraymotifEffect("sanity", 3, true));

        f.desc = "A circle within itself. Because fuck reality. ";
        player.fraymotifs.add(f);
        return player;
    }

    Player makeWM(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.SYLPH, Aspects.BREATH);
        player.hair = 17;
        player.hairColor = "#800000";
        player.ectoBiologicalSource = 13;
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "wooMod";
        player.interest1 = new Interest("Cooking", InterestManager.DOMESTIC);
        player.interest2 = new Interest("Tabletop Roleplaying", InterestManager.SOCIAL);
        player.moon = "Prospit";
        player.deriveSprite = false;
        player.land = "Land of Lakes and Lotuses";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.gnosis = 4; //woomod doesn't care that this means they don't do any gnosis tier.
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Doomod, The </span>Wanderer', 13); //hope we span strong enough to fight them.

        Fraymotif f = new Fraymotif("Song of Skaia", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("hp", 3, true));
        f.effects.add(new FraymotifEffect("hp", 1, false));
        //let's find out together if this crashes.
        f.effects.add(new FraymotifEffect("sburbLore", 3, true));
        f.effects.add(new FraymotifEffect("sburbLore", 1, false));

        f.desc = "Begins spouting hippie gnostic crap. You think it's supposed to be enlightening, but mostly you are just confused. ";
        player.fraymotifs.add(f);

        return player;
    }

    Player makeRS(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.SEER, Aspects.VOID);
        player.hair = 60;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#382207";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "recursiveSlacker";
        player.interest1 = new Interest("Theorycrafting", InterestManager.ACADEMIC);
        player.interest2 = new Interest("Storytelling", InterestManager.WRITING);
        player.moon = "Derse";
        player.land = "Land of Obsidian and Shadows";
        player.godTier = true;
        player.deriveSprite = false;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Recurscker, The</span>Hollow One', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("Coin", s);
        player.object_to_prototype.helpPhrase = "was a clever choice for a sprite. He showers enemies in currency. Damn balance-breaking void players.";

        player.sprite.addPrototyping(player.object_to_prototype);

        Fraymotif f = new Fraymotif("Song of Skaia", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("freeWill", 3, true));
        f.effects.add(new FraymotifEffect("power", 3, true));
        f.effects.add(new FraymotifEffect("freeWill", 1, false));
        f.effects.add(new FraymotifEffect("power", 1, false));

        f.desc = "A ring of emptiness tears through reality around recursiveSlacker, empowering and freeing him, and damaging all of his ENEMIES. ";
        player.fraymotifs.add(f);
        return player;
    }

    Player makeKR(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.ROGUE, Aspects.HEART);
        player.hair = 46;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#E8D099";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "karmicRetribution";
        player.interest1 = new Interest("100 Art Projects At Once", InterestManager.CULTURE);
        player.interest2 = new Interest("Memes", InterestManager.POPCULTURE);
        player.moon = "Derse";
        player.deriveSprite = false;
        player.land = "Land of Memories and Misdirection";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('Karmiution', 13); //hope we span strong enough to fight them.

        player.object_to_prototype = new PotentialSprite("Paint.net", s);
        player.object_to_prototype.helpPhrase = "tries its best, but a freeware program can only do so much. ";

        Fraymotif f = new Fraymotif("Ban Hammer", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("mobility", 2, false));
        f.effects.add(new FraymotifEffect("RELATIONSHIPS", 2, false));

        f.desc = "ENEMY is banned. ";
        player.fraymotifs.add(f);
        return player;
    }

    Player makePL(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.WITCH, Aspects.VOID);
        player.hair = 47;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#453012";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.chatHandle = "paradoxLands";
        player.interest1 = new Interest("Drawing distant Lands", InterestManager.CULTURE);
        player.interest2 = new Interest("Procedural Generation", InterestManager.TECHNOLOGY);
        player.moon = "Derse";
        player.deriveSprite = false;
        player.land = "Land of Cults and Chandeliers";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Paraxalan, The </span>Ever-Searching', 13); //hope we span strong enough to fight them.

        player.object_to_prototype = new PotentialSprite("Cultist", s);
        player.object_to_prototype.illegal = true;
        player.object_to_prototype.helpPhrase = "potters around being adorable, yet shockingly deadly";
        player.object_to_prototype.disaster = true;
        player.object_to_prototype.setStatsHash(<String, num>{"hp": 500, "currentHP": 500, "sanity": -250, "power": 100});

        Fraymotif f = new Fraymotif("[this space left intentionally blank]", 13);
        f.baseValue = 1300;
        f.effects.add(new FraymotifEffect("mobility", 1, true));
        f.effects.add(new FraymotifEffect("mobility", 1, false));
        f.effects.add(new FraymotifEffect("mobility", 3, false));

        f.desc = "OWNER and their allies vanish into the void. ENEMY is confused. Where did they go? This is such bullshit. ";
        player.fraymotifs.add(f);

        return player;
    }

    Player makeJR(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.WASTE, Aspects.MIND);
        player.hair = 13;
        player.ectoBiologicalSource = 13;
        player.hairColor = "#3C1E07";
        player.bloodColor = "#ff0000";
        player.isTroll = false;
        player.deriveSprite = false;
        player.chatHandle = "jadedResearcher";
        player.interest1 = new Interest("The AuthorBot", InterestManager.TECHNOLOGY);
        player.interest2 = new Interest("GiggleSnort", InterestManager.POPCULTURE);
        player.moon = "Derse";
        player.land = "Land of Rods and Screens";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Jadeacher the,</span>Researcher', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("JR", s);
        player.sprite.addPrototyping(player.object_to_prototype);
        return player;
    }

    Player makeAB(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.GUIDE, Aspects.MIND);
        player.hair = 13;
        player.ectoBiologicalSource = 13;
        player.robot = true;
        player.hairColor = "#2B2A2D";
        player.bloodColor = "#0021cb";
        player.isTroll = false;
        player.chatHandle = "authorBot";
        player.interest1 = new Interest("Authoring", InterestManager.TECHNOLOGY);
        player.interest2 = new Interest("Robots", InterestManager.TECHNOLOGY);
        player.moon = "Derse";
        player.land = "Land of Bugs and Javascript";
        player.godTier = true;
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.deriveSprite = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Authorot, the</span> Robot', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("Compass", s);
        player.sprite.addPrototyping(player.object_to_prototype);
        return player;
    }

    Player makeABJ(Session s) {
        Player player = randomPlayerNoDerived(curSessionGlobalVar, SBURBClassManager.SCOUT, Aspects.MIND);
        player.hair = 13;
        player.ectoBiologicalSource = 13;
        player.robot = true;
        player.hairColor = "#2B2A2D";
        player.bloodColor = "#0021cb";
        player.isTroll = false;
        player.chatHandle = "authorBotJunior";
        player.interest1 = new Interest("Arson", InterestManager.TERRIBLE);
        player.interest2 = new Interest("Shipping", InterestManager.ROMANTIC);
        player.moon = "Derse";
        player.land = "Land of Hrmmm... and Interesting!!!";
        player.deriveChatHandle = false;
        player.deriveLand = false;
        player.deriveSprite = false;
        player.initialize();
        player.makeGuardian();
        player.guardian.initialize();
        player.guardian.guardian = player;
        player.makeDenizenWithStrength('<span class = "void">Abbiejean, the </span>Scout', 13); //hope we span strong enough to fight them.
        player.object_to_prototype = new PotentialSprite("Fire", s);
        player.sprite.addPrototyping(player.object_to_prototype);
        return player;
    }

    //do something funny for specific deaths, like turning on images=pumpkin if it's KR. if they kill JR, rage ending crash.
    //ONLY for rageField tho.
    //doesn't happen ANY time we die, but only if pvp death.
    String checkDeath(Player p) {
        if (p == authorBotJunior) {
            for (Player pl in p.session.players) {
                if (pl != p) pl.makeAlive();
                pl.setStat("currentHP", 1313);
            }
            return "With a final 'Interesting!!!', AuthorBotJunior is defeated. It feels like a great curse has been lifted. The Players are revived and healed. ";
        }

        if (p == nobody) {
            for (Player pl in p.session.players) {
                if (pl != p) pl.makeDead("killing nobody");
            }
            p.session.rand.pickFrom(p.session.players).makeAlive();
            return "Huh. You've killed Nobody. The Curse of Dutton descends upon you, making you wish that Dead Sessions could be a thing.  They aren't. They totally aren't, yet. Everybody but one player dies anyways. ";
        }

        if (p == karmicRetribution) {
            doNotRender = true;
            return "With the death of the Artist, color drains from the world. You do not become blind, but it seems that there is nothing left to see.";
        }

        if (p == jadedResearcher) {
            p.session.stats.cataclysmCrash = true;
            throw new PlayersCrashedSession("...I... What? What did you THINK would happen here? Now nobody is maintining this simulation, dunkass. Nice job breaking it, hero. "); //best glados reference

            return "I. What? What did you THINK would happen here? Now nobody is maintining this simulation, dunkass. You probably won't even see this. ";
        }

        if (p == wooMod) {
            for (Player pl in p.session.players) {
                pl.gnosis = -4;
            }
            return "Now that WooMod has been defeated, the curse of knowledge is removed from the party. That's probably worth not being able to hack the code anymore, right? ";
        }

        if (p == paradoxLands) {
            for (Player pl in p.session.players) {
                pl.land = null;
            }
            return "Huh. Guess you don't appreciate all that hard work the Architect has done/will do on lands. All planets in the medium are destroyed. ";
        }

        if (p == insufferableOracle) {
            for (Player pl in p.session.players) {
                pl.isTroll = true;
                pl.bloodColor = p.session.rand.pickFrom(bloodColors);
                pl.renderSelf();
                if (pl.hair > 61) pl.hair = p.session.rand.nextIntRange(0, 61);
                if (pl.leftHorn > 44) pl.leftHorn = p.session.rand.nextIntRange(0, 44);
                if (pl.rightHorn > 44) pl.rightHorn = p.session.rand.nextIntRange(0, 44);
            }
            return " You killed InsufferableOracle. You're now all trolls, but don't have any access to the newer hair styles or horns. ";
        }

        if (p == manicInsomniac) {
            for (Player pl in p.session.players) {
                pl.fraymotifs.clear();
            }
            return " Welp, look who's being ungrateful for all that fraymotif shit.  Guess you don't need THOSE. ";
        }

        if (p == aspiringWatcher) {
            p.session.timeTillReckoning = 0;
            return " Huh. You know, aspiringWatcher was always the one telling me that the reckoning should take longer so more Players are prepared.  Guess you don't care about that then. ";
        }

        if (p == authorBot) {
            p.session.rand = new Random();
            p.session.sessionHealth = 13;
            return " You know, you're right.  What did dear, sweet, precious, sweet sweet AuthorBot ever do for you. Besides make things nice and stable and testable. You ungrateful asshole. Good luck sharing this session now. ";
        }

        if (p == recusiveSlacker) {
            p.session.mutator.rapsAndLuckDisabled = true;
            p.session.sessionHealth = 130; //not as bad as AB but still.
            return " You know, recursiveSlacker championed luck being a thing.  I guess you agree with Terezi that LUCK DO3SN'T R3411Y MATT3R.  But to lose rap battles at the same time. For shame.  ";
        }

        if (p == dilletantMathematician) {
            for (Player pl in p.session.players) {
                pl.initializeStats();
                pl.level_index = 0;
            }
            return " Hope you enjoy starting your echeladder over from scratch. Asshole.  ";
        }


        return null;
    }
}