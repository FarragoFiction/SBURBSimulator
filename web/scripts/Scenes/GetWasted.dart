import "dart:html";
import "../SBURBSim.dart";
/*
    These are how Wastes, and things that aspire to be Wastes, do their shit.
    sburbLore and Gnosis will function similarly to corruption and GrimDark.

    sburbLore will have a max value, and if it goes over that, gnosis goes up by 1
    This scene is the parallel of goGrim dark. When you go up by a gnosis level, this scene
    will say shit about it.  It will use Session Mutator to

 */

class GetWasted extends Scene {
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 3;

    GetWasted(Session session) : super(session);

    @override
    bool trigger(List<Player> playerList) {
        this.playerList = playerList;
        this.player = null;
        List<Player> possibilities = new List<Player>();
        for (Player p in session.availablePlayers) { //unlike grim dark, corpses are not allowed to have eureka moments.
            if (this.loreReachedTippingPoint(p)) {
                possibilities.add(p);
            }
        }
        this.player = rand.pickFrom(possibilities);
        return this.player != null;
    }

    bool loreReachedTippingPoint(Player p) {
        return p.getStat("sburbLore") >= tippingPointBase * (p.gnosis + 1); //linear growth, but the base is high.
    }

    @override
    void renderContent(Element div) {
        print("Getting Wasted in session ${session.session_id}");
        this.player.setStat("sburbLore", 0);
        this.player.gnosis ++;
        processTier(div);
    }

    void processTier(Element div) {
        if (player.gnosis == 1) {
            tier1(div);
        } else if (player.gnosis == 2) {
            tier2(div);
        } else {
            appendHtml(div, "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT. ${player.htmlTitle()} has:  ${player.gnosis} gnosis.");
        }
    }

    //simple, foreshadowing things
    void tier1(Element div) {
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        appendHtml(div, "The ${player.htmlTitle()} seems to understand how this bullshit game works. It's almost like they've been reading a FAQ or something.");
    }

    void tier2(Element div) {
        //this tier will unlock frog breeding and various free will shits besides english tier.
        appendHtml(div, "The ${player.htmlTitle()} has been trying to explain to anyone who will listen how this bullshit game works. Maybe they should just write a FAQ?");
    }
}
