import "../SBURBSim.dart";
//this should handle the most severe of the Gnosis Tiers: The Waste Tier
//these are permanent modifications to sessions and their behavior
//while the lesser shit that are one off things will be in the GainGnosis scenes themselves. (such as writing faqs)
class SessionMutator {
  int effectsInPlay = 0; //more there are, more likely session will crash.
  bool hopeField = false;  //facts about session change
  bool breathField = false; //sets availability to true, will interact with npc quests eventually
  bool heartField = true; //disallows breakups, 'random' relationships are 333, and reasons to date someone is 333 for shipping
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
    effectsInPlay ++;
      /*
          TODO:
          * all players have trickster levels of sanity
          * If scratched, your guardians stats are added to yours.
          *  All stats are averaged, then given back to party.
          *  Session Mutator: pale  quadrant chats happen constantly, even if not quadranted.
          *  once npc update, all npcs are set to "ally" state, even things that are not normally possible.
          *  All players have candy red blood.
          *  new players are allowed to enter session

       */
  }

  String mind(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    effectsInPlay ++;
    /*
      TODO:
        * Yellow Yard like thing prints out immediatly upon reaching this tier. Player shown, not me.
        * TODO: what else fits here, don't want it to just literally be a yellow yard, these wastes suck compared to me
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
    return abjectFailure(s, activatingPlayer);
    effectsInPlay ++;
    /*
        TODO:
          * reroll seed.  rerun session, but NEVER print anything, not even in the void.
          * print ending
          * if Yellow Yard happens, even the choices are blanked (but you can still pick them.)
          *

       */

  }

  String time(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
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
    effectsInPlay ++;
    heartField = true;
    String ret = "The ${activatingPlayer.htmlTitle()} begins glowing and a haze of pink code hangs around them. They declare that all ships are canon, and can never sink. They begin altering the very identity of everyone toward this end. <br><Br>";
    //since i'm cloning players, give everybody 333 relationship (i.e. make entirely new ones for everyone). will trigger dating.
    for(Player p in s.players) {
        ret += "The ${p.htmlTitle()} begins to change.  They no longer enjoy ${p.interest1}.";
        p.interest1 = activatingPlayer.interest1; //you now are required to have one thing in common with the heart player.
        ret += "Instead, they now prefer the clearly superior ${p.interest1}, just like the ${activatingPlayer}.";
        p.aspect = s.rand.pickFrom(Aspects.all);
        p.class_name = s.rand.pickFrom(SBURBClassManager.all);
        ret += "SBURB loses their identity file briefly, and restores it from a corrupt back up.  Now they are the ${p.htmlTitle()}.";

        if(p.dreamSelf && !p.isDreamSelf) {
          Player independantDreamSelf = p.clone();
          independantDreamSelf.chatHandle = "Dream${independantDreamSelf.chatHandle}";
          independantDreamSelf.isDreamSelf = true;
          s.players.add(independantDreamSelf);
          ret += "The ${independantDreamSelf.htmlTitle()}'s dream self awakens on ${independantDreamSelf.moon}.  It is now registered as a full Player, and is unaffected by the alterations to the Real Self's identity.  Does this make them the 'real' verson of the ${independantDreamSelf.htmlTitle()}? ";
        }
    }
    //now includes clones.
    for(Player p in s.players) {
      p.generateRelationships(s.players);
    }
    return ret;
  }

  String breath(Session s, Player activatingPlayer) {
    effectsInPlay ++;
    breathField = true;
    s.rand = new Random(); //breath gets freedom from narrative, true random now, no predictabilitiy.
    //show off that new true randomness:
    String ret = "The $activatingPlayer begins to glow. Lines of code appear dramatically behind them. ";
    ret += s.rand.pickFrom(<String> ["A wave of mobility washes over SBURB.","All players feel strangely mobile."," SBURB suddenly cares a LOT more about getting the plot moving forwards."]);
    ret += s.rand.pickFrom(<String>[" Somewhere in the distance, you can hear the AuthorBot cursing."," SBURBs narrative control has slipped the reigns entirely. Sessions now have the freedom to do whatever they want."," Huh. Wait. Is this really canon? The Observer visible timeline isn't supposed to go this way, right? "]);
    //TODO once npcs quests are a thing, need to have all active at once.
    ret += " You suddenly get the strange feeling that this session has become a LOT less shareable.";
    for(Player p in s.players) {
      p.addStat("mobility", 413);  //not a hope level of boost, but enough to probably fight most things
    }
    return ret;
  }

  String light(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    //"The Name has been spouting too much hippie gnostic crap, you think they got wasted on the koolaid."
    effectsInPlay ++;
    /*TODO
        *EVERything is displayed, not just void.
          *   how to do this with code not being js anymore?
          *   can i co-opt the console printouts to put on screen?
        * all players are VERY LUCKY
        * maybe gives everyone almost waste level gnosis...what else?
        * literal spotlight when rendered, all players set to unavailable except light player, light player is always available
     */

  }

  String space(Session s, Player activatingPlayer) {
    return abjectFailure(s, activatingPlayer);
    effectsInPlay ++;
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


}