import "../SBURBSim.dart";
//this should handle the most severe of the Gnosis Tiers: The Waste Tier
//these are permanent modifications to sessions and their behavior
//while the lesser shit that are one off things will be in the GainGnosis scenes themselves. (such as writing faqs)
class SessionMutator {
  int effectsInPlay = 0; //more there are, more likely session will crash.
  bool hopeField = false;  //facts about session change
  bool breathField = false; //sets availability to true, will interact with npc quests eventually
  bool heartField = false; //disallows breakups, 'random' relationships are 333, and reasons to date someone is 333 for shipping
  bool voidField = false; //has newScenes be added to a custom div instead of $story. newScene will clear that div constantly
  bool lightField = false; //returns light player instead of whoever was asked for in most cases
  static SessionMutator _instance;
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


  static getInstance() {
    if(_instance == null) _instance = new SessionMutator();
    return _instance;
  }

  SessionMutator() {
    _instance = this;
    GameEntity.minPower = gameEntityMinPower;
    for(Aspect a in Aspects.all) {
      a.name = a.savedName; //AB is having none of your shenanigans.
    }

    for(SBURBClass c in SBURBClassManager.all) {
      c.name = c.savedName; //AB is having none of your shenanigans.
    }
  }

  bool hasSpotLight(Player player) {
    if(inSpotLight == null) return false;
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
    if(s.rand.nextInt(32) > effectsInPlay) return null;
    s.stats.cataclysmCrash = true;
    throw("Cataclysm Activated: Target: Session.");
  }

  ///will both be called when the hope field is activated, and in any new sessions
  bool spawnQueen(Session s) {
      if(!hopeField) return false;
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
    if(!hopeField) return false;
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
    if(!hopeField) return false;
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
    if(!hopeField) return false;
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
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Blood is going at it.");
    effectsInPlay ++;
      /*
          TODO:
          * all players have sanity.abs() * 612
          * guardians are spawned as players to help you.
          * blood field allows pale quadrant chath whenver (default)
          *  interaction effects * 612
          *  New fraymotif: Power of Friendship (strength is based on number of players)
          *  All stats are averaged, then given back to party.
          *  Session Mutator: pale  quadrant chats happen constantly, even if not quadranted. (maybe???)
          *  once npc update, all npcs are set to "ally" state, even things that are not normally possible.
          *  All players have candy red blood.
          *  new players are allowed to enter session (what the fuck did I mean by this?)

       */
  }

  String mind(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Mind is going at it.");
    effectsInPlay ++;
    /*
      TODO:
        * Yellow Yard like thing prints out immediatly upon reaching this tier. Player shown, not me.
        *  all options are listed instead of just a yards worth (so custom)
        *  warning that yellow yards tend to be highly susceptible to other wastes fucking shit up (resetting the timeline does NOT reset what wastes did to it and I don't want it to)
        * A few custom options as well, up at the top
             *so instead of restraint, they let ANYTHING happen.  but still Observer choice?
             *  or are some things observer choice and some things the Waste chooses?
             *  peasant rail gun
             *  kill all denizens pre-entry
             *  kill all npcs pre-entry
             *  kill entire party pre-entry
             *  god tier entire party pre-entry
             *  prototype all players pre-entry
             *  shoosh pap all murderers pre-entry
             *  etc
     */
  }

  String rage(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Rage is going at it.");
    effectsInPlay ++;
    /*
        TODO:
        All players are murder mode, all players are god tier, all players hate each other.
        One or more creators or wranglers are spawned in game, and they hate US most of all.

        Session paused for Observer to make a character.  Observer is also hated most. Observer will be hardest to implement tho, so not v1?

        if observer dies.  Players leave session and it just ends.

        Everyone can do shenanigans.  pen15 activated at random.

        if KR is killed images = pumpkin

        if kr is killed, everyone is robots

        if JR is killed, session crash

        if abj is killed, all players die

        kill brope, all but one player dies

        kill PL lands get rerolled/fucked up eventually
     */

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
    s.sessionHealth += s.sessionHealth/-2;
    for(Player p in s.players) {
      p.grist += s.rand.nextInt(s.expectedGristContributionPerPlayer);
      p.landLevel += s.rand.nextInt(s.goodFrogLevel);
      p.corruptionLevelOther += s.rand.nextIntRange(-100, 100);
      for(String str in Player.playerStats) {
          //can lower it but way more likely to raise it
          if(str != "RELATIONSHIPS") {
            p.addStat(str, s.rand.nextIntRange((-1 * s.hardStrength / 10).round(), s.hardStrength));
          }
      }
    }
    return ret;
    /*
        TODO:
          * but NEVER print anything past this, not even in the void.

          *   * acomplish this by creating a new div with id voided you print to. if void field in effect
          *   random things happen here, people stat's are improved by random amounts, land levels and grist too. drop session health, tho
          *    newScene only appends there, and clears it out constantly. not just not displayed but GONE.
          * print Aftermath in $story as normal so you can see it.
          * if Yellow Yard happens, even the choices are blanked (but you can still pick them.)? (maybe? might be hard)
          *    *  if void field is in effect, LIE LIKE CRAZY TO AB.
         *     THAT WAY I DON'T HAVE TO RANDOMIZE THINGS AND STEP ON BREATHS TOES, BUT YOU STILL HAVE NO CLUE WHAT HAPPENED.

       */

  }

  String time(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Time is going at it.");
    effectsInPlay ++;
      /*
          TODO:
          * Timeline replay.  Redo session until you get it RIGHT. Everyone lives, full frog.
          *   Create players, then change seed. shuffle player order, etc.
          *   line about them killing their past self and replacing them. so time player might start god tier and shit.
          *   "go" button similar to scratch before resetting.

       */
  }

  String heart (Session s, Player activatingPlayer) {
    s.logger.info("AB: Huh. Looks like a Waste of Heart is going at it.");
    effectsInPlay ++;
    heartField = true;
    String ret = "The ${activatingPlayer.htmlTitle()} begins glowing and a haze of pink code hangs around them. They declare that all ships are canon, and can never sink. They begin altering the very identity of everyone toward this end. <br><Br>";
    List<Player> newPlayers = new List<Player>();
    //since i'm cloning players, give everybody 333 relationship (i.e. make entirely new ones for everyone). will trigger dating.
    for(Player p in s.players) {
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


        if(p.dreamSelf && !p.isDreamSelf) {
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
    for(Player p in s.players) {
      p.generateRelationships(s.players);
      p.renderSelf();// either rendering for first time, or rerendering as new classpect
    }
    savedSession = s;
    //need to load the new images.
    globalCallBack = heartCallBack();
    load(s.players, [],"thisReallyShouldn'tExistAnymoreButIAmLazy");

    return ret; //<--still return tho, not waiting on the async loading
  }

  //yes, this isn't how it should work long term. might make a few blank scenes.
  String heartCallBack() {
    for(Player p in savedSession.players) {
      p.renderSelf();// either rendering for first time, or rerendering as new classpect
    }
  }

  String breath(Session s, Player activatingPlayer) {
    s.logger.info("AB: Huh. Looks like a Waste of Breath is going at it.");
    effectsInPlay ++;
    breathField = true;
    s.rand = new Random(); //breath gets freedom from narrative, true random now, no predictabilitiy.
    //show off that new true randomness:
    String ret = "The ${activatingPlayer.htmlTitle()} begins to glow. Lines of code appear dramatically behind them. ";
    ret += s.rand.pickFrom(<String> ["A wave of mobility washes over SBURB.","All players feel strangely mobile."," SBURB suddenly cares a LOT more about getting the plot moving forwards."]);
    ret += s.rand.pickFrom(<String>[" Somewhere in the distance, you can hear the AuthorBot cursing."," SBURBs narrative control has slipped the reigns entirely. Sessions now have the freedom to do whatever they want."," Huh. Wait. Is this really canon? The Observer visible timeline isn't supposed to go this way, right? "]);
    //TODO once npcs quests are a thing, need to have all active at once.
    ret += "All players can now do all activities every turn.  And... you suddenly get the strange feeling that this session has become a LOT less shareable.";
    for(Player p in s.players) {
      p.addStat("mobility", 413);  //not a hope level of boost, but enough to probably fight most things
    }
    return ret;
  }

  String light(Session s, Player activatingPlayer) {
    //"The Name has been spouting too much hippie gnostic crap, you think they got wasted on the koolaid."
    effectsInPlay ++;
    lightField = true;
    inSpotLight = activatingPlayer; //replaces whoever was there before.
    voidField = false; //overrides the void player.
    activatingPlayer.leader = true;
    activatingPlayer.godDestiny = true; //it's more dramatic if they god tier l8r if they haven't already
    //since they will be replacing everybody in relationships, may as well have one for themself so they don't crash
    activatingPlayer.relationships.add(new Relationship(activatingPlayer, 88888888, activatingPlayer));
    s.logger.info("AB: Huh. Looks like a Waste of Light is going at it.");
    String ret = "The ${activatingPlayer.htmlTitle()} has been spouting too much hippie gnostic crap, you think they got wasted on the Kool-aid.  They seem to ACTUALLY believe they are the most importnt character in Homestuck. Uh. The Session. I meant the session, obviously. ";
    ret += "They distribute luck like some kind of bullshit fairy sprinkling fake as shit fairy dust everywhere, but their REAL ";
    ret += "trick is how they hog all the relevancy no matter how little sense it makes. Oh, huh, looks like they shook loose some extra information, as well.";
    for(Player p in s.players) {
      p.renderSelf(); //to pick up lack of relevancy or whatever
      p.setStat("maxLuck", 88888888);
      p.gnosis += 1; //yes it means they skip whatever effect was supposed to be paired with this, but should increase gnosis ending rate regardless.
    }
    return ret;

  }

  String space(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    effectsInPlay ++;
    s.logger.info("AB: Huh. Looks like a Waste of Space is going at it.");
    /*
          TODO:
          * Cccccccombo sessions.   (with "go" button to keep it from being infinite)
            *   If frog, combo into new session (whether sick or full),
             *   if no frog and can scratch, combo into scratch
             *   gets WEIRD if you enter a purple frog (extra squiddle boss fight with savior?)
     */

  }

  String hope(Session s, Player hopePlayer) {
    s.logger.info("AB: Huh. Looks like a Waste of Hope is going at it.");
    effectsInPlay ++;
    hopeField = true;
    List<String> jakeisms = ["GADZOOKS!", "BOY HOWDY!", "TALLY HO!", "BY GUM", "HOT DAMN"];
    String scream = hopePlayer.aspect.fontTag() + hopePlayer.rand.pickFrom(jakeisms) + "</font>";
    String ret = "The ${hopePlayer.htmlTitle()} begins glowing and screaming dramatically. Lines of SBURBs code light up around them. <div class = 'jake'>$scream</div>";
    ret += "Every aspect of SBURB appears to be aligning itself with their beliefs. ";

    hopePlayer.setStat("power",9001); //i know i can save everyone.
    GameEntity.minPower = 9000; //you have to be be OVER 9000!!!
    gameEntityMinPower = 9000;
    s.sessionHealth = 9001;
    s.stats.ectoBiologyStarted = true; //of COURSE we're not paradox doomed. You'd be crazy to say otherwise.
    s.minimumGristPerPlayer = 1;
    s.expectedGristContributionPerPlayer = 10;
    s.minFrogLevel =1;
    s.goodFrogLevel = 2;
    s.reckoningEndsAt = -100; //plenty of time to handle the reckoning
    ret += "They are dramatically strengthened, and the session is stable and easily winnable. ";
    s.hardStrength = 0; //this means the players 'need help' from the Mayor automatically.
    spawnQueen(s);
    spawnKing(s);
    spawnJack(s);
    hopePlayer.denizen.name = "A small toy snake";
    hopePlayer.denizen.setStat("power",1);
    hopePlayer.denizen.setStat("currentHP",1);
    ret += "Their enemies are made into ridiculous non-threats. ";
    spawnDemocraticArmy(s);
    ret += "The democratic army rallies around this beacon of hope. ";
    ret += "The other players have definitely always been cooperative and sane.  And alive. Very alive. It would be ridiculous to imagine anyone dying. ";
    List<String> insults = <String>["Boy", "Jerk","Ass","Dick","Douche", "Piss","Fuck", "Butt", "Poop", "Chump", "Cad","Scam"];
    bool modEnemies = false;
    bool modCrushes = false;
    for(Player p in s.players) {
      p.dead = false; //NOT .makeAlive  this is denying a fact, not resurrecting.
      p.murderMode = false;
      p.leftMurderMode = false; //never even happened.
      p.setStat("currentHP", 9001);
      p.setStat("sanity", 9001);
      p.renderSelf();
      Relationship r = hopePlayer.getRelationshipWith(p);
      if(r != null && (r.saved_type == r.badBig || r.saved_type == r.spades || r.saved_type == r.clubs)) {
        //yes, this means any players who share your enemies class or aspect get renamed too.
        //but wastes are ALL about the unintended consequences, right?
        s.logger.info("AB: They are renaming ${r.target.aspect.name} and ${r.target.class_name.name}");
        r.target.aspect.name = s.rand.pickFrom(insults);
        r.target.class_name.name = s.rand.pickFrom(insults);
        s.logger.info("AB: Now they are ${r.target.aspect.name} and ${r.target.class_name.name}");

        modEnemies = true;
      }else if(r != null && (r.saved_type == r.goodBig || r.saved_type == r.heart || r.saved_type == r.diamond)) {
        Relationship r2 = p.getRelationshipWith(hopePlayer);
        //r.value = 3333; //testing something
        r2.value = 9001;  //you love me back. not creepy at all
        r2.type();  //they reevaluate what they think about the hope player.
        modCrushes = true;
        s.logger.info("AB: They are making their crush love them ${r.target}");
      }
    }
    if(modCrushes) ret += "The players they like like them back. The Observer doesn't find this creepy at all.";
    if(modEnemies) ret += "The players they hate are made ridiculous objects of mockery. The Observer doesn't find this hilarious at all.";
    return ret;

  }

  String life(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Life is going at it.");
    effectsInPlay ++;
    /*
        TODO:
          * Everyone is trickster
          * makeDead does nothing anymore
          * anybody dead (including enemies) is brought back
          *
     */

  }

  String doom(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    s.logger.info("AB: Huh. Looks like a Waste of Doom is going at it.");
    effectsInPlay ++;
    /*
      TODO:
        * all stats flip
          * healing hurts, hurting heals
          * all stats are multiplied by -1 so high is bad and low is good.
          * all living players are catatonic.  only the dead are avaiable and returned by getLivingPlayers
          * doomed time clones aren't doomed
     */

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