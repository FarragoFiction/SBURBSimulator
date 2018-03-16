import "dart:html";
import "../SBURBSim.dart";
import "SessionSummaryLib.dart";



class CarapaceStats {

    List<int> sessions = new List<int>();

    String aliases;
    String exampleName;
    String initials;
    String moon;


    Map<String, int> statsMap = new Map<String, int>();





    CarapaceStats(Carapace carapace) {
        this.initials = carapace.initials;
        this.exampleName = carapace.name;
        this.aliases = carapace.aliases;
        this.moon = carapace.type;
        statsMap["Times Activated"] = 0;
        statsMap["Times Crowned"] = 0;
        statsMap["Carapaces Murdered"] = 0;
        statsMap["Moons Murdered"] = 0;
        statsMap["Planets Murdered"] = 0;
        statsMap["Red Miles Activated"] = 0;
        statsMap["Players Murdered"] = 0;
        statsMap["Times Died"] = 0;
        statsMap["Times Exiled"] = 0;
        sessions.addAll([13,8,4037,413,1025,612]);
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

        return json;
    }

    //add all others vars to yourself
    void add(CarapaceStats other) {
        for(String key in statsMap.keys) {
            statsMap[key] += other.statsMap[key];
        }
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

        DivElement activeSession = new DivElement();
        activeSession.setInnerHtml("Sessions Active In: ...");
        activeSession.classes.add("tooltip");
        DivElement tooltipText  = new DivElement();
        tooltipText.classes.add("tooltiptext");
        activeSession.append(tooltipText);
        div.append(activeSession);
        for(int session_id in sessions) {
            DivElement d = new DivElement();
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.text = " $session_id, ";
            d.append(a);
            tooltipText.append(d);
        }

        return div;
    }



    //display pic of prospit or derse.
    //display placeholder for the carpace in question.
    Element getCard() {
        DivElement div = new DivElement();
        div.classes.add("collectibleCard");

        DivElement divBorder = new DivElement();
        divBorder.classes.add("collectibleCardBorder");

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
        name.append(alts);

        divBorder.append(div);
        div.append(makePortrait());
        div.append(name);
        div.append(makeStats());

        return divBorder;
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

    //if you add a carapace summary to yourself, you add all it's values to your own data.
    void add(CarapaceSummary other) {
        for(CarapaceStats cs in other.data.values) {
            data[cs.initials].add(cs);
        }
    }

    void init() {

        List<GameEntity> npcs = session.npcHandler.getProspitians();
        npcs.add(session.prospit.king);
        npcs.add(session.prospit.queen);
        npcs.addAll(session.npcHandler.getDersites());
        npcs.add(session.derse.king);
        npcs.add(session.derse.queen);


        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }
        }
    }
}

