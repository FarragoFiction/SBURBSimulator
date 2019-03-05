import "dart:html";
import "../navbar.dart";
import 'dart:convert';
import "dart:math" as Math;

import "../SBURBSim.dart";
import "SessionSummaryLib.dart";

//how AuthorBot summarizes a session
//eventually moon prophecies will use this.
//a prophecy can be any of these values this.don't match the values in the current session summary.

class MiniPlayer {
    final SBURBClass sburbclass;
    final Aspect aspect;

    MiniPlayer(SBURBClass this.sburbclass, Aspect this.aspect);
}

class SessionSummary {
    static String SAVE_TAG = "SESSIONSUMMARIESCACHE";
    Duration duration;

    //these two should ONLY be used by shogunbot, since aB memory leaks if she uses it
    //(using it doesn't let her forget shit about the sessions)
    CarapaceSummary carapaceSummary;
    BigBadSummary bigBadSummary;

    //AB should use these two instead, write the letter to shogunbot as she goes
    //instead of trying to memorize every detail to write later
    JSONObject carapaceSummaryJSON;
    JSONObject bigBadSummaryJSON;



    //since stats will be hash, don't need to make junior
    int session_id = null;
    Session childSession; //reverse polarity for new async system
    bool scratched = false;
    num frogLevel = 0;
    List<Player> ghosts = <Player>[];
    String metaPlayer;

    //the two hashes are for big masses of stats this.i just blindly print to screen.
    Map<String, bool> bool_stats = <String, bool>{}; //most things
    Map<String, num> num_stats = <String, num>{}; //num_living etc
    String frogStatus; //doesn't need to be in a hash.
    String lineageString;
    List<MiniPlayer> miniPlayers = <MiniPlayer>[]; //array of hashes from players
    List<Player> players = <Player>[]; //TODO do i need this AND this.miniPlayers thing???
    Player mvp;
    String mvpName;
    String mvpGrist;


    SessionSummary(int this.session_id);


    void save() {
        //i need to load all the session summaries from memory
        //then add myself to it
        //then turn them all to json
        //then save
       // ;
        Map<String, SessionSummary> summaries =  loadAllSummaries();
        summaries[jsonKey] = this;
        SessionSummary.saveAllSummaries(new List.from(summaries.values));
    }

    static Map<String, SessionSummary> loadAllSummaries() {
       // ;
        Map<String, SessionSummary> ret = new Map<String, SessionSummary>();
        if(!window.localStorage.containsKey(SAVE_TAG)) {
            print("local storage doesn't have key $SAVE_TAG");
            return ret;
        }
        String jsonString = window.localStorage[SAVE_TAG];

        if(jsonString.isEmpty) {
            print("json string is empty");
            return ret;
        }else if(jsonString == null) {
            print("json string is null");
            return ret;
        }else {
            //;
        }

        if(jsonString == "null") ;

        //this should be an array of sessions, so can't jsonobject it directly
        String idontevenKnow = jsonString;
        //print("jsonstring is $idontevenKnow");
        try {
            List<dynamic> what = jsonDecode(idontevenKnow);
            for(dynamic d in what) {
               // ;
                JSONObject j = new JSONObject();
                j.json = d;
                //;
                SessionSummary s = new SessionSummary(-13);
                //;
                s.fromJSON(j.toString());
                //;
                ret[s.jsonKey] = s;
            }
        }catch(e) {
            print("error caught trying to parse sessions from cache, $e");

            return ret;
        }
        return ret;
    }

    static void clearCache() {
        window.localStorage.remove(SAVE_TAG);
    }

    static void saveAllSummaries(List<SessionSummary> summaries) {
        print("AB is writing ShogunBot a data packet about big bads, how cute");
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(SessionSummary p in summaries) {
            //TODO refuse to save if any easter eggs are active or if gnosis 4 happened.
            // ;
            jsonArray.add(p.toJSON());
        }
        window.localStorage[SAVE_TAG] = jsonArray.toString();
    }

    void fromJSON(String jsonString) {
       // ;
        JSONObject json = new JSONObject.fromJSONString(jsonString);
       // ;
        //        json["carapaceSummary"] = carapaceSummary.toJSON().toString();
        carapaceSummary = new CarapaceSummary(null); //all zeroes
        bigBadSummary = new BigBadSummary(null);
       // ;

        carapaceSummary.fromJSON(json["carapaceSummary"]);
        bigBadSummary.fromJSON(json["bigBadSummary"]);
        //;

        // ;

        var boolExample = true;
        initBoolKeys();
        initNumKeys();
        //;
        for(String key in bool_stats.keys) {
            //;
            if(json[key] == boolExample.toString()) {
                bool_stats[key] = true;
            }else {
                bool_stats[key] = false;
            }
        }

        for(String key in num_stats.keys) {
           // ;
            num_stats[key] = num.parse(json[key]);
        }

        frogStatus = json["frogStatus"];
        lineageString = json["lineageString"];
        mvpName = json["mvpName"];
        mvpGrist = json["mvpGrist"];
        if(json["scratched"] == boolExample.toString()) {
            scratched = true;
        }else {
            scratched = false;
        }

        session_id = int.parse(json["session_id"]);
    }

    String get jsonKey {
        String scratch = "";
        if(scratched) scratch = "(scratched)"; //makes sure a session and its scratch are keyed differently
        return "${session_id}$scratch";
    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();

        if(carapaceSummary != null) {
            json["carapaceSummary"] = carapaceSummary.toJSON().toString();
        }else {
            json["carapaceSummary"] = carapaceSummaryJSON.toString();

        }

        if(bigBadSummary != null) {
            json["bigBadSummary"] = bigBadSummary.toJSON().toString();
        }else {
            json["bigBadSummary"] = bigBadSummaryJSON.toString();

        }

        //TODO what to do about players and mini players? for now, leave off.

        for(String key in bool_stats.keys) {
            json[key] = bool_stats[key].toString();
        }

        for(String key in num_stats.keys) {
            json[key] = num_stats[key].toString();
        }

        json["frogStatus"] = frogStatus;
        json["lineageString"] = lineageString;
        json["mvpName"] = mvpName;
        json["mvpGrist"] = mvpGrist;
        json["session_id"] = session_id.toString();
        json["scratched"] = scratched.toString();

        return json;
    }


    void setBoolStat(String statName, bool statValue) {
        // //;
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
            this.miniPlayers.add(new MiniPlayer(players[i].class_name, players[i].aspect));
        }
    }

    bool matchesClass(List<SBURBClass> classes) {
        for (num i = 0; i < classes.length; i++) {
            SBURBClass class_name = classes[i];
            for (num j = 0; j < this.miniPlayers.length; j++) {
                MiniPlayer miniPlayer = this.miniPlayers[j];
                if (miniPlayer.sburbclass == class_name) return true;
            }
        }
        return false;
    }

    bool matchesAspect(List<Aspect> aspects) {
        for (num i = 0; i < aspects.length; i++) {
            Aspect aspect = aspects[i];
            for (num j = 0; j < this.miniPlayers.length; j++) {
                MiniPlayer miniPlayer = this.miniPlayers[j];
                if (miniPlayer.aspect == aspect) return true;
            }
        }
        return false;
    }

    bool miniPlayerMatchesAnyClasspect(MiniPlayer miniPlayer, List<SBURBClass> classes, List<Aspect> aspects) {
        //is my class in the class array AND my aspect in the aspect array.
        if (classes.contains(miniPlayer.sburbclass) && aspects.contains(miniPlayer.aspect)) return true;
        return false;
    }

    bool matchesBothClassAndAspect(List<SBURBClass> classes, List<Aspect> aspects) {
        for (num j = 0; j < this.miniPlayers.length; j++) {
            if (this.miniPlayerMatchesAnyClasspect(this.miniPlayers[j], classes, aspects)) return true;
        }
        return false;
    }

    bool matchesClasspect(List<SBURBClass> classes, List<Aspect> aspects) {
        if (!aspects.isEmpty && classes.isEmpty) {
            return this.matchesAspect(aspects);
        } else if (!classes.isEmpty && aspects.isEmpty) {
            return this.matchesClass(classes);
        } else if (!aspects.isEmpty && !classes.isEmpty) {
            return this.matchesBothClassAndAspect(classes, aspects);
        } else {
            ////print('debugging ab: no classes or aspects passed');
            return true; //no filters, all are accepted.
        }
    }

    bool satifies_filter_array(List<String> filter_array) {
        ////print(filter_array);
        for (int i = 0; i < filter_array.length; i++) {
            String filter = filter_array[i];

            if (filter == "numberNoFrog") {
                if (this.frogStatus != "No Frog") {
                    //	//;
                    return false;
                }
            } else if (filter == "numberSickFrog") {
                if (this.frogStatus != "Sick Frog") {
                    ////;
                    return false;
                }
            } else if (filter == "numberFullFrog") {
                if (this.frogStatus != "Full Frog") {
                    ////;
                    return false;
                }
            } else if (filter == "numberPurpleFrog") {
                if (this.frogStatus != "Purple Frog") {
                    ////;
                    return false;
                }
            } else if (filter == "timesAllDied") {
                if (this.getNumStat("numLiving") != 0) {
                    ////;
                    return false;
                }
            } else if (filter == "timesAllLived") {
                if (this.getNumStat("numDead") != 0) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want this.
                    ////;
                    return false;
                }
            } else if (filter == "scratched") {
                if (!this.scratched) { // a special thing this.isn't in hash.
                    return false;
                }
            } else if (filter == "comboSessions") {
                if (this.childSession == null) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want this.
                    ////;
                    return false;
                }
            } else if (!this.getBoolStat(filter)) { //assume it exists
                return false;
            }
        }
        ////;
        return true;
    }

    String decodeLineageGenerateHTML() {
        String html = "";
        String params = getParamStringMinusParam("seed");
        List<Session> lineage = this.childSession.getLineage(); //i am not a session so remember to tack myself on at the end.
        lineage = new List.from(lineage.reversed); //put parent first.
        String scratched = "";

        if (lineage[0].stats.scratched) scratched = "(scratched)";
        //myself first
        html = "$html Session: <a target = '_blank' href = 'index2.html?seed=${this.session_id.toString()}&$params'>${this.session_id.toString()}$scratched</a> ";
        //first child
        html = "$html combined with: </b>: <a target = '_blank' href = 'index2.html?seed=${lineage[0].session_id}&$params'>${lineage[0].session_id}$scratched</a> ";

        for (num i = 1; i < lineage.length; i++) {
            String scratched = "";
            if (lineage[i].stats.scratched) scratched = "(scratched)";
            html = "$html combined with: <a target = '_blank' href = 'index2.html?seed=${lineage[i].session_id}&$params'>${lineage[i].session_id}$scratched</a> ";
        }
        scratched = "";
        if (this.getBoolStat("scratched")) scratched = "(scratched)";
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
        String params = getParamStringMinusParam("seed");
        String html = "<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'>";

        if (this.childSession != null) {
            html = "$html${this.decodeLineageGenerateHTML()} (Simulation time: $duration)";
            html = "$html<br><a target = '_blank' href='observatory.html?seed=${this.session_id}&$params'>View session ${this.session_id} in the Observatory</a>";
        } else {
            String scratch = "";
            if (this.scratched) scratch = " (scratched)";

            html = "$html<Br><b> Session</b>: <a target = '_blank' href = 'index2.html?seed=${this.session_id}&$params'>${this.session_id}$scratch</a> (Simulation time: $duration)";
            html = "$html<br><a target = '_blank' href='observatory.html?seed=${this.session_id}&$params'>View in the Observatory</a>";
        }
        html = "$html<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}";

        html = "$html<Br><b>mvp</b>: ${this.mvpName} With a Grist Level of: ${this.mvpGrist}";

        html = "$html<Br><b>Frog Level</b>: ${this.frogLevel} (${this.frogStatus})";
        html = "$html${generateNumHTML()}";
        html = "$html${generateBoolHTML()}";


        html = "$html</div><br>";
        return html;
    }

    //needed for loading
    void initBoolKeys() {
       // ;
        SessionSummary summary  = this;
        summary.setBoolStat("blackKingDead", false);
        summary.setBoolStat("redMilesActivated", false);
        summary.setBoolStat("moonDestroyed", false);
        summary.setBoolStat("planetDestroyed", false);
        summary.setBoolStat("crownedCarapace", false);
        summary.setBoolStat("mailQuest", false);
        summary.setBoolStat("gnosisEnding", false);
        summary.setBoolStat("hasGhostEvents", false);
        summary.setBoolStat("loveEnding", false);
        summary.setBoolStat("hateEnding", false);
        summary.setBoolStat("monoTheismEnding", false);
        summary.setBoolStat("badBreakDeath", false);
        summary.setBoolStat("luckyGodTier", false);
        summary.setBoolStat("choseGodTier", false);
        summary.setBoolStat("opossumVictory", false);
        summary.setBoolStat("rocksFell", false);
        summary.setBoolStat("won", false);
        summary.setBoolStat("hasBreakups",false);
        summary.setBoolStat("heroicDeath", false);
        summary.setBoolStat("justDeath", false);
        summary.setBoolStat("crashedFromSessionBug", false);
        summary.setBoolStat("cataclysmCrash", false);
        summary.setBoolStat("ringWraithCrash", false);
        summary.setBoolStat("crashedFromPlayerActions", false);
        summary.setBoolStat("hasFreeWillEvents", false);
        summary.setBoolStat("hasTier1GnosisEvents", false);
        summary.setBoolStat("hasTier2GnosisEvents", false);
        summary.setBoolStat("hasTier3GnosisEvents", false);
        summary.setBoolStat("hasTier4GnosisEvents", false);
        summary.setBoolStat("hasNoTier4Events", false);  //so you can tell ab to ignore tier4 events
        summary.setBoolStat("hasLuckyEvents", false);
        summary.setBoolStat("hasUnluckyEvents", false);
        summary.setBoolStat("rapBattle", false);
        summary.setBoolStat("sickFires", false);
        summary.setBoolStat("forgeStoked",false);
        summary.setBoolStat("timeoutReckoning", false);
        summary.setBoolStat("brokenForge", false);
        summary.setBoolStat("mailedCrownAbdication", false);
        summary.setBoolStat("nonKingReckoning", false);
        summary.setBoolStat("godTier", false);
        summary.setBoolStat("questBed", false);
        summary.setBoolStat("sacrificialSlab", false);
        summary.setBoolStat("scratchAvailable", false);
        summary.setBoolStat("yellowYard", false);
        summary.setBoolStat("ectoBiologyStarted", false);
        summary.setBoolStat("denizenBeat", false);
        summary.setBoolStat("kingTooPowerful", false);
        summary.setBoolStat("queenRejectRing", false);
        summary.setBoolStat("murdersHappened", false);
        summary.setBoolStat("scratched", false);
        summary.setBoolStat("grimDark", false);
        summary.setBoolStat("bigBadActive", false);
        summary.setBoolStat("hasDiamonds", false);

        summary.setBoolStat("hasSpades", false);
        summary.setBoolStat("hasClubs", false);
        summary.setBoolStat("hasHearts", false);
    }

    void initNumKeys() {
        //;
        SessionSummary summary  = this;
        summary.setNumStat("num_scenes", 0);
        summary.setNumStat("sizeOfAfterLife", 0);
        summary.setNumStat("numLiving", 0);
        summary.setNumStat("numDead", 0);
        summary.setNumStat("averageMinLuck", 0);
        summary.setNumStat("averageMaxLuck", 0);
        summary.setNumStat("averagePower", 0);
        summary.setNumStat("averageGrist", 0);
        summary.setNumStat("averageMobility", 0);
        summary.setNumStat("averageFreeWill", 0);
        summary.setNumStat("averageHP", 0);
        summary.setNumStat("averageAlchemySkill", 0);
        summary.setNumStat("averageRelationshipValue", 0);
        summary.setNumStat("averageSanity", 0);
    }

    static SessionSummary makeSummaryForSession(Session session) {
        //print("making an overall summary for session $session");
        SessionSummary summary = new SessionSummary(session.session_id);
        //TODO turn this back on but for now testing what is fucking AB up
        summary.carapaceSummaryJSON = new CarapaceSummary(session).toJSON();
        summary.bigBadSummaryJSON = new BigBadSummary(session).toJSON();
        //summary.carapaceSummary = new CarapaceSummary(session);
        //summary.bigBadSummary = new BigBadSummary(session);
        summary.setMiniPlayers(session.players);
        if(session.mutator.voidField) return session.mutator.makeBullshitSummary(session, summary);
        if(session.derse != null) {
            summary.setBoolStat("blackKingDead", session.battlefield.blackKing.dead || session.battlefield.blackKing.getStat(Stats.CURRENT_HEALTH) <= 0);
        }else {
            summary.setBoolStat("blackKingDead", true);
        }
        summary.setBoolStat("redMilesActivated", session.stats.redMilesActivated);
        summary.setBoolStat("moonDestroyed", session.stats.moonDestroyed);
        summary.setBoolStat("planetDestroyed", session.stats.planetDestroyed);
        summary.setBoolStat("crownedCarapace", session.stats.crownedCarapace);
        summary.setBoolStat("mailQuest", session.stats.mailQuest);

        summary.setBoolStat("gnosisEnding", session.stats.gnosisEnding);
        summary.setBoolStat("hasGhostEvents", session.stats.hasGhostEvents);
        summary.setBoolStat("loveEnding", session.stats.loveEnding);
        summary.setBoolStat("hateEnding", session.stats.hateEnding);
        summary.setBoolStat("monoTheismEnding", session.stats.monoTheismEnding);
        summary.setBoolStat("badBreakDeath", session.stats.badBreakDeath);
        summary.setBoolStat("luckyGodTier", session.stats.luckyGodTier);
        summary.setBoolStat("choseGodTier", session.stats.choseGodTier);
        summary.scratched = session.stats.scratched;
        summary.setBoolStat("opossumVictory", session.stats.opossumVictory);
        summary.setBoolStat("rocksFell", session.stats.rocksFell);
        summary.setBoolStat("won", session.stats.won);
        summary.setBoolStat("hasBreakups", session.stats.hasBreakups);
        summary.ghosts = session.afterLife.ghosts;
        summary.setNumStat("sizeOfAfterLife", session.afterLife.ghosts.length);
        summary.setBoolStat("heroicDeath", session.stats.heroicDeath);
        summary.setBoolStat("justDeath", session.stats.justDeath);
        summary.setBoolStat("crashedFromSessionBug", session.stats.crashedFromSessionBug);
        summary.setBoolStat("cataclysmCrash", session.stats.cataclysmCrash);

        summary.setBoolStat("ringWraithCrash", session.stats.ringWraithCrash);

        summary.setBoolStat("crashedFromPlayerActions", session.stats.crashedFromPlayerActions);
        summary.setBoolStat("hasFreeWillEvents", session.stats.hasFreeWillEvents);
        summary.setBoolStat("hasTier1GnosisEvents", session.stats.hasTier1Events);
        summary.setBoolStat("hasTier2GnosisEvents", session.stats.hasTier2Events);
        summary.setBoolStat("hasTier3GnosisEvents", session.stats.hasTier3Events);
        summary.setBoolStat("hasTier4GnosisEvents", session.stats.hasTier4Events);
        summary.setBoolStat("hasNoTier4Events", !session.stats.hasTier4Events);  //so you can tell ab to ignore tier4 events
        summary.setNumStat("averageMinLuck", Stats.MIN_LUCK.average(session.players));
        summary.setNumStat("averageMaxLuck", Stats.MAX_LUCK.average(session.players));
        summary.setNumStat("averagePower", Stats.POWER.average(session.players));
        summary.setNumStat("averageGrist", getAverageGrist(session.players));
        summary.setNumStat("averageMobility", Stats.MOBILITY.average(session.players));
        summary.setNumStat("averageFreeWill", Stats.FREE_WILL.average(session.players));
        summary.setNumStat("averageHP", Stats.HEALTH.average(session.players));
        summary.setNumStat("averageAlchemySkill", Stats.ALCHEMY.average(session.players));
        summary.setNumStat("averageRelationshipValue", Stats.RELATIONSHIPS.average(session.players));
        summary.setNumStat("averageSanity", Stats.SANITY.average(session.players));
        summary.session_id = session.session_id;
        summary.setBoolStat("hasLuckyEvents", session.stats.goodLuckEvent);
        summary.setBoolStat("hasUnluckyEvents", session.stats.badLuckEvent);
        summary.setBoolStat("rapBattle", session.stats.rapBattle);
        summary.setBoolStat("sickFires", session.stats.sickFires);
        summary.frogStatus = session.frogStatus();
        summary.setBoolStat("forgeStoked", session.playersHaveRings());
        summary.setBoolStat("timeoutReckoning", session.stats.timeoutReckoning);
        summary.setBoolStat("brokenForge", session.stats.brokenForge);
        summary.setBoolStat("mailedCrownAbdication", session.stats.mailedCrownAbdication);
        summary.setBoolStat("nonKingReckoning", session.stats.nonKingReckoning);

        summary.setBoolStat("godTier", session.stats.godTier);
        summary.setBoolStat("questBed", session.stats.questBed);
        summary.setBoolStat("sacrificialSlab", session.stats.sacrificialSlab);
        summary.setNumStat("num_scenes", session.numScenes);
        summary.players = session.players;
        summary.mvp = findMVP(session.players);
        summary.mvpName = summary.mvp.htmlTitle();
        summary.mvpGrist = summary.mvp.grist.toString();
        summary.childSession = session.childSession;
        summary.setBoolStat("scratchAvailable", session.stats.scratchAvailable);
        summary.setBoolStat("yellowYard", session.stats.yellowYard);
        summary.setNumStat("numLiving", findLiving(session.players).length);
        summary.setNumStat("numDead", findDeadPlayers(session.players).length);
        summary.setBoolStat("ectoBiologyStarted", session.stats.ectoBiologyStarted);
        summary.setBoolStat("denizenBeat", session.stats.denizenBeat);
        summary.setBoolStat("scratched", session.stats.scratched);

        if(session.derse != null) {
            summary.setBoolStat("kingTooPowerful", session.battlefield.blackKing.getStat(Stats.POWER) > session.hardStrength);
        }
        summary.setBoolStat("queenRejectRing", session.stats.queenRejectRing);
        ////;
        summary.setBoolStat("murdersHappened", session.stats.murdersHappened);

        summary.setBoolStat("grimDark", session.stats.grimDarkPlayers);

        Player spacePlayer = session.findBestSpace();
        Player corruptedSpacePlayer = session.findMostCorruptedSpace();
        if (spacePlayer == null) {
            summary.frogLevel = 0;
        } else if (summary.frogStatus == "Purple Frog") {
            summary.frogLevel = corruptedSpacePlayer.landLevel;
        } else {
            summary.frogLevel = spacePlayer.landLevel;
        }

        summary.setBoolStat("hasDiamonds", session.stats.hasDiamonds);
        summary.setBoolStat("bigBadActive", session.stats.bigBadActive);
        summary.setBoolStat("hasSpades", session.stats.hasSpades);
        summary.setBoolStat("hasClubs", session.stats.hasClubs);
        summary.setBoolStat("hasHearts", session.stats.hasHearts);
        if(summary.childSession != null) summary.lineageString = summary.decodeLineageGenerateHTML();
        return summary;
    }

}

