import "dart:html";

import "SBURBSim.dart";

//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values that don't match the values in the current session summary.

class SessionSummary {
    //since stats will be hash, don't need to make junior
    int session_id = null;
    Session parentSession; //pretty sure this has to be a full session so i can get lineage
    bool scratched = false;
    num frogLevel = 0;
    List<Player> ghosts = <Player>[];

    //the two hashes are for big masses of stats that i just blindly print to screen.
    Map<String, bool> bool_stats = <String, bool>{}; //most things
    Map<String, num> num_stats = <String, num>{}; //num_living etc
    String frogStatus; //doesn't need to be in a hash.
    List<Map<String, String>> miniPlayers = <Map<String, String>>[]; //array of hashes from players
    List<Player> players = <Player>[]; //TODO do i need this AND that miniPlayers thing???
    Player mvp;


    SessionSummary(int this.session_id);

    void setBoolStat(String statName, bool statValue) {
        print("setting stat: $statName to $statValue");
        this.bool_stats[statName] = statValue;
    }

    bool getBoolStat(String statName) {
        bool ret = this.bool_stats[statName];
        if (ret == null) {
            this.bool_stats[statName] = false;
            return false;
        }
        return ret;
    }

    void setNumStat(String statName, num statValue) {
        this.num_stats[statName] = statValue;
    }

    num getNumStat(String statName) {
        num ret = this.num_stats[statName];
        if (ret == null) throw "What Kind of Stat is: $statName???";
        return ret;
    }


    void setMiniPlayers(List<Player> players) {
        for (num i = 0; i < players.length; i++) {
            this.miniPlayers.add(<String, String>{"class_name": players[i].class_name, "aspect": players[i].aspect});
        }
    }

    bool matchesClass(List<String> classes) {
        for (num i = 0; i < classes.length; i++) {
            String class_name = classes[i];
            for (num j = 0; j < this.miniPlayers.length; j++) {
                Map<String, String> miniPlayer = this.miniPlayers[j];
                if (miniPlayer["class_name"] == class_name) return true;
            }
        }
        return false;
    }

    bool matchesAspect(List<String> aspects) {
        for (num i = 0; i < aspects.length; i++) {
            String aspect = aspects[i];
            for (num j = 0; j < this.miniPlayers.length; j++) {
                Map<String, String> miniPlayer = this.miniPlayers[j];
                if (miniPlayer["aspect"] == aspect) return true;
            }
        }
        return false;
    }

    bool miniPlayerMatchesAnyClasspect(Map<String, String> miniPlayer, List<String> classes, List<String> aspects) {
        //is my class in the class array AND my aspect in the aspect array.
        if (classes.contains(miniPlayer["class_name"]) && aspects.contains(miniPlayer["aspect"])) return true;
        return false;
    }

    bool matchesBothClassAndAspect(List<String> classes, List<String> aspects) {
        for (num j = 0; j < this.miniPlayers.length; j++) {
            if (this.miniPlayerMatchesAnyClasspect(this.miniPlayers[j], classes, aspects)) return true;
        }
        return false;
    }

    bool matchesClasspect(List<String> classes, List<String> aspects) {
        if (!aspects.isEmpty && classes.isEmpty) {
            return this.matchesAspect(aspects);
        } else if (!classes.isEmpty && aspects.isEmpty) {
            return this.matchesClass(classes);
        } else if (!aspects.isEmpty && !classes.isEmpty) {
            return this.matchesBothClassAndAspect(classes, aspects);
        } else {
            print('debugging ab: no classes or aspects passed');
            return true; //no filters, all are accepted.
        }
    }

    bool satifies_filter_array(List<String> filter_array) {
        //print(filter_array);
        for (int i = 0; i < filter_array.length; i++) {
            String filter = filter_array[i];

            if (filter == "numberNoFrog") {
                if (this.frogStatus != "No Frog") {
                    //	print("not no frog");
                    return false;
                }
            } else if (filter == "numberSickFrog") {
                if (this.frogStatus != "Sick Frog") {
                    //print("not sick frog");
                    return false;
                }
            } else if (filter == "numberFullFrog") {
                if (this.frogStatus != "Full Frog") {
                    //print("not full frog");
                    return false;
                }
            } else if (filter == "numberPurpleFrog") {
                if (this.frogStatus != "Purple Frog") {
                    //print("not full frog");
                    return false;
                }
            } else if (filter == "timesAllDied") {
                if (this.getNumStat("numLiving") != 0) {
                    //print("not all dead");
                    return false;
                }
            } else if (filter == "timesAllLived") {
                if (this.getNumStat("numDead") != 0) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
                    //print("not all alive");
                    return false;
                }
            } else if (filter == "comboSessions") {
                if (this.parentSession == null) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want that.
                    //print("not combo session");
                    return false;
                }
            } else if (this.getBoolStat(filter) == null && this.getNumStat(filter) == null) {
                //print("property not true: " + filter);
                return false;
            }
        }
        //print("i pass all filters");
        return true;
    }

    dynamic decodeLineageGenerateHTML() {
        String html = "";
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1); //what am i doing with params here?
        if (params == window.location.href) params = "";
        List<Session> lineage = this.parentSession.getLineage(); //i am not a session so remember to tack myself on at the end.
        String scratched = "";
        if (lineage[0].scratched) scratched = "(scratched)";
        html = "$html<Br><b> Session</b>: <a href = 'index2.html?seed=${lineage[0].session_id}&$params'>${lineage[0].session_id}$scratched</a> ";
        for (num i = 1; i < lineage.length; i++) {
            String scratched = "";
            if (lineage[i].scratched) scratched = "(scratched)";
            html = "$html combined with: <a href = 'index2.html?seed=${lineage[i].session_id}&$params'>${lineage[i].session_id}$scratched</a> ";
        }
        scratched = "";
        if (this.getBoolStat("scratched")) scratched = "(scratched)";
        html = "$html combined with: <a href = 'index2.html?seed=${this.session_id.toString()}&$params'>${this.session_id.toString()}$scratched</a> ";
        if ((lineage.length + 1) == 3) {
            this.setBoolStat("threeTimesSessionCombo", true);
            html = "$html 3x SESSIONS COMBO!!!";
        }
        if ((lineage.length + 1) == 4) {
            this.setBoolStat("fourTimesSessionCombo", true);
            html = "$html 4x SESSIONS COMBO!!!!";
        }
        if ((lineage.length + 1 ) == 5) {
            this.setBoolStat("fiveTimesSessionCombo", true);
            html = "$html 5x SESSIONS COMBO!!!!!";
        }
        if ((lineage.length + 1) > 5) {
            this.setBoolStat("holyShitMmmmmonsterCombo", true);
            html = "$html The session pile doesn't stop from getting taller. ";
        }
        return html;
    }

    dynamic getSessionSummaryJunior() {
        return new SessionSummaryJunior(this.players, this.session_id);
    }

    String generateNumHTML() {
        String html = "";
        for (String key in num_stats.keys) {
            html = "$html<Br><b>$key</b>: ${getNumStat(key)}";
        }
        return html;
    }

    String generateBoolHTML() {
        String html = "";
        for (String key in bool_stats.keys) {
            html = "$html<Br><b>$key</b>: ${getBoolStat(key)}";
        }
        return html;
    }

    String generateHTML() {
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        String html = "<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'>";

        if (this.parentSession != null) {
            html = "$html${this.decodeLineageGenerateHTML()}";
        } else {
            String scratch = "";
            if (this.scratched) scratch = "(scratched)";

            html = "$html<Br><b> Session</b>: <a href = 'index2.html?seed=${this.session_id}&$params'>${this.session_id}$scratch</a>";
        }
        html = "$html${generateNumHTML()}";
        html = "$html${generateBoolHTML()}";
        html = "$html<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}";
        html = "$html<Br><b>mvp</b>: ${this.mvp.htmlTitle()} With a Power of: ${this.mvp.getStat("power")}";
        html = "$html<Br><b>Frog Level</b>: ${this.frogLevel} (${this.frogStatus})";


        html = "$html</div><br>";
        return html;
    }

    //todo, could make this a constructor with from, too. whatever.
    static SessionSummary makeSummaryForSession(Session session) {
        SessionSummary summary = new SessionSummary(session.session_id);
        summary.setMiniPlayers(session.players);
        summary.setBoolStat("blackKingDead", session.king.dead || session.king.getStat("currentHP") <= 0);
        summary.setBoolStat("mayorEnding", session.mayorEnding);
        summary.setBoolStat("waywardVagabondEnding", session.waywardVagabondEnding);
        summary.setBoolStat("badBreakDeath", session.badBreakDeath);
        summary.setBoolStat("luckyGodTier", session.luckyGodTier);
        summary.setBoolStat("choseGodTier", session.choseGodTier);
        summary.scratched = session.scratched;
        summary.setBoolStat("opossumVictory", session.opossumVictory);
        summary.setBoolStat("rocksFell", session.rocksFell);
        summary.setBoolStat("won", session.won);
        summary.setBoolStat("hasBreakups", session.hasBreakups);
        summary.ghosts = session.afterLife.ghosts;
        summary.setNumStat("sizeOfAfterLife", session.afterLife.ghosts.length);
        summary.setBoolStat("heroicDeath", session.heroicDeath);
        summary.setBoolStat("justDeath", session.justDeath);
        summary.setBoolStat("crashedFromSessionBug", session.crashedFromSessionBug);
        summary.setBoolStat("crashedFromPlayerActions", session.crashedFromPlayerActions);
        summary.setBoolStat("hasFreeWillEvents", session.hasFreeWillEvents);
        summary.setNumStat("averageMinLuck", getAverageMinLuck(session.players));
        summary.setNumStat("averageMaxLuck", getAverageMaxLuck(session.players));
        summary.setNumStat("averagePower", getAveragePower(session.players));
        summary.setNumStat("averageMobility", getAverageMobility(session.players));
        summary.setNumStat("averageFreeWill", getAverageFreeWill(session.players));
        summary.setNumStat("averageHP", getAverageHP(session.players));
        summary.setNumStat("averageRelationshipValue", getAverageRelationshipValue(session.players));
        summary.setNumStat("averageSanity", getAverageSanity(session.players));
        summary.session_id = session.session_id;
        summary.setBoolStat("hasLuckyEvents", session.goodLuckEvent);
        summary.setBoolStat("hasUnluckyEvents", session.badLuckEvent);
        summary.setBoolStat("rapBattle", session.rapBattle);
        summary.setBoolStat("sickFires", session.sickFires);
        summary.frogStatus = session.frogStatus();
        summary.setBoolStat("godTier", session.godTier);
        summary.setBoolStat("questBed", session.questBed);
        summary.setBoolStat("sacrificialSlab", session.sacrificialSlab);
        summary.setNumStat("num_scenes", session.numScenes);
        summary.players = session.players;
        summary.mvp = findStrongestPlayer(session.players);
        summary.parentSession = session.parentSession;
        summary.setBoolStat("scratchAvailable", session.scratchAvailable);
        summary.setBoolStat("yellowYard", session.yellowYard);
        summary.setNumStat("numLiving", findLivingPlayers(session.players).length);
        summary.setNumStat("numDead", findDeadPlayers(session.players).length);
        summary.setBoolStat("ectoBiologyStarted", session.ectoBiologyStarted);
        summary.setBoolStat("denizenBeat", session.denizenBeat);
        summary.setBoolStat("plannedToExileJack", session.plannedToExileJack);
        summary.setBoolStat("exiledJack", session.jack.exiled);
        summary.setBoolStat("exiledQueen", session.queen.exiled);
        summary.setBoolStat("jackGotWeapon", session.jackGotWeapon);
        summary.setBoolStat("jackRampage", session.jackRampage);
        summary.setBoolStat("jackScheme", session.jackScheme);
        summary.setBoolStat("kingTooPowerful", session.king.getStat("power") > session.hardStrength);
        summary.setBoolStat("queenRejectRing", session.queenRejectRing);
        summary.setBoolStat("democracyStarted", session.democraticArmy.getStat("power") > 0);
        summary.setBoolStat("murderMode", session.murdersHappened);
        summary.setBoolStat("grimDark", session.grimDarkPlayers);

        Player spacePlayer = session.findBestSpace();
        Player corruptedSpacePlayer = session.findMostCorruptedSpace();
        if (spacePlayer == null) {
            summary.frogLevel = 0;
        } else if (summary.frogStatus == "Purple Frog") {
            summary.frogLevel = corruptedSpacePlayer.landLevel;
        } else {
            summary.frogLevel = spacePlayer.landLevel;
        }

        summary.setBoolStat("hasDiamonds", session.hasDiamonds);
        summary.setBoolStat("hasSpades", session.hasSpades);
        summary.setBoolStat("hasClubs", session.hasClubs);
        summary.setBoolStat("hasHearts", session.hasHearts);
        return summary;
    }

}

//junior only cares about players.
class SessionSummaryJunior {
    List<Player> players = <Player>[];
    num session_id;
    List<Ship> ships = <Ship>[];
    num averageMinLuck = 0;
    num averageMaxLuck = 0;
    num averagePower = 0;
    num averageMobility = 0;
    num averageFreeWill = 0;
    num averageHP = 0;
    num averageRelationshipValue = 0;
    num averageSanity = 0;


    SessionSummaryJunior(this.players, this.session_id) {}


    dynamic generateHTML() {
        this.getAverages();
        String params = window.location.href.substring(window.location.href.indexOf("?") + 1);
        if (params == window.location.href) params = "";
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'>")
            ..write("<Br><b> Session</b>: <a href = 'index2.html?seed=${this.session_id}&$params'>${this.session_id}</a>")
            ..write("<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}")
            ..write("<Br><b>Potential God Tiers</b>: ${getPlayersTitlesBasic(this.grabPotentialGodTiers())}")
            ..write("<Br><b>Initial Average Min Luck</b>: ${this.averageMinLuck}")
            ..write("<Br><b>Initial Average Max Luck</b>: ${this.averageMaxLuck}")
            ..write("<Br><b>Initial Average Power</b>: ${this.averagePower}")
            ..write("<Br><b>Initial Average Mobility</b>: ${this.averageMobility}")
            ..write("<Br><b>Initial Average Free Will</b>: ${this.averageFreeWill}")
            ..write("<Br><b>Initial Average HP</b>: ${this.averageHP}")
            ..write("<Br><b>Initial Relationship Value</b>: ${this.averageRelationshipValue}")
            ..write("<Br><b>Initial Trigger Level</b>: ${this.averageRelationshipValue}")
            ..write("<Br><b>Sprites</b>: ${this
                            .grabAllSprites()}")
            ..write("<Br><b>Lands</b>: ${this.grabAllLands()}")
            ..write("<Br><b>Interests</b>: ${this.grabAllInterest()}")
            ..write("<Br><b>Initial Ships</b>:<Br> ${this.initialShips()}")
            ..write("</div><br>");
        return html.toString();
    }

    void getAverages() {
        this.averageMinLuck = getAverageMinLuck(this.players);
        this.averageMaxLuck = getAverageMaxLuck(this.players);
        this.averagePower = getAveragePower(this.players);
        this.averageMobility = getAverageMobility(this.players);
        this.averageFreeWill = getAverageFreeWill(this.players);
        this.averageHP = getAverageHP(this.players);
        this.averageRelationshipValue = getAverageRelationshipValue(this.players);
        this.averageRelationshipValue = getAverageSanity(this.players);
    }

    List<Player> grabPotentialGodTiers() {
        List<Player> ret = <Player>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            if (player.godDestiny) ret.add(player);
        }
        return ret;
    }

    List<String> grabAllInterest() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.interest1);
            ret.add(player.interest2);
        }
        return ret;
    }

    List<String> grabAllSprites() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.object_to_prototype.htmlTitle());
        }
        return ret;
    }

    List<String> grabAllLands() {
        List<String> ret = <String>[];
        for (num i = 0; i < this.players.length; i++) {
            Player player = this.players[i];
            ret.add(player.land);
        }
        return ret;
    }

    String initialShips() {
        UpdateShippingGrid shipper = new UpdateShippingGrid(null);
        if (this.ships == null || this.ships.isEmpty) { //thought this was haunted but turns out ABJ is explicity allowed to pass nulls here
            shipper.createShips(this.players, null);
            this.ships = shipper.getGoodShips(null);
        }
        return shipper.printShips(this.ships);
    }

}


//only initial stats.
class MultiSessionSummaryJunior {
    //small enough i'm not gonna bother hashing it out
    num numSessions = 0;
    num numPlayers = 0;
    num numShips = 0;
    num averageMinLuck = 0;
    num averageMaxLuck = 0;
    num averagePower = 0;
    num averageMobility = 0;
    num averageFreeWill = 0;
    num averageHP = 0;
    num averageRelationshipValue = 0;
    num averageSanity = 0;


    MultiSessionSummaryJunior();

    static MultiSessionSummaryJunior collateMultipleSessionSummariesJunior(List<SessionSummaryJunior>sessionSummaryJuniors) {
        MultiSessionSummaryJunior mss = new MultiSessionSummaryJunior();
        if (sessionSummaryJuniors.isEmpty) return mss; //don't bother, and definitely don't try to average on zero things.
        mss.numSessions = sessionSummaryJuniors.length;
        for (num i = 0; i < sessionSummaryJuniors.length; i++) {
            SessionSummaryJunior ssj = sessionSummaryJuniors[i];
            mss.numPlayers += ssj.players.length;
            mss.numShips += ssj.ships.length;
            mss.averageMinLuck += ssj.averageMinLuck;
            mss.averageMaxLuck += ssj.averageMaxLuck;
            mss.averagePower += ssj.averagePower;
            mss.averageMobility += ssj.averageMobility;
            mss.averageFreeWill += ssj.averageFreeWill;
            mss.averageHP += ssj.averageHP;
            mss.averageSanity += ssj.averageSanity;
            mss.averageRelationshipValue += ssj.averageRelationshipValue;
        }

        mss.averageMinLuck = (mss.averageMinLuck / sessionSummaryJuniors.length).round();
        mss.averageMaxLuck = (mss.averageMaxLuck / sessionSummaryJuniors.length).round();
        mss.averagePower = (mss.averagePower / sessionSummaryJuniors.length).round();
        mss.averageMobility = (mss.averageMobility / sessionSummaryJuniors.length).round();
        mss.averageFreeWill = (mss.averageFreeWill / sessionSummaryJuniors.length).round();
        mss.averageHP = (mss.averageHP / sessionSummaryJuniors.length).round();
        mss.averageSanity = (mss.averageSanity / sessionSummaryJuniors.length).round();
        mss.averageRelationshipValue = (mss.averageRelationshipValue / sessionSummaryJuniors.length).round();
        return mss;
    }


    String generateHTML() {
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'multiSessionSummary' id = 'multiSessionSummary'>")
            ..write("<h2>Stats for All Displayed Sessions: </h2><br>")
            ..write("<Br><b>Number of Sessions:</b> $numSessions ")
            ..write("<Br><b>Average Players Per Session: ${this.numPlayers / this.numSessions}</b> ")
            ..write("<Br><b>averageMinLuck:</b> $averageMinLuck")
            ..write("<Br><b>averageMaxLuck:</b> $averageMaxLuck")
            ..write("<Br><b>averagePower:</b>$averagePower ")
            ..write("<Br><b>averageMobility:</b>$averageMobility ")
            ..write("<Br><b>averageFreeWill: $averageFreeWill</b> ")
            ..write("<Br><b>averageHP:</b> $averageHP")
            ..write("<Br><b>averageRelationshipValue:</b> $averageRelationshipValue")
            ..write("<Br><b>averageSanity:</b> $averageSanity")
            ..write("<Br><b>Average Initial Ships Per Session:</b> ${this.numShips / this
                            .numSessions} ")
            ..write("<Br><br><b>Filter Sessions By Number of Players:</b><Br>2 <input id='num_players' type='range' min='2' max='12' value='2'> 12")
            ..write("<br><input type='text' id='num_players_text' value='2' size='2' disabled>")
            //on click will be job of code that appends this. cuz can't do inline anymore

            ..write("<br><br><button id = 'buttonFilter'>Filter Sessions</button>")
            ..write("</div><Br>");
        return html.toString();
    }

}

class MultiSessionSummary {
    List<Player> ghosts = <Player>[]; //what is this type? Player? String? (it's Player -PL)
    List<String> checkedCorpseBoxes = <String>[];
    Map<String, num> num_stats = <String, num>{};
    Map<String, num> classes = <String, num>{};
    Map<String, num> aspects = <String, num>{};


    MultiSessionSummary() {
        //can switch order to change order AB displays in
        //if i don't initialize stats here, then AB won't bothe rlisting stats that are zero.
        setStat("total", 0);
        setStat("totalDeadPlayers", 0);
        setStat("timesAllDied", 0);
        setStat("yellowYard", 0);
        setStat("scratchAvailable", 0);
        setStat("blackKingDead", 0);
        setStat("luckyGodTier", 0);
        setStat("choseGodTier", 0);
        setStat("waywardVagabondEnding", 0);
        setStat("mayorEnding", 0);
        setStat("badBreakDeath", 0);
        setStat("timesAllLived", 0);
        setStat("ectoBiologyStarted", 0);
        setStat("denizenBeat", 0);
        setStat("plannedToExileJack", 0);
        setStat("exiledJack", 0);
        setStat("exiledQueen", 0);
        setStat("jackGotWeapon", 0);
        setStat("jackRampage", 0);
        setStat("jackScheme", 0);
        setStat("kingTooPowerful", 0);
        setStat("queenRejectRing", 0);
        setStat("democracyStarted", 0);
        setStat("murderMode", 0);
        setStat("grimDark", 0);
        setStat("hasHearts", 0);
        setStat("hasDiamonds", 0);
        setStat("hasSpades", 0);
        setStat("hasClubs", 0);
        setStat("hasBreakups", 0);
        setStat("hasDiamonds", 0);
        setStat("hasSpades", 0);
        setStat("hasClubs", 0);
        setStat("hasBreakups", 0);
        setStat("comboSessions", 0);
        setStat("threeTimesSessionCombo", 0);
        setStat("fourTimesSessionCombo", 0);
        setStat("fiveTimesSessionCombo", 0);
        setStat("holyShitMmmmmonsterCombo", 0);
        setStat("numberNoFrog", 0);
        setStat("numberSickFrog", 0);
        setStat("numberFullFrog", 0);
        setStat("numberPurpleFrog", 0);
        setStat("godTier", 0);
        setStat("questBed", 0);
        setStat("sacrificialSlab", 0);
        setStat("justDeath", 0);
        setStat("heroicDeath", 0);
        setStat("rapBattle", 0);
        setStat("sickFires", 0);
        setStat("hasLuckyEvents", 0);
        setStat("hasUnluckyEvents", 0);
        setStat("hasFreeWillEvents", 0);
        setStat("scratched", 0);
        setStat("won", 0);
        setStat("crashedFromPlayerActions", 0);
        setStat("rocksFell", 0);
        setStat("opossumVictory", 0);
        setStat("crashedFromSessionBug", 0);
    }

    num getNumStat(String statName) {
        num ret = this.num_stats[statName]; //initialization, not error
        if (ret == null) {
            this.num_stats[statName] = 0;
            return 0;
        }
        return ret;
    }

    void addNumStat(String statName, num value) {
        if (this.num_stats[statName] == null) this.num_stats[statName] = 0;
        this.num_stats[statName] += value;
    }

    void setStat(String statName, num value) {
        if (this.num_stats[statName] == null) this.num_stats[statName] = 0;
        this.num_stats[statName] = value;
    }

    void incNumStat(String statName) {
        addNumStat(statName, 1);
    }


    void setClasses() {
        List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage"];
        for (num i = 0; i < labels.length; i++) {
            this.classes[labels[i]] = 0;
        }
    }

    void integrateClasses(List<Map<String, String>> miniPlayers) {
        for (num i = 0; i < miniPlayers.length; i++) {
            this.classes[miniPlayers[i]["class_name"]] ++;
        }
    }

    void integrateAspects(List<Map<String, String>> miniPlayers) {
        for (num i = 0; i < miniPlayers.length; i++) {
            this.aspects[miniPlayers[i]["aspect"]] ++;
        }
    }

    void setAspects() {
        List<String> labels = <String>["Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        for (num i = 0; i < labels.length; i++) {
            this.aspects[labels[i]] = 0;
        }
    }

    void filterCorpseParty(MultiSessionSummary that) {
        List<Player> filteredGhosts = <Player>[];
        that.checkedCorpseBoxes = <String>[]; //reset
        bool classFiltered = !querySelectorAll("input:checkbox[name=CorpsefilterClass]:checked").isEmpty;
        bool aspectFiltered = !querySelectorAll("input:checkbox[name=CorpsefilterAspect]:checked").isEmpty;
        for (num i = 0; i < that.ghosts.length; i++) {
            Player ghost = that.ghosts[i];
            //add self to filtered ghost if my class OR my aspect is checked. How to tell?  .is(":checked");
            if (classFiltered && !aspectFiltered) {
                if ((querySelector("#${ghost.class_name}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else if (aspectFiltered && !classFiltered) {
                if ((querySelector("#${ghost.aspect}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else if (aspectFiltered && classFiltered) {
                if ((querySelector("#${ghost.class_name}") as CheckboxInputElement).checked && (querySelector("#${ghost.aspect}") as CheckboxInputElement).checked) {
                    filteredGhosts.add(ghost);
                }
            } else {
                //nothing filtered.
                filteredGhosts.add(ghost);
            }
        } //end for loop

        List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage", "Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        bool noneChecked = true;
        for (num i = 0; i < labels.length; i++) {
            String l = labels[i];
            if ((querySelector("#$l") as CheckboxInputElement).checked) {
                that.checkedCorpseBoxes.add(l);
                noneChecked = false;
            }
        }

        if (noneChecked) filteredGhosts = that.ghosts;
        //none means 'all' basically
        querySelector("#multiSessionSummaryCorpseParty").setInnerHtml(that.generateCorpsePartyInnerHTML(filteredGhosts));
        that.wireUpCorpsePartyCheckBoxes();
    }


    void wireUpCorpsePartyCheckBoxes() {
        //i know what the labels are, they are just the classes and aspects.
        MultiSessionSummary that = this;
        List<String> labels = <String>["Knight", "Seer", "Bard", "Maid", "Heir", "Rogue", "Page", "Thief", "Sylph", "Prince", "Witch", "Mage", "Blood", "Mind", "Rage", "Time", "Void", "Heart", "Breath", "Light", "Space", "Hope", "Life", "Doom"];
        for (num i = 0; i < labels.length; i++) {
            String l = labels[i];
            querySelector("#$l").onChange.listen((Event e) {
                that.filterCorpseParty(that);
            });
        }

        for (num i = 0; i < this.checkedCorpseBoxes.length; i++) {
            String l = this.checkedCorpseBoxes[i];
            (querySelector("#$l") as CheckboxInputElement).checked = true;
        }
    }

    String generateHTMLForClassPropertyCorpseParty(String label, num value, num total) {
        //		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
        String input = "<input type='checkbox' name='CorpsefilterClass' value='$label' id='$label'>";
        int average = 0;
        if (total != 0) average = (100 * value / total).round();
        String html = "<Br>$input$label: $value($average%)";
        return html;
    }

    String generateHTMLForAspectPropertyCorpseParty(String label, num value, num total) {
        //		//<input disabled='true' type='checkbox' name='filter' value='"+propertyName +"' id='" + propertyName + "' onchange='filterSessionSummaries()'>"
        String input = "<input type='checkbox' name='CorpsefilterAspect' value='$label' id='$label'>";
        num average = 0;
        if (total != 0) average = (100 * value / total).round(); //stop dividing by zero, dunkass.
        String html = "<Br>$input$label: $value($average%)";
        return html;
    }

    String generateCorpsePartyHTML(List<Player> filteredGhosts) {
        String html = "<div class = 'multiSessionSummary'>Corpse Party: (filtering here will ONLY modify the corpse party, not the other boxes) <button id = 'corpseButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryCorpseParty'>";
        html = "$html${this.generateCorpsePartyInnerHTML(filteredGhosts)}";
        html = "$html</div></div>";
        return html;
    }

    String generateCorpsePartyInnerHTML(List<Player> filteredGhosts) {
        //first task. convert ghost array to map. or hash. or whatever javascript calls it. key is what I want to display on the left.
        //value is how many times I see something that evaluates to that key.
        // about players killing each other.  look for "died being put down like a rabid dog" and ignore the rest.  or  "fighting against the crazy X" to differentiate it from STRIFE.
        //okay, everything else should be fine. this'll probably still be pretty big, but can figure out how i wanna compress it later. might make all minion/denizen fights compress down to "first goddamn boss fight" and "denizen fight" respectively, but not for v1. want to see if certain
        //aspect have  a rougher go of it.
        Map<String, int> corpsePartyClasses = <String, int>{"Knight": 0, "Seer": 0, "Bard": 0, "Maid": 0, "Heir": 0, "Rogue": 0, "Page": 0, "Thief": 0, "Sylph": 0, "Prince": 0, "Witch": 0, "Mage": 0};
        Map<String, int> corpsePartyAspects = <String, int>{"Blood": 0, "Mind": 0, "Rage": 0, "Time": 0, "Void": 0, "Heart": 0, "Breath": 0, "Light": 0, "Space": 0, "Hope": 0, "Life": 0, "Doom": 0};
        Map<String, int> corpseParty = <String, int>{}; //now to refresh my memory on how javascript hashmaps work;
        String html = "<br><b>  Number of Ghosts: </b>: ${filteredGhosts.length}";
        for (int i = 0; i < filteredGhosts.length; i++) {
            Player ghost = filteredGhosts[i];
            if (ghost.causeOfDeath.startsWith("fighting against the crazy")) {
                if (corpseParty["fighting against a MurderMode player"] == null) corpseParty["fighting against a MurderMode player"] = 0; //otherwise NaN;
                corpseParty["fighting against a MurderMode player"] ++;
            } else if (ghost.causeOfDeath.startsWith("being put down like a rabid dog")) {
                if (corpseParty["being put down like a rabid dog"] == null) corpseParty["being put down like a rabid dog"] = 0; //otherwise NaN;
                corpseParty["being put down like a rabid dog"] ++;
            } else if (ghost.causeOfDeath.contains("Minion")) {
                if (corpseParty["fighting a Denizen Minion"] == null) corpseParty["fighting a Denizen Minion"] = 0; //otherwise NaN;
                corpseParty["fighting a Denizen Minion"] ++;
            } else { //just use as is
                if (corpseParty[ghost.causeOfDeath] == null) corpseParty[ghost.causeOfDeath] = 0; //otherwise NaN;
                corpseParty[ghost.causeOfDeath] ++;
            }

            if (corpsePartyClasses[ghost.class_name] == null) corpsePartyClasses[ghost.class_name] = 0; //otherwise NaN;
            if (corpsePartyAspects[ghost.aspect] == null) corpsePartyAspects[ghost.aspect] = 0; //otherwise NaN;
            corpsePartyAspects[ghost.aspect] ++;
            corpsePartyClasses[ghost.class_name] ++;
        }

        for (String corpseType in corpsePartyClasses.keys) {
            html = "$html${this.generateHTMLForClassPropertyCorpseParty(corpseType, corpsePartyClasses[corpseType], filteredGhosts.length)}";
        }

        for (String corpseType in corpsePartyAspects.keys) {
            html = "$html${this.generateHTMLForAspectPropertyCorpseParty(corpseType, corpsePartyAspects[corpseType], filteredGhosts.length)}";
        }

        for (String corpseType in corpseParty.keys) {
            html = "$html<Br>$corpseType: ${corpseParty[corpseType]}(${(100 * corpseParty[corpseType] / filteredGhosts.length).round()}%)"; //todo maybe print out percentages here. we know how many ghosts there are.;
        }
        return html;
    }

    bool isRomanceProperty(String propertyName) {
        return propertyName == "hasDiamonds" || propertyName == "hasSpades" || propertyName == "hasClubs" || propertyName == "hasHearts" || propertyName == "hasBreakups";
    }

    bool isDramaticProperty(String propertyName) {
        if (propertyName == "exiledJack" || propertyName == "plannedToExileJack" || propertyName == "exiledQueen" || propertyName == "jackGotWeapon" || propertyName == "jackScheme") return true;
        if (propertyName == "kingTooPowerful" || propertyName == "queenRejectRing" || propertyName == "murderMode" || propertyName == "grimDark" || propertyName == "denizenFought") return true;
        if (propertyName == "denizenBeat" || propertyName == "godTier" || propertyName == "questBed" || propertyName == "sacrificialSlab" || propertyName == "heroicDeath") return true;
        if (propertyName == "justDeath" || propertyName == "rapBattle" || propertyName == "sickFires" || propertyName == "hasLuckyEvents" || propertyName == "hasUnluckyEvents") return true;
        if (propertyName == "hasFreeWillEvents" || propertyName == "jackRampage" || propertyName == "democracyStarted") return true;
        return false;
    }

    bool isEndingProperty(String propertyName) {
        if (propertyName == "yellowYard" || propertyName == "timesAllLived" || propertyName == "timesAllDied" || propertyName == "scratchAvailable" || propertyName == "won") return true;
        if (propertyName == "crashedFromPlayerActions" || propertyName == "ectoBiologyStarted" || propertyName == "comboSessions" || propertyName == "threeTimesSessionCombo") return true;
        if (propertyName == "fourTimesSessionCombo" || propertyName == "fiveTimesSessionCombo" || propertyName == "holyShitMmmmmonsterCombo" || propertyName == "numberFullFrog") return true;
        if (propertyName == "numberPurpleFrog" || propertyName == "numberFullFrog" || propertyName == "numberSickFrog" || propertyName == "numberNoFrog" || propertyName == "rocksFell" || propertyName == "opossumVictory") return true;
        if (propertyName == "blackKingDead" || propertyName == "mayorEnding" || propertyName == "waywardVagabondEnding") return true;
        return false;
    }

    bool isAverageProperty(String propertyName) {
        return propertyName == "sizeOfAfterLife" || propertyName == "averageAfterLifeSize" || propertyName == "averageSanity" || propertyName == "averageRelationshipValue" || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck";
    }

    bool isPropertyToIgnore(String propertyName) {
        if (propertyName == "totalLivingPlayers" || propertyName == "survivalRate" || propertyName == "ghosts" || propertyName == "generateCorpsePartyHTML" || propertyName == "generateHTML") return true;
        if (propertyName == "generateCorpsePartyInnerHTML" || propertyName == "isRomanceProperty" || propertyName == "isDramaticProperty" || propertyName == "isEndingProperty" || propertyName == "isAverageProperty" || propertyName == "isPropertyToIgnore") return true;
        if (propertyName == "wireUpCorpsePartyCheckBoxes" || propertyName == "isFilterableProperty" || propertyName == "generateClassFilterHTML" || propertyName == "generateAspectFilterHTML" || propertyName == "generateHTMLForProperty" || propertyName == "generateRomanceHTML") return true;
        if (propertyName == "filterCorpseParty" || propertyName == "generateHTMLForClassPropertyCorpseParty" || propertyName == "generateHTMLForAspectPropertyCorpseParty" || propertyName == "generateDramaHTML" || propertyName == "generateMiscHTML" || propertyName == "generateAverageHTML" || propertyName == "generateHTMLOld" || propertyName == "generateEndingHTML") return true;
        if (propertyName == "setAspects" || propertyName == "setClasses" || propertyName == "integrateAspects" || propertyName == "integrateClasses" || propertyName == "classes" || propertyName == "aspects") return true;
        if (propertyName == "wireUpClassCheckBoxes" || propertyName == "checkedCorpseBoxes" || propertyName == "wireUpAspectCheckBoxes" || propertyName == "filterClaspects") return true;
//

        return false;
    }

    bool isFilterableProperty(String propertyName) {
        return !(propertyName == "sizeOfAfterLife" || propertyName == "averageNumScenes" || propertyName == "averageAfterLifeSize" || propertyName == "averageSanity" || propertyName == "averageRelationshipValue" || propertyName == "averageHP" || propertyName == "averageFreeWill" || propertyName == "averageMobility" || propertyName == "averagePower" || propertyName == "averageMaxLuck" || propertyName == "averageMinLuck");
    }

    String generateHTML() {
        StringBuffer html = new StringBuffer()
            ..write("<div class = 'multiSessionSummary' id = 'multiSessionSummary'>");
        String header = "<h2>Stats for All Displayed Sessions: </h2>(When done finding, can filter)";
        html.write("$html$header");

        List<String> romanceProperties = <String>[];
        List<String> dramaProperties = <String>[];
        List<String> endingProperties = <String>[];
        List<String> averageProperties = <String>[];
        List<String> miscProperties = <String>[]; //catchall if i missed something.

        for (String propertyName in this.num_stats.keys) {
            if (propertyName == "total") { //it's like a header.
                html.write("$html<Br><b> ");
                html.write("$propertyName</b>: ${this.num_stats[propertyName]}");
                int avg = 0;
                if (this.num_stats["total"] != 0) avg = (100 * (this.num_stats[propertyName] / this.num_stats["total"])).round();
                html.write(" ($avg%)");
            } else if (propertyName == "totalDeadPlayers") {
                html.write("<Br><b>totalDeadPlayers: </b> ${this.num_stats['totalDeadPlayers']} (${this.num_stats['survivalRate']}% survival rate)"); //don't want to EVER ignore this.
            } else if (propertyName == "crashedFromSessionBug") {
                html.write(this.generateHTMLForProperty(propertyName)); //don't ignore bugs, either.;
            } else if (this.isRomanceProperty(propertyName)) {
                romanceProperties.add(propertyName);
            } else if (this.isDramaticProperty(propertyName)) {
                dramaProperties.add(propertyName);
            } else if (this.isEndingProperty(propertyName)) {
                endingProperties.add(propertyName);
            } else if (this.isAverageProperty(propertyName)) {
                averageProperties.add(propertyName);
            } else if (!this.isPropertyToIgnore(propertyName)) {
                miscProperties.add(propertyName);
            }
        }
        html
            ..write("</div><br>")
            ..write(this.generateRomanceHTML(romanceProperties))
            ..write(this.generateDramaHTML(dramaProperties))
            ..write(this.generateMiscHTML(miscProperties))
            ..write(this.generateEndingHTML(endingProperties))
            ..write(this.generateClassFilterHTML())
            ..write(this.generateAspectFilterHTML())
            ..write(this.generateAverageHTML(averageProperties))
            ..write(this.generateCorpsePartyHTML(this.ghosts))
        //MSS and SS will need list of classes and aspects. just strings. nothing beefier.
        //these will have to be filtered in a special way. just render and display stats for now, though. no filtering.

            
            ..write("</div><Br>");
        return html.toString();
    }

    String generateClassFilterHTML() {
        String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryClasses'>Classes:";
        for (String propertyName in this.classes.keys) {
            String input = "<input type='checkbox' name='filterClass' value='$propertyName' id='class$propertyName' >";
            html = "$html<Br>$input$propertyName: ${this.classes[propertyName]} ( ${(100 * this.classes[propertyName] / this.num_stats['total']).round()}%)";
        }
        html = "$html</div>";
        return html;
    }

    String generateAspectFilterHTML() {
        String html = "<div class = 'multiSessionSummary topAligned' id = 'multiSessionSummaryAspects'>Aspects:";
        for (String propertyName in this.aspects.keys) {
            String input = "<input type='checkbox' name='filterAspect' value='$propertyName' id='class$propertyName'>";
            html = "$html<Br>$input$propertyName: ${this.aspects[propertyName]} ( ${(100 * this.aspects[propertyName] / this.num_stats['total']).round()}%)";
        }
        html = "$html</div>";
        return html;
    }

    String generateHTMLForProperty(String propertyName) {
        String html = "";
        if (this.isFilterableProperty(propertyName)) {
            html = "$html<Br><b> <input disabled='true' type='checkbox' name='filter' value='$propertyName' id='$propertyName'>";
            html = "$html$propertyName</b>: ${this.num_stats[propertyName]}";
            int avg = 0;
            if (this.num_stats['total'] != 0) avg = (100 * (this.num_stats[propertyName] / this.num_stats['total'])).round();
            html = "$html ($avg%)";
        } else {
            html = "$html<br><b>$propertyName</b>: ${this.num_stats[propertyName]}";
        }
        return html;
    }

    String generateRomanceHTML(List<String> properties) {
        String html = "<div class='bottomAligned multiSessionSummary'>Romance: <button id = 'romanceButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryRomance' >";
        for (int i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        //print(html);
        return html;
    }

    String generateDramaHTML(List<String> properties) {
        String html = "<div class = 'bottomAligned multiSessionSummary' >Drama: <button id = 'dramaButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryDrama' >";
        for (int i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateEndingHTML(List<String> properties) {
        String html = "<div class = 'topligned multiSessionSummary'>Ending: <button id = 'endingButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryEnding' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateMiscHTML(List<String> properties) {
        String html = "<div class = 'bottomAligned multiSessionSummary' >Misc <button id = 'miscButton'>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryMisc' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }

    String generateAverageHTML(List<String> properties) {
        String html = "<div class = 'topAligned multiSessionSummary' >Averages <button id = 'averageButton''>Toggle View </button>";
        html = "$html<div id = 'multiSessionSummaryAverage' >";
        for (num i = 0; i < properties.length; i++) {
            String propertyName = properties[i];
            html = "$html${this.generateHTMLForProperty(propertyName)}";
        }
        html = "$html</div></div>";
        return html;
    }


    static MultiSessionSummary collateMultipleSessionSummaries(List<SessionSummary> sessionSummaries) {
        MultiSessionSummary mss = new MultiSessionSummary();
        mss.setClasses();
        mss.setAspects();
        if (sessionSummaries.isEmpty) return mss; //nothing to do here.
        for (SessionSummary ss in sessionSummaries) {
            mss.incNumStat("total");
            mss.integrateAspects(ss.miniPlayers);
            mss.integrateClasses(ss.miniPlayers);

            if (ss.getBoolStat("badBreakDeath")) mss.incNumStat("badBreakDeath");
            if (ss.getBoolStat("mayorEnding")) mss.incNumStat("mayorEnding");
            if (ss.getBoolStat("waywardVagabondEnding")) mss.incNumStat("waywardVagabondEnding");
            if (ss.getBoolStat("choseGodTier")) mss.incNumStat("choseGodTier");
            if (ss.getBoolStat("luckyGodTier")) mss.incNumStat("luckyGodTier");
            if (ss.getBoolStat("blackKingDead")) mss.incNumStat("blackKingDead");
            if (ss.getBoolStat("crashedFromSessionBug")) mss.incNumStat("crashedFromSessionBug");
            if (ss.getBoolStat("opossumVictory")) mss.incNumStat("opossumVictory");
            if (ss.getBoolStat("rocksFell")) mss.incNumStat("rocksFell");
            if (ss.getBoolStat("crashedFromPlayerActions")) mss.incNumStat("crashedFromPlayerActions");
            if (ss.getBoolStat("scratchAvailable")) mss.incNumStat("scratchAvailable");
            if (ss.getBoolStat("yellowYard")) mss.incNumStat("yellowYard");
            if (ss.getNumStat("numLiving") == 0) mss.incNumStat("timesAllDied");
            if (ss.getNumStat("numDead") == 0) mss.incNumStat("timesAllLived");
            if (ss.getBoolStat("ectoBiologyStarted")) mss.incNumStat("ectoBiologyStarted");
            if (ss.getBoolStat("denizenBeat")) mss.incNumStat("denizenBeat");
            if (ss.getBoolStat("plannedToExileJack")) mss.incNumStat("plannedToExileJack");
            if (ss.getBoolStat("exiledJack")) mss.incNumStat("exiledJack");
            if (ss.getBoolStat("exiledQueen")) mss.incNumStat("exiledQueen");
            if (ss.getBoolStat("jackGotWeapon")) mss.incNumStat("jackGotWeapon");
            if (ss.getBoolStat("jackRampage")) mss.incNumStat("jackRampage");
            if (ss.getBoolStat("jackScheme")) mss.incNumStat("jackScheme");
            if (ss.getBoolStat("kingTooPowerful")) mss.incNumStat("kingTooPowerful");
            if (ss.getBoolStat("queenRejectRing")) mss.incNumStat("queenRejectRing");
            if (ss.getBoolStat("democracyStarted")) mss.incNumStat("democracyStarted");
            if (ss.getBoolStat("murderMode")) mss.incNumStat("murderMode");
            if (ss.getBoolStat("grimDark")) mss.incNumStat("grimDark");
            if (ss.getBoolStat("hasDiamonds")) mss.incNumStat("hasDiamonds");
            if (ss.getBoolStat("hasSpades")) mss.incNumStat("hasSpades");
            if (ss.getBoolStat("hasClubs")) mss.incNumStat("hasClubs");
            if (ss.getBoolStat("hasBreakups")) mss.incNumStat("hasBreakups");
            if (ss.getBoolStat("hasHearts")) mss.incNumStat("hasHearts");
            if (ss.getBoolStat("parentSession")) mss.incNumStat("comboSessions");
            if (ss.getBoolStat("threeTimesSessionCombo")) mss.incNumStat("threeTimesSessionCombo");
            if (ss.getBoolStat("fourTimesSessionCombo")) mss.incNumStat("fourTimesSessionCombo");
            if (ss.getBoolStat("fiveTimesSessionCombo")) mss.incNumStat("fiveTimesSessionCombo");
            if (ss.getBoolStat("holyShitMmmmmonsterCombo")) mss.incNumStat("holyShitMmmmmonsterCombo");
            if (ss.frogStatus == "No Frog") mss.incNumStat("numberNoFrog");
            if (ss.frogStatus == "Sick Frog") mss.incNumStat("numberSickFrog");
            if (ss.frogStatus == "Full Frog") mss.incNumStat("numberFullFrog");
            if (ss.frogStatus == "Purple Frog") mss.incNumStat("numberPurpleFrog");
            if (ss.getBoolStat("godTier")) mss.incNumStat("godTier");
            if (ss.getBoolStat("questBed")) mss.incNumStat("questBed");
            if (ss.getBoolStat("sacrificialSlab")) mss.incNumStat("sacrificialSlab");
            if (ss.getBoolStat("justDeath")) mss.incNumStat("justDeath");
            if (ss.getBoolStat("heroicDeath")) mss.incNumStat("heroicDeath");
            if (ss.getBoolStat("rapBattle")) mss.incNumStat("rapBattle");
            if (ss.getBoolStat("sickFires")) mss.incNumStat("sickFires");
            if (ss.getBoolStat("hasLuckyEvents")) mss.incNumStat("hasLuckyEvents");
            if (ss.getBoolStat("hasUnluckyEvents")) mss.incNumStat("hasUnluckyEvents");
            if (ss.getBoolStat("hasFreeWillEvents")) mss.incNumStat("hasFreeWillEvents");
            if (ss.scratched) mss.incNumStat("scratched");

            if (ss.getBoolStat("won")) mss.incNumStat("won");

            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.ghosts.addAll(ss.ghosts);
            mss.addNumStat("sizeOfAfterLife", ss.getNumStat("sizeOfAfterLife"));
            mss.addNumStat("averageMinLuck", ss.getNumStat("averageMinLuck"));
            mss.addNumStat("averageMaxLuck", ss.getNumStat("averageMaxLuck"));
            mss.addNumStat("averagePower", ss.getNumStat("averagePower"));
            mss.addNumStat("averageMobility", ss.getNumStat("averageMobility"));
            mss.addNumStat("averageFreeWill", ss.getNumStat("averageFreeWill"));
            mss.addNumStat("averageHP", ss.getNumStat("averageHP"));
            mss.addNumStat("averageSanity", ss.getNumStat("averageSanity"));
            mss.addNumStat("averageRelationshipValue", ss.getNumStat("averageRelationshipValue"));
            mss.addNumStat("averageNumScenes", ss.getNumStat("num_scenes"));

            mss.addNumStat("totalDeadPlayers", ss.getNumStat("numDead"));
            mss.addNumStat("totalLivingPlayers", ss.getNumStat("numLiving"));
        }
        mss.setStat("averageAfterLifeSize", (mss.getNumStat("sizeOfAfterLife") / sessionSummaries.length).round());
        mss.setStat("averageMinLuck", (mss.getNumStat("averageMinLuck") / sessionSummaries.length).round());
        mss.setStat("averageMaxLuck", (mss.getNumStat("averageMaxLuck") / sessionSummaries.length).round());
        mss.setStat("averagePower", (mss.getNumStat("averagePower") / sessionSummaries.length).round());
        mss.setStat("averageMobility", (mss.getNumStat("averageMobility") / sessionSummaries.length).round());
        mss.setStat("averageFreeWill", (mss.getNumStat("averageFreeWill") / sessionSummaries.length).round());
        mss.setStat("averageHP", (mss.getNumStat("averageHP") / sessionSummaries.length).round());
        mss.setStat("averageSanity", (mss.getNumStat("averageSanity") / sessionSummaries.length).round());
        mss.setStat("averageRelationshipValue", (mss.getNumStat("averageRelationshipValue") / sessionSummaries.length).round());
        mss.setStat("averageNumScenes", (mss.getNumStat("averageNumScenes") / sessionSummaries.length).round());
        mss.setStat("survivalRate", (100 * (mss.getNumStat("totalLivingPlayers") / (mss.getNumStat("totalLivingPlayers") + mss.getNumStat("totalDeadPlayers")))).round());
        return mss;
    }

}