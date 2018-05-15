import '../SBURBSim.dart';
import '../includes/lz-string.dart';
import '../navbar.dart';

/*
oh my fucking god 234908u2alsk;d
javascript, you shitty shitty langugage
why the fuck does trying to decode a URI that is null, return the string "null";
why would ANYONE EVER WANT THAT!?????????
javascript is "WAT"ing me
because of COURSE "null" == null is fucking false, so my code is like "oh, i must have some players" and then try to fucking parse!!!!!!!!!!!!!!*/
List<Player> getReplayers(Session session) {
    //needed or i can't parse moon data
    if(session.prospit == null) session.setupMoons("getting replayers");
//	var b = LZString.decompressFromEncodedURIComponent(getRawParameterByName("b"));
    //var available_classes_guardians = classes.sublist(0); //if there are replayers, then i need to reset guardian classes
    String raw = getRawParameterByName("b", null);
    if (raw == null) return <Player>[]; //don't even try getting the rest.
    String b = Uri.decodeComponent(LZString.decompressFromEncodedURIComponent(getRawParameterByName("b", null)));
    String s = LZString.decompressFromEncodedURIComponent(getRawParameterByName("s", null));
    String x = (getRawParameterByName("x", null));
    //;
    if (b == null || s == null) return <Player>[];
    if (b == "null" || s == "null") return <Player>[]; //why was this necesassry????????????????
    ////;
    ////print(b);
    ////;
    ////print(s);
    List<Player> ret =  dataBytesAndStringsToPlayers(session,b, s, x);
    //can't let them keep their null session reference.
    //session.logger.info("replayers are $ret before moon syncing");

    for(Player p in ret) {
        p.session = session;
        p.syncToSessionMoon();
        p.initialize();
    }
    //session.logger.info("replayers are $ret");
    return ret;
}


void syncReplayNumberToPlayerNumber(List<Player> replayPlayers, Session session) {
    if(replayPlayers.isEmpty) return;
    Session session = replayPlayers.first.session;
    if (session.players.length == replayPlayers.length || replayPlayers.isEmpty) return; //nothing to do.

    //foreign players are allowed in, even though it'll jsut be more of the sae
    int max = replayPlayers.length + session.aliensClonedOnArrival.length;
    print("max is ${max} which is ${replayPlayers.length} replayers and ${session.aliensClonedOnArrival.length} aliens");

    if (max < session.players.length) { //gotta destroy some players (you monster);
        num remove_length = session.players.length - max;
        print("I think I need to remove ${remove_length} players from ${session.players.length} to get $max");
        session.players.removeRange(0, remove_length); //TODO check to see if off by one
        return;
    } else if (max > session.players.length) {
        int numNeeded = max - session.players.length;
        ////print("Have: " + session.players.length + " need: " + replayPlayers.length + " think the difference is: " + numNeeded);
        for (int i = 0; i < numNeeded; i++) {
            // //print("making new player: " + i);
            session.players.add(randomPlayerWithClaspect(session, SBURBClassManager.PAGE, Aspects.VOID));
        }
        ////print("Number of players is now: " + session.players.length);
        return;
    }
}




void initializePlayersNoReplayers(List<Player> players, Session session) {
    for (num i = 0; i < players.length; i++) {
        if (players[i].land != null) { //don't reinit aliens, their stats stay how they were cloned.
            players[i].initialize();
            players[i].guardian.initialize();

        }
    }
    players[0].leader == true; //TODO why does this need to happen, why isn't it already true?

}




Player blankPlayerNoDerived(Session session) {
    GameEntity k = PotentialSprite.prototyping_objects[0];
    bool gd = true;
    Moon m = session.prospit;
    //	Player([String name, Session session, this.class_name, this.aspect, this.object_to_prototype, this.moon, this.godDestiny, num id]): super(name, id, session);

    Player p = new Player(session, SBURBClassManager.PAGE, Aspects.VOID, k, m, gd);
    p.interest1 = InterestManager.getRandomInterest(session.rand);
    p.interest2 = InterestManager.getRandomInterest(session.rand);
    p.baby = 1;
    p.hair = 1;
    p.leftHorn = 1;
    p.rightHorn = 1;
    p.quirk = new Quirk(session.rand);
    p.quirk.capitalization = 1;
    p.quirk.punctuation = 1;
    p.quirk.favoriteNumber = 1;
    p.initializeSprite();
    return p;
}


Player randomPlayerNoDerived(Session session, SBURBClass c, Aspect a) {
    GameEntity k = session.rand.pickFrom(PotentialSprite.prototyping_objects);
    k.session = session;


    bool gd = false;

    Moon m = session.rand.pickFrom(session.moons);
    Player p = new Player(session, c, a, k, m, gd);
    p.decideTroll();
    p.interest1 = InterestManager.getRandomInterest(session.rand);
    p.interest2 = InterestManager.getRandomInterest(session.rand);
    p.baby = session.rand.nextIntRange(1, 3);


    p.hair = session.rand.nextIntRange(1, Player.maxHairNumber);
    //hair color in decideTroll.
    p.leftHorn = session.rand.nextIntRange(1, Player.maxHornNumber);
    p.rightHorn = p.leftHorn;
    if (session.rand.nextDouble() > .7) { //preference for symmetry
        p.rightHorn = session.rand.nextIntRange(1, Player.maxHornNumber);
    }
    p.initializeStats();
    p.initializeSprite();


    return p;
}


Player randomPlayerWithClaspect(Session session, SBURBClass c, Aspect a, [Moon m = null]) {
    ////;
   // //;
    GameEntity k = session.rand.pickFrom(PotentialSprite.prototyping_objects);
    k.session = session;

    bool gd = false;

    if(m == null) {
        m = session.rand.pickFrom(session.moons);
        //;
    }else {
       // ;
    }
    Player p = new Player(session, c, a, k, m, gd);
    p.decideTroll();
    p.interest1 = InterestManager.getRandomInterest(session.rand);
    p.interest2 = InterestManager.getRandomInterest(session.rand);
    p.initialize();

    //no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
    p.baby = session.rand.nextIntRange(1, 3);

    p.hair = session.rand.nextIntRange(1, Player.maxHairNumber); //hair color in decide troll
    p.leftHorn = session.rand.nextIntRange(1, 46);
    p.rightHorn = p.leftHorn;
    if (session.rand.nextDouble() > .7) { //preference for symmetry
        p.rightHorn = session.rand.nextIntRange(1, 46);
    }

    return p;
}


Player randomPlayer(Session session) {
    //remove class AND aspect from available
    SBURBClass c = session.rand.pickFrom(session.available_classes_players);
    removeFromArray(c, session.available_classes_players);
    Aspect a = session.rand.pickFrom(session.available_aspects);
    removeFromArray(a, session.available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


Player randomPlayerWithoutRemoving(Session session) {
    //remove class AND aspect from available
    SBURBClass c = session.rand.pickFrom(session.available_classes_players);
    //removeFromArray(c, available_classes);
    Aspect a = session.rand.pickFrom(session.available_aspects);
    //removeFromArray(a, available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


Player randomSpacePlayer(Session session) {
    //remove class from available
    SBURBClass c = session.rand.pickFrom(session.available_classes_players);
    removeFromArray(c, session.available_classes_players);
    Aspect a = Aspects.SPACE;
    removeFromArray(a, session.available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


Player randomTimePlayer(Session session) {
    //remove class from available
    SBURBClass c = session.rand.pickFrom(session.available_classes_players);
    removeFromArray(c, session.available_classes_players);
    Aspect a = Aspects.TIME;
    removeFromArray(a, session.available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


///takes list of players adn aspect i am looking for
Player findAspectPlayer(List<GameEntity> playerList, Aspect aspect) {
    if(playerList.isEmpty) return null;
    Session session = playerList.first.session;
    if(session.mutator.lightField) return session.mutator.inSpotLight;
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite
        if (g is Player) {
            Player p = playerList[i];
            if (p.aspect == aspect) {
                ////;
                return p;
            }
        }
    }
    return null;
}


List<Player> findAllAspectPlayers(List<GameEntity> playerList, Aspect aspect) {
    if(playerList.isEmpty) return <Player>[];
    Session session = playerList.first.session;

    if(session.mutator.lightField && session.mutator.inSpotLight != null) return [session.mutator.inSpotLight];
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite, only work for player
        if (g is Player) {
            Player p = playerList[i];
            if (p.aspect == aspect) {
                ////;
                ret.add(p);
            }
        }
    }
    return ret;
}




//in combo sessions, mibht be more than one rage player, for example.
Player findClaspectPlayer(List<GameEntity> playerList, SBURBClass class_name, Aspect aspect) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite, and they don't have classpects.
        if (g is Player) {
            Player p = playerList[i];
            if (p.class_name == class_name && p.aspect == aspect) {
                ////;
                return p;
            }
        }
    }
    return null;
}


Player findClassPlayer(List<GameEntity> playerList, SBURBClass class_name) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite
        if (g is Player) {
            Player p = playerList[i];
            if (p.class_name == class_name) {
                ////;
                return p;
            }
        }
    }
    return null;
}

Player findMVP(List<Player> playerList) {
    if (playerList.isEmpty) return null;
    Player strongest = playerList[0];

    for (int i = 0; i < playerList.length; i++) {
        GameEntity p = playerList[i];
        if (p.grist > strongest.grist) {
            strongest = p;
        }
    }
    return strongest;
}


Player findStrongestPlayer(List<Player> playerList) {
    if (playerList.isEmpty) return null;
    Player strongest = playerList[0];

    for (int i = 0; i < playerList.length; i++) {
        GameEntity p = playerList[i];
        if (p.getStat(Stats.POWER) > strongest.getStat(Stats.POWER)) {
            strongest = p;
        }
    }
    return strongest;
}


List<T> findDeadPlayers<T extends GameEntity>(List<T> playerList) {
    List<T> ret = <T>[];
    for (int i = 0; i < playerList.length; i++) {
        T p = playerList[i];
        if (p.dead || (playerList[i].session.mutator.doomField && !p.dead)) {
            ret.add(p);
        }
    }
    return ret;
}

List<Player> findDoomedPlayers(List<Player> playerList) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        GameEntity p = playerList[i];
        if (p.doomed) {
            ret.add(p);
        }
    }
    return ret;
}

//TODO shove this somewhere mroe useful, rename so not just players
//take in a generic type as long as it extends generic and return a generic type, you get mix of sprites and players, returns that way.i hope
List<T> findLiving<T extends GameEntity> (List<T> playerList){
    List<T> ret = new List<T>();
    for (int i = 0; i < playerList.length; i++) {
        if (!playerList[i].dead || (playerList[i].session.mutator.doomField && playerList[i].dead )) { //the dead are alive.
            ret.add(playerList[i]);
        }
    }
    return ret;
}

num getPartyPower(List<GameEntity> party) {
    num ret = 0;
    for (int i = 0; i < party.length; i++) {
        ret += party[i].getStat(Stats.POWER);
    }
    return ret;
}

//it says "players" but it won't let me refactor rename it
//any game entity can be passed here, player is a legacy thing
String getPlayersTitlesHP(List<GameEntity> playerList) {
    ////print(playerList);
    if (playerList.isEmpty) {
        return "";
    }
    String ret = playerList[0].htmlTitleHP();
    for (int i = 1; i < playerList.length; i++) {
        ret = "$ret and ${playerList[i].htmlTitleHP()}";
    }
    return ret;
}

//it says "players" but it won't let me refactor rename it
//any game entity can be passed here, player is a legacy thing
String getPlayersTitlesNoHTML(List<GameEntity> playerList) {
    ////print(playerList);
    if (playerList.isEmpty) {
        return "";
    }
    String ret = playerList[0].title();
    for (int i = 1; i < playerList.length; i++) {
        ret = "$ret and ${playerList[i].title()}";
    }
    return ret;
}


//it says "players" but it won't let me refactor rename it
//any game entity can be passed here, player is a legacy thing
String getPlayersTitles(List<GameEntity> playerList) {
    ////print(playerList);
    if (playerList.isEmpty) {
        return "";
    }
    String ret = playerList[0].htmlTitle();
    for (int i = 1; i < playerList.length; i++) {
        ret = "$ret and ${playerList[i].htmlTitle()}";
    }
    return ret;
}

//it says "players" but it won't let me refactor rename it
//any game entity can be passed here, player is a legacy thing
num partyRollForLuck(List<GameEntity> players) {
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].rollForLuck();
    }
    return ret / players.length;
}


String getPlayersTitlesBasic(List<GameEntity> playerList) {
    if (playerList.isEmpty) {
        return "";
    }
    String ret = playerList[0].htmlTitleBasic();
    for (int i = 1; i < playerList.length; i++) {
        ret = "$ret and ${playerList[i].htmlTitleBasic()}";
    }
    return ret;
}


List<Player> findPlayersWithDreamSelves(List<Player> playerList) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        if (p.dreamSelf && !p.isDreamSelf) {
            ret.add(p);
        }
    }
    return ret;
}


List<Player> findPlayersWithoutDreamSelves(List<Player> playerList) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        if (!p.dreamSelf || p.isDreamSelf) { //if you ARE your dream self, then when you go to sleep....
            ret.add(p);
        }
    }
    return ret;
}


//don't override existing source
void setEctobiologicalSource(List<Player> playerList, num source) {
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        Player g = p.guardian; //not doing this caused a bug in session 149309 and probably many, many others.
        if (p.ectoBiologicalSource == null) {
            p.ectoBiologicalSource = source;
            if(g != null) g.ectoBiologicalSource = source;
        }
    }
}


List<Player> findPlayersWithoutEctobiologicalSource(List<Player> playerList) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        if (p.ectoBiologicalSource == null) {
            ret.add(p);
        }
    }
    return ret;
}



//deeper than a snapshot, for yellowyard aliens
//have to treat properties that are objects differently. luckily i think those are only player and relationships.
Player clonePlayer(Player player, Session session, bool isGuardian) {
    if(player == null) return null;
    Player clone = player.clone();
    if (!isGuardian && clone.guardian != null) {  //tier4 gnosis can make some weird shit happen
        Player g = clonePlayer(player.guardian, session, true);
        clone.guardian = g;
        g.guardian = clone;
    }
    //;
    return clone;
}


List<Player> findPlayersFromSessionWithId(List<Player> playerList, num source) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        //if it' snull, you could be from here, but not yet ectoborn
        if (p.ectoBiologicalSource == source || p.ectoBiologicalSource == null) {
            ret.add(p);
        }
    }
    return ret;
}


String findBadPrototyping(List<Player> playerList) {
    for (int i = 0; i < playerList.length; i++) {
        if ((playerList[i].object_to_prototype != null) && playerList[i].object_to_prototype.getStat(Stats.POWER)  >= 200 * Stats.POWER.coefficient) {
            return (playerList[i].object_to_prototype.htmlTitle());
        }
    }
    return null;
}

String findGoodPrototyping(List<Player> playerList) {
    for (int i = 0; i < playerList.length; i++) {
        if ((playerList[i].object_to_prototype != null) && playerList[i].object_to_prototype.illegal == true) {
           return (playerList[i].object_to_prototype.htmlTitle());
        }
    }
    return null;
}


List<Player> getGuardiansForPlayers(List<Player> playerList) {
    List<Player> tmp = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player g = playerList[i].guardian;
        if(i == 0) g.leader = true;
        tmp.add(g);
    }
    return tmp;
}

num getTotalGrist(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].grist;
    }
    return ret;
}

num getAverageGrist(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].grist;
    }
    return (ret / players.length).round();
}

String getPVPQuip(Player deadPlayer, Player victor, String deadRole, String victorRole) {
    if(deadPlayer.class_name == victor.class_name) return "Anything goes when you fight your own class, I guess.";

    if (victor.getPVPModifier(victorRole) > deadPlayer.getPVPModifier(deadRole)) {
        return "Which is pretty much how you expected things to go down between a ${deadPlayer.class_name} and a ${victor.class_name} in that exact situation. ";
    } else {
        return "Which is weird because you would expect the ${deadPlayer.class_name} to have a clear advantage. Guess echeladder rank really does matter?";
    }
}

//used to recover form mind control, with a few extra things for planned shit.
class MiniSnapShot {
    Player player;
    List<Relationship> relationships;
    bool murderMode;

    num grimDark;
    bool isTroll;
    SBURBClass class_name;
    Aspect aspect;


    MiniSnapShot(this.player) {
        relationships = player.relationships;
        murderMode = player.murderMode;
        grimDark = player.grimDark;
        isTroll = player.isTroll;
        class_name = player.class_name;
        aspect = player.aspect;
    }


    void restoreState(Player player) {
        player.relationships = this.relationships;
        player.murderMode = this.murderMode;
        player.grimDark = this.grimDark;
        player.isTroll = this.isTroll;
        player.class_name = this.class_name;
        player.aspect = this.aspect;
        player.stateBackup = null; //no longer need to keep track of old state.
    }

}