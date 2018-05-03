import "dart:html";
import "../SBURBSim.dart";
import "SessionSummaryLib.dart";
import 'dart:convert';

class BigBadStats {
    List<int> activeSessions = new List<int>();
    String description;
    String name;
    Map<String, int> statsMap = new Map<String, int>();


    int currentPage = 0;
    List<Element> pages = <Element>[];

    Element pageNum;

    GameEntity bigBad;

    BigBadStats(GameEntity this.bigBad) {
        if(bigBad != null) {
            loadBigBad(bigBad);
        }else {
            initStats();
        }
    }

    void initStats() {
        this.name = "???";
        this.description = "???";
        statsMap["Times Activated"] = 0;
        statsMap["Times Crowned"] = 0;
        statsMap["Carapaces Murdered"]  = 0;
        statsMap["Times Joined Players"] = 0;
        statsMap["Moons Murdered"]  = 0;
        statsMap["Planets Murdered"]  = 0;
        statsMap["Red Miles Activated"]  = 0;
        statsMap["Players Murdered"]  = 0;
        statsMap["Times Died"]  = 0;
        statsMap["Times Exiled"] = 0;
    }

    //add all others vars to yourself
    void add(BigBadStats other) {
        for(String key in statsMap.keys) {
            if(other.statsMap.containsKey(key))statsMap[key] += other.statsMap[key];
        }
        activeSessions.addAll(other.activeSessions);
    }


    void loadBigBad(GameEntity bigBad) {
        //;
        this.name = bigBad.name;
        this.description = bigBad.description;
        statsMap["Times Activated"] = bigBad.active ? 1 : 0;
        statsMap["Times Joined Players"] = bigBad.partyLeader != null ? 1 : 0;
        statsMap["Times Crowned"] = bigBad.everCrowned ? 1 : 0;
        statsMap["Carapaces Murdered"] = bigBad.npcKillCount;
        statsMap["Moons Murdered"] = bigBad.moonKillCount;
        statsMap["Planets Murdered"] = bigBad.landKillCount;
        statsMap["Red Miles Activated"] =  bigBad.usedMiles ? 1 : 0;
        statsMap["Players Murdered"] = bigBad.playerKillCount;
        statsMap["Times Died"] =  bigBad.dead ? 1 : 0;
        statsMap["Times Exiled"] =  bigBad.exiled ? 1 : 0;
        //don't even bother.
        if(bigBad.session.session_id >0 && !bigBad.session.stats.scratched && !bigBad.session.stats.hadCombinedSession) {
            if (bigBad.active) activeSessions.add(bigBad.session.session_id);
        }

        //;

    }

    @override
    void fromJSON(String jsonString) {
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        for(String key in statsMap.keys) {
            // ;
            statsMap[key] = num.parse(json[key]);
        }
        name = json["exampleName"];
        activeSessions  = JSONObject.jsonStringToIntArray(json["activeSessions"]);

    }

    @override
    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        for(String key in statsMap.keys) {
            json[key] = statsMap[key].toString();
        }
        json["name"] = name;
        json["activeSessions"] = activeSessions.toString();

        // ;
        return json;
    }


}


class BigBadSummary {
    Map<String, BigBadStats> data = new Map<String, BigBadStats>();
    Session session;

    BigBadSummary(Session this.session) {
        if(session == null) {
            defaultSession();
        }
        init();
    }

    void defaultSession() {
        session = new Session(-13);
        session.setupMoons("getting a default session");
    }

    void init() {
        List<GameEntity> npcs = session.npcHandler.bigBads;
        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }else {
                BigBadStats s = new BigBadStats(g);
                data[s.name] = s;
            }
        }
    }

}