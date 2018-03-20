import "dart:html";
import "../SBURBSim.dart";
import "SessionSummaryLib.dart";
import 'dart:convert';
import "dart:async";


class CarapaceStats {

    List<int> activeSessions = new List<int>();
    List<int> crownedSessions = new List<int>();

    String aliases;
    String exampleName;
    String initials;
    String moon;
    String description;

    int currentPage = 0;
    List<Element> pages = <Element>[];

    Element pageNum;

    Map<String, int> statsMap = new Map<String, int>();

    CarapaceStats(Carapace carapace) {
        if(carapace != null) {
            loadCarapace(carapace);
        }else {
            initStats();
        }
    }

    void initStats() {
        this.initials = "???";
        this.exampleName = "???";
        this.aliases = "???";
        this.moon = "???";
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

    void loadCarapace(Carapace carapace) {
        //print("loading carapace $carapace who is active ${carapace.active}");
        this.initials = carapace.initials;
        this.exampleName = carapace.name;
        this.aliases = carapace.aliases;
        this.moon = carapace.type;
        this.description = carapace.description;
        statsMap["Times Activated"] = carapace.active ? 1 : 0;
        statsMap["Times Joined Players"] = carapace.partyLeader != null ? 1 : 0;
        statsMap["Times Crowned"] = carapace.everCrowned ? 1 : 0;
        statsMap["Carapaces Murdered"] = carapace.npcKillCount;
        statsMap["Moons Murdered"] = carapace.moonKillCount;
        statsMap["Planets Murdered"] = carapace.landKillCount;
        statsMap["Red Miles Activated"] =  carapace.usedMiles ? 1 : 0;
        statsMap["Players Murdered"] = carapace.playerKillCount;
        statsMap["Times Died"] =  carapace.dead ? 1 : 0;
        statsMap["Times Exiled"] =  carapace.exiled ? 1 : 0;
        if(carapace.session.session_id >0) {
            if (carapace.active) activeSessions.add(carapace.session.session_id);
            if (carapace.everCrowned) crownedSessions.add(carapace.session.session_id);
        }

        //print("loaded carapace $carapace who is active ${statsMap["Times Activated"]} and sessions are now ${activeSessions.length} for active and ${crownedSessions.length} long for crowned");

    }

    void fromJSON(String jsonString) {
        //print("trying to make a carapace summary from $jsonString");
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        for(String key in statsMap.keys) {
            // print("checking num key of $key with value ${json[key]}");
            statsMap[key] = num.parse(json[key]);
        }
        aliases = json["aliases"];
        exampleName = json["exampleName"];
        initials = json["initials"];
        moon = json["moon"];
        activeSessions  = JSONObject.jsonStringToIntArray(json["activeSessions"]);
        crownedSessions  =  JSONObject.jsonStringToIntArray(json["crownedSessions"]);
       //print("DEBUG SHOGUNBOT: from json, sessions are now ${activeSessions.length} for active and ${crownedSessions.length} long for crowned, was ${json["activeSessions"]} and ${json["crownedSessions"]} respectively. ");
    }

    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        for(String key in statsMap.keys) {
            json[key] = statsMap[key].toString();
        }
        json["aliases"] = aliases;
        json["exampleName"] = exampleName;
        json["initials"] = initials;
        json["moon"] = moon;
        json["activeSessions"] = activeSessions.toString();
        json["crownedSessions"] = crownedSessions.toString();

        // print("DEBUG SHOGUNBOT:to json, sessions are now ${activeSessions.length} for active and ${crownedSessions.length} long for crowned and made it ${json["activeSessions"]} and ${json["crownedSessions"]} respectively");
        return json;
    }

    //add all others vars to yourself
    void add(CarapaceStats other) {
        for(String key in statsMap.keys) {
            if(other.statsMap.containsKey(key))statsMap[key] += other.statsMap[key];
        }
        activeSessions.addAll(other.activeSessions);
        crownedSessions.addAll(other.crownedSessions);

    }

    Element makePortrait() {
        DivElement div = new DivElement();
        div.classes.add("cardPortraitBG");
        div.style.backgroundImage = "url(images/BigBadCards/$moon.png)";
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${initials.toLowerCase()}.png");
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
            DivElement d = new DivElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.text = " $session_id, ";
            d.append(a);
            sessionsDiv.append(d);
        }

        DivElement crownedDiv = new DivElement();
        ret.append(crownedDiv);
        crownedDiv.setInnerHtml("Sessions Crowned In: ");
        DivElement crownedDiv2  = new DivElement();
        crownedDiv.append(crownedDiv2);
        for(int session_id in crownedSessions) {
            DivElement d = new DivElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.text = " $session_id, ";
            d.append(a);
            crownedDiv2.append(d);
        }
        pages.add(ret);
        return ret;

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


        DivElement name = new DivElement();
        name.classes.add("cardName");
        name.text = "Name: $exampleName ($initials)";
        DivElement alts = new DivElement();
        alts.text = "Aliases: ...";
        alts.classes.add("tooltip");
        alts.style.display = "block";
        DivElement altText = new DivElement();
        altText.classes.add("tooltiptext");
        alts.append(altText);
        altText.text = aliases;
        pageNum = new SpanElement();
        pageNum.classes.add("cardPageNum");
        alts.append(pageNum);
        name.append(alts);

        divBorder.append(div);
        div.append(makePortrait());
        div.append(name);
        div.append(makeStats());
        div.append(makeDescription());
        div.append(makeSessions());
        pageNum.text = "Page: ${currentPage+1}/${pages.length}";
    }

}

/*
    TODO: so how do i want this to work. This is a single object that ShogunBot has, but how does it get built?
    need to have an object LIKE this  for every SessionSummary maybe even still with CarapceStats...
    oh...could just literally use this, then also have a way to hrrrm....
 */
class CarapaceSummary {
    Map<String, CarapaceStats> data = new Map<String, CarapaceStats>();

    Session session;
    CarapaceSummary(Session this.session) {
        if(session == null) {
            defaultSession();
        }
        init();
    }
    void defaultSession() {
         session = new Session(-13);
         session.setupMoons();
    }


    void fromJSON(String jsonString) {
      //  print("trying to laod carapace summary from json");
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        List<dynamic> what = JSON.decode(json["data"]);
        for(dynamic d in what) {
            //print("dynamic json thing for carapace summary is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            //print("made a json object $j, going to make a carapace summary");
            CarapaceStats s = new CarapaceStats(null);
            //print("made a carapace summary, gonna load it from json");
            s.fromJSON(j.toString());
           // print("loaded that carapace summary to json");
            data[s.initials] = s;
        }

    }

    JSONObject toJSON() {
        JSONObject container  = new JSONObject();
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(CarapaceStats cs in data.values) {
            jsonArray.add(cs.toJSON());
        }
        container["data"] = jsonArray.toString();
        return container;
    }

    //if you add a carapace summary to yourself, you add all it's values to your own data.
    void add(CarapaceSummary other) {
        for(CarapaceStats cs in other.data.values) {
            if(data.containsKey(cs.initials)) {
                data[cs.initials].add(cs);
            }else {
                data[cs.initials] = cs;
            }
        }
    }

    void init() {

        List<GameEntity> npcs = session.activatedNPCS;
        //if moon is destroyed, all record of you is too. thems the breaks.
        //or....maybe i can keep a record. cuz it sure will look weird if jack kills more ppl than shogunbot thinks exist
        if(session.prospit != null) npcs.addAll(session.npcHandler.prospitians);

        npcs.add(session.battlefield.whiteKing);
        if(session.prospit != null) npcs.add(session.prospit.queen);
        if(session.derse != null) npcs.addAll(session.npcHandler.dersites);
        npcs.add(session.battlefield.blackKing);
        if(session.derse != null) npcs.add(session.derse.queen);


        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }
        }
    }
}

