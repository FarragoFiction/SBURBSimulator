import "dart:html";
import "../SBURBSim.dart";


class CarapaceStats {

    List<int> sessions = new List<int>();

    String aliases;
    String exampleName;
    String initials;
    String moon;

    //todo figure out how i want to collect stats.
    CarapaceStat timesActivated = new CarapaceStat("Times Activated");
    CarapaceStat timesCrowned = new CarapaceStat("Times Crowned");
    CarapaceStat carapacesMurdered = new CarapaceStat("Carapaces Murdered");
    CarapaceStat moonsMurdered = new CarapaceStat("Moons Murdered");
    CarapaceStat planetsMurdered = new CarapaceStat("Planets Murdered");
    CarapaceStat redMilesUsed =  new CarapaceStat("Red Miles Activated");
    CarapaceStat playersMurdered = new CarapaceStat("Players Murdered");
    CarapaceStat timesDied = new CarapaceStat("Times Died");
    CarapaceStat timesExiled = new CarapaceStat("Times Exiled");

    List<CarapaceStat> get stats => <CarapaceStat>[timesActivated,timesCrowned,carapacesMurdered,moonsMurdered,planetsMurdered,redMilesUsed,playersMurdered,timesDied,timesExiled];



    CarapaceStats(Carapace carapace) {
        this.initials = carapace.initials;
        this.exampleName = carapace.name;
        this.aliases = carapace.aliases;
        this.moon = carapace.type;
        sessions.addAll([13,8,4037,413,1025,612]);
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
        for(CarapaceStat cs in stats) {
            DivElement tmp = new DivElement();
            tmp.classes.add("cardStatBox");
            SpanElement first = new SpanElement();
            first.setInnerHtml("${cs.name}:");
            first.classes.add("cardStatName");

            SpanElement second = new SpanElement();
            second.classes.add("cardStatValue");
            second.setInnerHtml("${cs.value}");
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

class CarapaceSummary {
    Map<String, CarapaceStats> data = new Map<String, CarapaceStats>();

    CarapaceSummary() {
        init();
    }

    void init() {
        NPCHandler npcHandler = new NPCHandler(new Session(-13));
        List<GameEntity> npcs = npcHandler.getProspitians();
        npcs.addAll(npcHandler.getDersites());

        for(GameEntity g in npcs) {
            if(g is Carapace) {
                CarapaceStats s = new CarapaceStats(g);
                data[s.initials] = s;
            }
        }
    }
}

class CarapaceStat {
    String name;
    int value;
    CarapaceStat(this.name, [this.value=0]);
}