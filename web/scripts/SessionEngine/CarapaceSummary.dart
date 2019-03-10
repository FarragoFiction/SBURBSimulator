import "dart:html";
import "../SBURBSim.dart";
import "SessionSummaryLib.dart";
import 'dart:convert';
import "dart:async";


class CarapaceStats extends BigBadStats{

    List<int> crownedSessions = new List<int>();

    String aliases;
    String initials;
    String moon;
    String description;


    CarapaceStats(GameEntity carapace):super(carapace) {
        if(carapace != null) {
            loadCarapace(carapace);
        }else {
            initStats();
        }
    }

    void initStats() {
        this.initials = "???";
        this.name = "???";
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
        //;
        this.initials = carapace.initials;
        this.name = carapace.name;
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
        //don't even bother.
        if(carapace.session.session_id >0 && !carapace.session.stats.scratched && !carapace.session.stats.hadCombinedSession) {
            if (carapace.active) activeSessions.add(carapace.session.session_id);
            if (carapace.everCrowned) crownedSessions.add(carapace.session.session_id);
        }

        //;

    }

    @override
    void fromJSON(String jsonString) {
        //;
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        for(String key in statsMap.keys) {
            // ;
            statsMap[key] = num.parse(json[key]);
        }
        aliases = json["aliases"];
        name = json["exampleName"];
        initials = json["initials"];
        moon = json["moon"];
        activeSessions  = JSONObject.jsonStringToIntArray(json["activeSessions"]);
        crownedSessions  =  JSONObject.jsonStringToIntArray(json["crownedSessions"]);
       //;
    }

    @override
    JSONObject toJSON() {
        JSONObject json = new JSONObject();
        for(String key in statsMap.keys) {
            json[key] = statsMap[key].toString();
        }
        json["aliases"] = aliases;
        json["name"] = name;
        json["initials"] = initials;
        json["moon"] = moon;
        json["activeSessions"] = activeSessions.toString();
        json["crownedSessions"] = crownedSessions.toString();

        // ;
        return json;
    }

    @override
    void add(BigBadStats other) {
        super.add(other);
        crownedSessions.addAll((other as CarapaceStats).crownedSessions);

    }

    @override
    Element makePortrait() {
        DivElement div = new DivElement();
        div.classes.add("cardPortraitBG");
        div.style.backgroundImage = "url(images/BigBadCards/$moon.png)";
        ImageElement portrait = new ImageElement(src: "images/BigBadCards/${initials.toLowerCase()}.png");
        portrait.onError.listen((e) {
            portrait.src = "images/BigBadCards/default.gif";
        });
        portrait.classes.add("cardPortrait");

        div.append(portrait);

        return div;
    }

    @override
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

        DivElement crownedDiv = new DivElement();
        ret.append(crownedDiv);
        crownedDiv.setInnerHtml("Sessions Crowned In: ");
        DivElement crownedDiv2  = new DivElement();
        crownedDiv.append(crownedDiv2);
        for(int session_id in crownedSessions) {
            SpanElement d = new SpanElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.target = "_blank";
            a.text = " $session_id, ";
            d.append(a);
            crownedDiv2.append(d);
        }
        pages.add(ret);
        return ret;

    }






    //display pic of prospit or derse.
    //display placeholder for the carpace in question.
    @override
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
        nameDiv.text = "Name: $name ($initials)";
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
        nameDiv.append(alts);

        divBorder.append(div);
        div.append(makePortrait());
        div.append(nameDiv);
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
class CarapaceSummary extends BigBadSummary {

    CarapaceSummary(session):super(session) {
        if(session == null) {
            defaultSession();
        }
        init();
    }



    void fromJSON(String jsonString) {
      //  ;
        JSONObject json = new JSONObject.fromJSONString(jsonString);
        List<dynamic> what = jsonDecode(json["data"]);
        for(dynamic d in what) {
            //;
            JSONObject j = new JSONObject();
            j.json = d;
            //;
            CarapaceStats s = new CarapaceStats(null);
            //;
            s.fromJSON(j.toString());
           // ;
            data[s.initials] = s;
        }

    }

    @override
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
    void add(BigBadSummary other) {
        for(CarapaceStats cs in other.data.values) {
            if(data.containsKey(cs.initials)) {
                data[cs.initials].add(cs);
            }else {
                data[cs.initials] = cs;
            }
        }
    }

    @override
    void init() {

        List<GameEntity> npcs = session.activatedNPCS;
        //if moon is destroyed, all record of you is too. thems the breaks.
        //or....maybe i can keep a record. cuz it sure will look weird if jack kills more ppl than shogunbot thinks exist
        if(session.prospit != null) npcs.addAll(session.npcHandler.prospitians);

        if(session.battlefield != null) npcs.add(session.battlefield.whiteKing);
        if(session.prospit != null) npcs.add(session.prospit.queen);
        if(session.derse != null) npcs.addAll(session.npcHandler.dersites);
        if(session.battlefield != null) npcs.add(session.battlefield.blackKing);
        if(session.derse != null) npcs.add(session.derse.queen);

        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }
        }
    }
}

