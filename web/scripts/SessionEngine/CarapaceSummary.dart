import "dart:html";
import "../SBURBSim.dart";


class CarapaceStats {

    List<int> sessions = new List<int>();

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
        this.moon = carapace.type;
        sessions.addAll([13,8,4037,413,1025,612]);
    }

    Element makePortrait() {
        DivElement div = new DivElement();
        div.classes.add("cardPortrait");
        div.style.backgroundImage = "url(images/BigBadCards/$moon.png)";

        return div;
    }

    Element makeStats() {
        DivElement div = new DivElement();
        div.classes.add("cardStats");
        for(CarapaceStat cs in stats) {
            DivElement tmp = new DivElement();
            SpanElement first = new SpanElement();
            first.setInnerHtml("<b>${cs.name}</b>:");
            SpanElement second = new SpanElement();
            second.setInnerHtml("${cs.value}");
            tmp.append(first);
            tmp.append(second);
            div.append(tmp);
        }

        div.appendHtml("Sessions Active In:");
        for(int session_id in sessions) {
            AnchorElement a = new AnchorElement();
            a.href = "index2.html?seed=$session_id";
            a.text = " $session_id, ";
            div.append(a);
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
        name.text = "Initials: $initials";

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