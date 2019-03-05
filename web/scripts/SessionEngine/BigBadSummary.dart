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
        if(bigBad != null && bigBad is BigBad) {
            loadBigBad(bigBad);
        }else {
            initStats();
        }
    }

    void initStats() {
        this.name = "???";
        this.description = "???";
        statsMap["Times Activated"] = 0;
        statsMap["Times Joined Players"] = 0;
        statsMap["Carapaces Murdered"]  = 0;
        statsMap["Moons Murdered"]  = 0;
        statsMap["Planets Murdered"]  = 0;
        statsMap["Players Murdered"]  = 0;
        statsMap["Times Died"]  = 0;
    }

    //add all others vars to yourself
    void add(BigBadStats other) {
        for(String key in statsMap.keys) {
            if(other.statsMap.containsKey(key))statsMap[key] += other.statsMap[key];
        }
        activeSessions.addAll(other.activeSessions);
    }


    void loadBigBad(GameEntity bigBad) {
       // print("loading a big bad $bigBad for session ${bigBad.session.session_id}}, it wasn't default, times active was ${bigBad.active ? 1 : 0};");
        this.name = bigBad.name;
        this.description = bigBad.description;
        statsMap["Times Activated"] = bigBad.active ? 1 : 0;
        statsMap["Times Joined Players"] = bigBad.partyLeader != null ? 1 : 0;
        statsMap["Carapaces Murdered"] = bigBad.npcKillCount;
        statsMap["Moons Murdered"] = bigBad.moonKillCount;
        statsMap["Planets Murdered"] = bigBad.landKillCount;
        statsMap["Players Murdered"] = bigBad.playerKillCount;
        statsMap["Times Died"] =  bigBad.dead ? 1 : 0;
        //don't even bother.
        if(bigBad.session.session_id >0 && !bigBad.session.stats.scratched && !bigBad.session.stats.hadCombinedSession) {
            if (bigBad.active) activeSessions.add(bigBad.session.session_id);
        }
        //;
        /*print("done loading big bad");
        for(String key in statsMap.keys) {
            print("key $key is ${statsMap[key]}");
        }
        */
    }

    void turnPage() {
        currentPage ++;
        if(currentPage >= pages.length) currentPage = 0;

        for(int i = 0; i<pages.length; i++) {
            Element e = pages[i];
            if(i == currentPage) {
                e.style.display = "inline-block";
            }else {
                e.style.display = "none";
            }
        }
        pageNum.text = "Page: ${currentPage+1}/${pages.length}";
    }


    //display pic of prospit or derse.
    //display placeholder for the carpace in question.
    Element getCard(Element container) {
        DivElement div = new DivElement();
        div.onClick.listen((e)
        {
            turnPage();
        });
        div.classes.add("collectibleCard");

        DivElement divBorder = new DivElement();
        divBorder.classes.add("collectibleCardBorder");
        container.append(divBorder);


        DivElement nameDiv = new DivElement();
        nameDiv.classes.add("cardName");
        nameDiv.text = "Name: $name";
        pageNum = new SpanElement();
        pageNum.classes.add("cardPageNum");

        divBorder.append(div);
        div.append(makePortrait());
        div.append(nameDiv);
        div.append(makeStats());
        div.append(makeDescription());
        div.append(makeSessions());
        pageNum.text = "Page: ${currentPage+1}/${pages.length}";
    }

    @override
    Element makePortrait() {
        DivElement div = new DivElement();
        div.classes.add("cardPortraitBG");
        String extension = ".png";
        if(name.contains("Lord English") || name.contains("Hussie")) extension = ".gif";
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${name.toLowerCase().replaceAll(" ", "_")}_card$extension");
        div.style.backgroundImage = "url(images/BigBadCards/white.png)";

        portrait.onError.listen((e) {
            print("couldn't find ${portrait.src}");
            portrait.src = "images/BigBadCards/default.gif";
        });

        portrait.classes.add("cardPortrait");

        div.append(portrait);

        return div;
    }

    Element makeDescription() {
        DivElement div = new DivElement();
        div.classes.add("cardStats");
        div.style.display = "none";
        div.setInnerHtml(description);
        pages.add(div);
        return div;

    }

    Element makeSessions() {
        DivElement ret = new DivElement();
        ret.style.display = "none";

        DivElement activeDiv = new DivElement();
        ret.append(activeDiv);
        activeDiv.setInnerHtml("Sessions Active In: ");
        DivElement sessionsDiv  = new DivElement();
        activeDiv.append(sessionsDiv);
        for(int session_id in activeSessions) {
            SpanElement d = new SpanElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.target = "_blank";
            a.text = " $session_id, ";
            d.append(a);
            sessionsDiv.append(d);
        }

        pages.add(ret);
        return ret;

    }


    Element makeStats() {
        DivElement div = new DivElement();
        div.classes.add("cardStats");
        for(String key in statsMap.keys) {
            DivElement tmp = new DivElement();
            tmp.classes.add("cardStatBox");
            SpanElement first = new SpanElement();
            first.setInnerHtml("${key}:");
            first.classes.add("cardStatName");

            SpanElement second = new SpanElement();
            second.classes.add("cardStatValue");
            second.setInnerHtml("${statsMap[key]}");
            tmp.append(first);
            tmp.append(second);
            div.append(tmp);
        }


        pages.add(div);
        return div;
    }


    @override
    void fromJSON(String jsonString) {
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        for(String key in statsMap.keys) {
            // ;
            statsMap[key] = num.parse(json[key]);
        }
        name = json["name"];
        description = json["description"];
        activeSessions  = JSONObject.jsonStringToIntArray(json["activeSessions"]);

    }

    @override
    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        for(String key in statsMap.keys) {
            json[key] = statsMap[key].toString();
            //print("$name json $key is ${json[key]}");
        }
        json["name"] = name;
        json["description"] = description;
        json["activeSessions"] = activeSessions.toString();

        // ;
        return json;
    }


}


class BigBadSummary {
    String bigBadsActiveNames = "";
    Map<String, BigBadStats> data = new Map<String, BigBadStats>();
    Session session;

    BigBadSummary(Session this.session) {
        //print("Making a new big bad summary for session ${this.session.session_id}");
        if(session == null) {
            defaultSession();
        }
        init();
    }

    void defaultSession() {
        session =Session.defaultSession;
        if(session.prospitRing == null) {
            session.setupMoons("getting a default session");
        }
    }

    //if you add a bigbad summary to yourself, you add all it's values to your own data.
    void add(BigBadSummary other) {
        //print("adding big bad summary ${other}");
        for(BigBadStats cs in other.data.values) {
            //print("processing big bad stats with name ${cs.name}");
            if(data.containsKey(cs.name)) {
                data[cs.name].add(cs);
            }else {
                data[cs.name] = cs;
            }
        }
    }

    void init() {
        //List<GameEntity> npcs = session.activatedNPCS;
        List<GameEntity> npcs = session.bigBadsReadOnly;// for when you dont want to hide any
        //print("sessions activated big bads are ${session.activatedBigBads}");
        if(session.activatedBigBads.isNotEmpty) bigBadsActiveNames = turnArrayIntoHumanSentence(session.activatedBigBads.toList(growable: true));
        npcs.addAll(session.activatedBigBads);
        for(GameEntity g in npcs) {
            if(g is BigBad){
                //print("TEST AB WRITING: I am initializing a big bad summary from a real session. the big bad is $g");
                BigBadStats s = new BigBadStats(g);
                data[s.name] = s;
            }
        }
    }

    JSONObject toJSON() {
        JSONObject container  = new JSONObject();
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(BigBadStats cs in data.values) {
            jsonArray.add(cs.toJSON());
        }
        container["data"] = jsonArray.toString();
        container["bigBadsActiveNames"] = bigBadsActiveNames;
        return container;
    }

    void fromJSON(String jsonString) {
        //  ;
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        bigBadsActiveNames = json["bigBadsActiveNames"];
        List<dynamic> what = jsonDecode(json["data"]);
        for(dynamic d in what) {
            //;
            JSONObject j = new JSONObject();
            j.json = d;
            //;
            BigBadStats s = new BigBadStats(null);
            //;
            s.fromJSON(j.toString());
            // ;
            data[s.name] = s;
        }

    }


}