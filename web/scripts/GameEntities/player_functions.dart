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
List<Player> getReplayers() {
//	var b = LZString.decompressFromEncodedURIComponent(getRawParameterByName("b"));
    //var available_classes_guardians = classes.sublist(0); //if there are replayers, then i need to reset guardian classes
    String raw = getRawParameterByName("b", null);
    if (raw == null) return <Player>[]; //don't even try getting the rest.
    String b = Uri.decodeComponent(LZString.decompressFromEncodedURIComponent(getRawParameterByName("b", null)));
    String s = LZString.decompressFromEncodedURIComponent(getRawParameterByName("s", null));
    String x = LZString.decompressFromEncodedURIComponent(getRawParameterByName("x", null));
    if (b == null || s == null) return <Player>[];
    if (b == "null" || s == "null") return <Player>[]; //why was this necesassry????????????????
    //print("b is");
    //print(b);
    //print("s is ");
    //print(s);
    return dataBytesAndStringsToPlayers(b, s, x);
}


void syncReplayNumberToPlayerNumber(List<Player> replayPlayers) {
    if (curSessionGlobalVar.players.length == replayPlayers.length || replayPlayers.isEmpty) return; //nothing to do.

    if (replayPlayers.length < curSessionGlobalVar.players.length) { //gotta destroy some players (you monster);
        num remove_length = curSessionGlobalVar.players.length - replayPlayers.length;
        curSessionGlobalVar.players.removeRange(0, remove_length); //TODO check to see if off by one
        return;
    } else if (replayPlayers.length > curSessionGlobalVar.players.length) {
        int numNeeded = replayPlayers.length - curSessionGlobalVar.players.length;
        //print("Have: " + curSessionGlobalVar.players.length + " need: " + replayPlayers.length + " think the difference is: " + numNeeded);
        for (int i = 0; i < numNeeded; i++) {
            // print("making new player: " + i);
            curSessionGlobalVar.players.add(randomPlayerWithClaspect(curSessionGlobalVar, "Page", "Void"));
        }
        //print("Number of players is now: " + curSessionGlobalVar.players.length);
        return;
    }
}


//this code is needed to make sure replay players have guardians.
void redoRelationships(List<Player> players) {
    List<Player> guardians = <Player>[];
    print("redoing relationships");
    for (num j = 0; j < players.length; j++) {
        Player p = players[j];
        guardians.add(p.guardian);
        p.relationships.clear();
        p.generateRelationships(curSessionGlobalVar.players);
        p.initializeRelationships();
    }

    for (num j = 0; j < guardians.length; j++) {
        Player p = guardians[j];
        p.relationships.clear();
        p.generateRelationships(guardians);
        p.initializeRelationships();
    }
}


void initializePlayers(List<Player> players, Session session) {
    List<Player> replayPlayers = getReplayers();
    if (replayPlayers.isEmpty && session != null) replayPlayers = session.replayers; //<-- probably blank too, but won't be for fan oc easter eggs.
    syncReplayNumberToPlayerNumber(replayPlayers);
    for (num i = 0; i < players.length; i++) {
        if (replayPlayers.length > i) players[i].copyFromPlayer(replayPlayers[i]); //DOES NOT use MORE PLAYERS THAN SESSION HAS ROOM FOR, BUT AT LEAST WON'T CRASH ON LESS.
        if (players[i].land != null) { //don't reinit aliens, their stats stay how they were cloned.
            players[i].initialize();
            players[i].guardian.initialize();
            if (replayPlayers.length > i) {
                players[i].quirk.favoriteNumber = replayPlayers[i].quirk.favoriteNumber; //int.parse(replayPlayers[i].quirk.favoriteNumber, onError:(String input) => 0) ;//has to be after initialization;
                if (players[i].isTroll) {
                    players[i].quirk.makeTrollQuirk(players[i]); //redo quirk
                } else {
                    players[i].quirk.makeHumanQuirk(players[i]);
                }
            }
        }
    }
    if (!replayPlayers.isEmpty) {
        redoRelationships(players); //why was i doing this, this overrides robot and gim dark and initial relationships
        //oh because it makes replayed sessions with scratches crash.
    }
}


void initializePlayersNoDerived(List<Player> players, Session session) {
    List<Player> replayPlayers = getReplayers();
    for (num i = 0; i < players.length; i++) {
        if (replayPlayers[i] != null) players[i].copyFromPlayer(replayPlayers[i]); //DOES NOT use MORE PLAYERS THAN SESSION HAS ROOM FOR, BUT AT LEAST WON'T CRASH ON LESS.
        players[i].initializeStats();
        players[i].initializeSprite();
    }

    //might not be needed.   futureJadedResearcher (FJR) has begun pestering pastJadedResearcher(PJR).  FJR: Yeah, no shit sherlock
    if (!replayPlayers.isEmpty) {
        redoRelationships(players); //why was i doing this, this overrides robot and gim dark and initial relationships
        //oh because it makes replayed sessions with scratches crash.
    }
}


String getColorFromAspect(String aspect) {
    String color = "";
    if (aspect == "Space") {
        color = "#00ff00";
    } else if (aspect == "Time") {
        color = "#ff0000";
    } else if (aspect == "Breath") {
        color = "#3399ff";
    } else if (aspect == "Doom") {
        color = "#003300";
    } else if (aspect == "Blood") {
        color = "#993300";
    } else if (aspect == "Heart") {
        color = "#ff3399";
    } else if (aspect == "Mind") {
        color = "#3da35a";
    } else if (aspect == "Light") {
        color = "#ff9933";
    } else if (aspect == "Void") {
        color = "#000066";
    } else if (aspect == "Rage") {
        color = "#9900cc";
    } else if (aspect == "Hope") {
        color = "#ffcc66";
    } else if (aspect == "Life") {
        color = "#494132";
    } else {
        color = "#efefef";
    }
    return color;
}


String getShirtColorFromAspect(String aspect) {
    String color = "";
    if (aspect == "Space") {
        color = "#030303";
    } else if (aspect == "Time") {
        color = "#b70d0e";
    } else if (aspect == "Breath") {
        color = "#0087eb";
    } else if (aspect == "Doom") {
        color = "#204020";
    } else if (aspect == "Blood") {
        color = "#3d190a";
    } else if (aspect == "Heart") {
        color = "#6b0829";
    } else if (aspect == "Mind") {
        color = "#3da35a";
    } else if (aspect == "Light") {
        color = "#ff7f00";
    } else if (aspect == "Void") {
        color = "#000066";
    } else if (aspect == "Rage") {
        color = "#9900cc";
    } else if (aspect == "Hope") {
        color = "#ffe094";
    } else if (aspect == "Life") {
        color = "#ccc4b5";
    }
    return color;
}


String getDarkShirtColorFromAspect(String aspect) {
    String color = "";
    if (aspect == "Space") {
        color = "#242424";
    } else if (aspect == "Time") {
        color = "#970203";
    } else if (aspect == "Breath") {
        color = "#0070ED";
    } else if (aspect == "Doom") {
        color = "#11200F";
    } else if (aspect == "Blood") {
        color = "#2C1207";
    } else if (aspect == "Heart") {
        color = "#6B0829";
    } else if (aspect == "Mind") {
        color = "#3DA35A";
    } else if (aspect == "Light") {
        color = "#D66E04";
    } else if (aspect == "Void") {
        color = "#02285B";
    } else if (aspect == "Rage") {
        color = "#1E0C47";
    } else if (aspect == "Hope") {
        color = "#E8C15E";
    } else if (aspect == "Life") {
        color = "#CCC4B5";
    }
    return color;
}


String getFontColorFromAspect(String aspect) {
    return "<font color='${getColorFromAspect(aspect)}'> ";
}


Player blankPlayerNoDerived(Session session) {
    GameEntity k = prototyping_objects[0];
    bool gd = true;
    String m = "Prospit";
    //	Player([String name, Session session, this.class_name, this.aspect, this.object_to_prototype, this.moon, this.godDestiny, num id]): super(name, id, session);

    Player p = new Player(session, "Page", "Void", k, m, gd);
    p.interest1 = interests[0];
    p.interest2 = interests[0];
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


Player randomPlayerNoDerived(Session session, String c, String a) {
    GameEntity k = session.rand.pickFrom(prototyping_objects);


    bool gd = false;

    String m = session.rand.pickFrom(moons);
    Player p = new Player(session, c, a, k, m, gd);
    p.decideTroll();
    p.interest1 = session.rand.pickFrom(interests);
    p.interest2 = session.rand.pickFrom(interests);
    p.baby = session.rand.nextIntRange(1, 3);


    p.hair = session.rand.nextIntRange(1, p.maxHairNumber);
    //hair color in decideTroll.
    p.leftHorn = session.rand.nextIntRange(1, p.maxHornNumber);
    p.rightHorn = p.leftHorn;
    if (session.rand.nextDouble() > .7) { //preference for symmetry
        p.rightHorn = session.rand.nextIntRange(1, p.maxHornNumber);
    }
    p.initializeStats();
    p.initializeSprite();


    return p;
}


Player randomPlayerWithClaspect(Session session, String c, String a) {
    //print("random player");

    GameEntity k = session.rand.pickFrom(prototyping_objects);


    bool gd = false;

    String m = session.rand.pickFrom(moons);
    Player p = new Player(session, c, a, k, m, gd);
    p.decideTroll();
    p.interest1 = session.rand.pickFrom(interests);
    p.interest2 = session.rand.pickFrom(interests);
    p.initialize();

    //no longer any randomness directly in player class. don't want to eat seeds if i don't have to.
    p.baby = session.rand.nextIntRange(1, 3);


    p.hair = session.rand.nextIntRange(1, p.maxHairNumber); //hair color in decide troll
    p.leftHorn = session.rand.nextIntRange(1, 46);
    p.rightHorn = p.leftHorn;
    if (session.rand.nextDouble() > .7) { //preference for symmetry
        p.rightHorn = session.rand.nextIntRange(1, 46);
    }


    return p;
}


Player randomPlayer(Session session) {
    //remove class AND aspect from available
    String c = session.rand.pickFrom(available_classes);
    removeFromArray(c, available_classes);
    String a = session.rand.pickFrom(available_aspects);
    removeFromArray(a, available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


dynamic randomPlayerWithoutRemoving(Session session) {
    //remove class AND aspect from available
    String c = session.rand.pickFrom(available_classes);
    //removeFromArray(c, available_classes);
    String a = session.rand.pickFrom(available_aspects);
    //removeFromArray(a, available_aspects);
    return randomPlayerWithClaspect(session, c, a);
}


Player randomSpacePlayer(Session session) {
    //remove class from available
    String c = session.rand.pickFrom(available_classes);
    removeFromArray(c, available_classes);
    String a = required_aspects[0];
    return randomPlayerWithClaspect(session, c, a);
}


Player randomTimePlayer(Session session) {
    //remove class from available
    String c = session.rand.pickFrom(available_classes);
    removeFromArray(c, available_classes);
    String a = required_aspects[1];
    return randomPlayerWithClaspect(session, c, a);
}


Player findAspectPlayer(List<GameEntity> playerList, String aspect) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite
        if (g is Player) {
            Player p = playerList[i];
            if (p.aspect == aspect) {
                //print("Found " + aspect + " player");
                return p;
            }
        }
    }
    return null;
}


List<Player> findAllAspectPlayers(List<GameEntity> playerList, String aspect) {
    List<Player> ret = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite, only work for player
        if (g is Player) {
            Player p = playerList[i];
            if (p.aspect == aspect) {
                //print("Found " + aspect + " player");
                ret.add(p);
            }
        }
    }
    return ret;
}


Player getLeader(List<Player> playerList) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //leader MUST be player
        if (g is Player) {
            Player p = playerList[i];
            if (p.leader) {
                return p;
            }
        }
    }
    return null;
}


//in combo sessions, mibht be more than one rage player, for example.
Player findClaspectPlayer(List<GameEntity> playerList, String class_name, String aspect) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite, and they don't have classpects.
        if (g is Player) {
            Player p = playerList[i];
            if (p.class_name == class_name && p.aspect == aspect) {
                //print("Found " + class_name + " player");
                return p;
            }
        }
    }
    return null;
}


Player findClassPlayer(List<GameEntity> playerList, String class_name) {
    for (int i = 0; i < playerList.length; i++) {
        GameEntity g = playerList[i]; //could be a sprite
        if (g is Player) {
            Player p = playerList[i];
            if (p.class_name == class_name) {
                //print("Found " + class_name + " player");
                return p;
            }
        }
    }
    return null;
}


Player findStrongestPlayer(List<Player> playerList) {
    if (playerList.isEmpty) return null;
    Player strongest = playerList[0];

    for (int i = 0; i < playerList.length; i++) {
        GameEntity p = playerList[i];
        if (p.getStat("power") > strongest.getStat("power")) {
            strongest = p;
        }

    }
    return strongest;
}


List<T> findDeadPlayers<T extends GameEntity>(List<T> playerList) {
    List<T> ret = <T>[];
    for (int i = 0; i < playerList.length; i++) {
        T p = playerList[i];
        if (p.dead) {
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
List<T> findLivingPlayers<T extends GameEntity> (List<T> playerList){
    List<T> ret = new List<T>();
    for (int i = 0; i < playerList.length; i++) {
        if (!playerList[i].dead) {
            ret.add(playerList[i]);
        }
    }
    return ret;
}


num getPartyPower(List<GameEntity> party) {
    num ret = 0;
    for (int i = 0; i < party.length; i++) {
        ret += party[i].getStat("power");
    }
    return ret;
}

//it says "players" but it won't let me refactor rename it
//any game entity can be passed here, player is a legacy thing
String getPlayersTitlesHP(List<GameEntity> playerList) {
    //print(playerList);
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
    //print(playerList);
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
    //print(playerList);
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
            g.ectoBiologicalSource = source;
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
    Player clone = player.clone();
    if (!isGuardian) {
        Player g = clonePlayer(player.guardian, session, true);
        clone.guardian = g;
        g.guardian = clone;
    }
    print("returning clone $clone");
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
        if (playerList[i].object_to_prototype.getStat("power") >= 200) {
            return (playerList[i].object_to_prototype.htmlTitle());
        }
    }
    return null;
}


Player findHighestMobilityPlayer(List<Player> playerList) {
    if (playerList.isEmpty) return null; //it's empty you dunkass
    Player ret = playerList[0];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        if (p.getStat("mobility") > ret.getStat("mobility")) {
            ret = p;
        }
    }
    return ret;
}


Player findLowestMobilityPlayer(List<Player> playerList) {
    Player ret = playerList[0];
    for (int i = 0; i < playerList.length; i++) {
        Player p = playerList[i];
        if (p.getStat("mobility") < ret.getStat("mobility")) {
            ret = p;
        }
    }
    return ret;
}


String findGoodPrototyping(List<Player> playerList) {
    for (int i = 0; i < playerList.length; i++) {
        if (playerList[i].object_to_prototype.illegal == true) {
            //print("found good");
            return (playerList[i].object_to_prototype.htmlTitle());
        }
    }
    return null;
}


List<Player> getGuardiansForPlayers(List<Player> playerList) {
    List<Player> tmp = <Player>[];
    for (int i = 0; i < playerList.length; i++) {
        Player g = playerList[i].guardian;
        tmp.add(g);
    }
    return tmp;
}


//mobility is "natural" way to sort players but this works, too.
List<Player> sortPlayersByFreeWill(List<Player> players) {
    return new List<Player>.from(players)
        ..sort((Player a, Player b) {
            return a.getStat("freeWill") - b.getStat("freeWill");
        });
}


num compareFreeWill(Player a, Player b) {
    return b.getStat("freeWill") - a.getStat("freeWill");
}

num getAverageMinLuck(List<Player> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (num i = 0; i < players.length; i++) {
        ret += players[i].getStat("minLuck");
    }
    return (ret / players.length).round();
}


num getAverageMaxLuck(List<Player> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("maxLuck");
    }
    return (ret / players.length).round();
}


num getAverageSanity(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("sanity");
    }
    return (ret / players.length).round();
}


num getAverageHP(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("hp");
    }
    return (ret / players.length).round();
}


dynamic getAverageMobility(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("mobility");
    }
    return (ret / players.length).round();
}


dynamic getAverageRelationshipValue(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("RELATIONSHIPS");
    }
    return (ret / players.length).round();
}


num getAveragePower(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("power");
    }
    return (ret / players.length).round();
}


String getPVPQuip(Player deadPlayer, Player victor, String deadRole, String victorRole) {
    if (victor.getPVPModifier(victorRole) > deadPlayer.getPVPModifier(deadRole)) {
        return "Which is pretty much how you expected things to go down between a ${deadPlayer.class_name} and a ${victor.class_name} in that exact situation. ";
    } else {
        return "Which is weird because you would expect the ${deadPlayer.class_name} to have a clear advantage. Guess echeladder rank really does matter?";
    }
}


num getAverageFreeWill(List<GameEntity> players) {
    if (players.isEmpty) return 0;
    num ret = 0;
    for (int i = 0; i < players.length; i++) {
        ret += players[i].getStat("freeWill");
    }
    return (ret / players.length).round();
}


//used to recover form mind control, with a few extra things for planned shit.
class MiniSnapShot {
    Player player;
    List<Relationship> relationships;
    bool murderMode;

    num grimDark;
    bool isTroll;
    String class_name;
    String aspect;


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