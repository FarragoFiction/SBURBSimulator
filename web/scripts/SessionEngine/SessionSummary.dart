import "dart:html";
import "../navbar.dart";
import 'dart:convert';

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
    //since stats will be hash, don't need to make junior
    int session_id = null;
    Session parentSession; //pretty sure this has to be a full session so i can get lineage
    bool scratched = false;
    num frogLevel = 0;
    List<Player> ghosts = <Player>[];
    String metaPlayer;

    //the two hashes are for big masses of stats this.i just blindly print to screen.
    Map<String, bool> bool_stats = <String, bool>{}; //most things
    Map<String, num> num_stats = <String, num>{}; //num_living etc
    String frogStatus; //doesn't need to be in a hash.
    List<MiniPlayer> miniPlayers = <MiniPlayer>[]; //array of hashes from players
    List<Player> players = <Player>[]; //TODO do i need this AND this.miniPlayers thing???
    Player mvp;


    SessionSummary(int this.session_id);

    void save() {
        //i need to load all the session summaries from memory
        //then add myself to it
        //then turn them all to json
        //then save
        Map<String, SessionSummary> summaries =  loadAllSummaries();
        summaries[jsonKey] = this;
        SessionSummary.saveAllSummaries(new List.from(summaries.values));
    }

    static Map<String, SessionSummary> loadAllSummaries() {
        Map<String, SessionSummary> ret = new Map<String, SessionSummary>();
        if(!window.localStorage.containsKey(SAVE_TAG)) {
            print("local storage doesn't have my key");
            return ret;
        }
        String jsonString = window.localStorage[SAVE_TAG];

        if(jsonString.isEmpty) {
            print("local storage has my key, but it's empty");
            return ret;
        }else if(jsonString == null) {
            print("local storage has my key, but it's null");
            return ret;
        }else {
            //print("local stoarge has my key. ${window.localStorage.containsKey(SAVE_TAG)} the contents are not empty. ${jsonString}");
        }

        if(jsonString == "null") print("you got trolled, it's the word null");

        //this should be an array of sessions, so can't jsonobject it directly
        String idontevenKnow = jsonString;
        try {
            List<dynamic> what = JSON.decode(idontevenKnow);
            for(dynamic d in what) {
                //print("dynamic json thing is  $d");
                JSONObject j = new JSONObject();
                j.json = d;
                SessionSummary s = new SessionSummary(-13);
                s.fromJSON("j");
                ret[s.jsonKey] = s;
            }
        }catch(e) {
            return ret;
        }

    }

    static void clearCache() {
        window.localStorage[SAVE_TAG] = null;
        window.localStorage.remove(SAVE_TAG);
    }

    static void saveAllSummaries(List<SessionSummary> summaries) {
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(SessionSummary p in summaries) {
            //TODO refuse to save if any easter eggs are active or if gnosis 4 happened.
            // print("Saving ${p.name}");
            jsonArray.add(p.toJSON());
        }
        window.localStorage[SAVE_TAG] = jsonArray.toString();
    }

    void fromJSON(String jsonString) {
        JSONObject json = new JSONObject.fromJSONString(jsonString);

        var boolExample = true;
        for(String key in bool_stats.keys) {
            if(json[key] == boolExample.toString()) {
                bool_stats[key] = true;
            }else {
                bool_stats[key] = false;
            }
        }

        for(String key in num_stats.keys) {
            num_stats[key] = int.parse(json[key]);
        }

        frogStatus = json["frogStatus"];
        session_id = int.parse(json["session_id"]);
    }

    String get jsonKey {
        String scratch = "";
        if(scratched) scratch = "(scratched)"; //makes sure a session and its scratch are keyed differently
        return "${session_id}$scratch";
    }


    JSONObject toJSON() {
        JSONObject json = new JSONObject();

        //TODO what to do about players and mini players? for now, leave off.

        for(String key in bool_stats.keys) {
            json[key] = bool_stats[key].toString();
        }

        for(String key in num_stats.keys) {
            json[key] = num_stats[key].toString();
        }

        json["frogStatus"] = frogStatus;
        json["session_id"] = session_id.toString();
        return json;
    }


    void setBoolStat(String statName, bool statValue) {
        // //print("setting stat: $statName to $statValue");
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
                    //	//print("not no frog");
                    return false;
                }
            } else if (filter == "numberSickFrog") {
                if (this.frogStatus != "Sick Frog") {
                    ////print("not sick frog");
                    return false;
                }
            } else if (filter == "numberFullFrog") {
                if (this.frogStatus != "Full Frog") {
                    ////print("not full frog");
                    return false;
                }
            } else if (filter == "numberPurpleFrog") {
                if (this.frogStatus != "Purple Frog") {
                    ////print("not full frog");
                    return false;
                }
            } else if (filter == "timesAllDied") {
                if (this.getNumStat("numLiving") != 0) {
                    ////print("not all dead");
                    return false;
                }
            } else if (filter == "timesAllLived") {
                if (this.getNumStat("numDead") != 0) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want this.
                    ////print("not all alive");
                    return false;
                }
            } else if (filter == "scratched") {
                if (!this.scratched) { // a special thing this.isn't in hash.
                    return false;
                }
            } else if (filter == "comboSessions") {
                if (this.parentSession == null) { //if this were an and on the outer if, it would let it fall down to the else if(!this[filter) and i don't want this.
                    ////print("not combo session");
                    return false;
                }
            } else if (!this.getBoolStat(filter)) { //assume it exists
                return false;
            }
        }
        ////print("i pass all filters");
        return true;
    }

    String decodeLineageGenerateHTML() {
        String html = "";
        String params = getParamStringMinusParam("seed");
        List<Session> lineage = this.parentSession.getLineage(); //i am not a session so remember to tack myself on at the end.
        String scratched = "";
        if (lineage[0].stats.scratched) scratched = "(scratched)";
        html = "$html<Br><b> Session</b>: <a href = 'index2.html?seed=${lineage[0].session_id}&$params'>${lineage[0].session_id}$scratched</a> ";
        for (num i = 1; i < lineage.length; i++) {
            String scratched = "";
            if (lineage[i].stats.scratched) scratched = "(scratched)";
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
        String params = getParamStringMinusParam("seed");
        String html = "<div class = 'sessionSummary' id = 'summarizeSession${this.session_id}'> ${toJSON()}";

        if (this.parentSession != null) {
            html = "$html${this.decodeLineageGenerateHTML()}";
        } else {
            String scratch = "";
            if (this.scratched) scratch = "(scratched)";

            html = "$html<Br><b> Session</b>: <a href = 'index2.html?seed=${this.session_id}&$params'>${this.session_id}$scratch</a>";
        }
        html = "$html<Br><b>Players</b>: ${getPlayersTitlesBasic(this.players)}";
        html = "$html<Br><b>mvp</b>: ${this.mvp.htmlTitle()} With a Grist Level of: ${this.mvp.grist}";

        html = "$html<Br><b>Frog Level</b>: ${this.frogLevel} (${this.frogStatus})";
        html = "$html${generateNumHTML()}";
        html = "$html${generateBoolHTML()}";


        html = "$html</div><br>";
        return html;
    }

    static SessionSummary makeSummaryForSession(Session session) {
        SessionSummary summary = new SessionSummary(session.session_id);
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
        summary.setBoolStat("godTier", session.stats.godTier);
        summary.setBoolStat("questBed", session.stats.questBed);
        summary.setBoolStat("sacrificialSlab", session.stats.sacrificialSlab);
        summary.setNumStat("num_scenes", session.numScenes);
        summary.players = session.players;
        summary.mvp = findMVP(session.players);
        summary.parentSession = session.parentSession;
        summary.setBoolStat("scratchAvailable", session.stats.scratchAvailable);
        summary.setBoolStat("yellowYard", session.stats.yellowYard);
        summary.setNumStat("numLiving", findLiving(session.players).length);
        summary.setNumStat("numDead", findDeadPlayers(session.players).length);
        summary.setBoolStat("ectoBiologyStarted", session.stats.ectoBiologyStarted);
        summary.setBoolStat("denizenBeat", session.stats.denizenBeat);

        if(session.derse != null) {
            summary.setBoolStat("kingTooPowerful", session.battlefield.blackKing.getStat(Stats.POWER) > session.hardStrength);
        }
        summary.setBoolStat("queenRejectRing", session.stats.queenRejectRing);
        ////print("Debugging: King strength is ${session.king.getStat(Stats.POWER)} and hardStrength is ${session.hardStrength}");
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
        summary.setBoolStat("hasSpades", session.stats.hasSpades);
        summary.setBoolStat("hasClubs", session.stats.hasClubs);
        summary.setBoolStat("hasHearts", session.stats.hasHearts);
        summary.save();
        return summary;
    }

}

