import "dart:html";
import "../SBURBSim.dart";


class CarapaceStats {
    String initials;
    //todo figure out how i want to collect stats.
    int timesActivated = 0;

    CarapaceStats(Carapace carapace) {
        this.initials = carapace.initials;
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
        div.append(name);
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