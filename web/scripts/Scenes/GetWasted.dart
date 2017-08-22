import "dart:html";
import "../SBURBSim.dart";
/*
    These are how Wastes, and things that aspire to be Wastes, do their shit.
    sburbLore and Gnosis will function similarly to corruption and GrimDark.

    sburbLore will have a max value, and if it goes over that, gnosis goes up by 1
    This scene is the parallel of goGrim dark. When you go up by a gnosis level, this scene
    will say shit about it.  It will use Session Mutator to

    some sprites should give sburb lore just like corruption

    apparently i was cut out mid dispensing giggle snort and ppl lost their shit

 */

class GetWasted extends Scene {
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 3;
    List<FAQSection> sections = new List<FAQSection>();
    int numTries = 0;
    int numSegmentsPerFAQ = 2;

    GetWasted(Session session) : super(session);

    @override
    bool trigger(List<Player> playerList) {
        this.playerList = playerList;
        sections.clear();
        numTries = 0;
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

    ///this isn't WRITING an faq, it's finding one.  less constraints.
    void findRandomFAQSection() {
        numTries ++;
        print ("trying to find random faq in session: ${session.session_id}, this is $numTries time" );
        FAQFile f = rand.pickFrom(Aspects.all).faqFile;
        FAQSection s = f.getRandomSection(rand);
        if(s != null) sections.add(s);
       // if(sections.length < numSegmentsPerFAQ && numTries < 10) findRandomFAQSection();
    }

    void findRandomFAQ(Element div) {
        //TODO pick an ascii out, aspect symbols generically, but if there's any rare segments could be bike or 4th wall etc.
        //TODO have local list of faq files for meta bullshit, like the First Player, the creators and wranglers, or maybe some of debug rambling
        findRandomFAQSection();
        print ("found sections: ${sections}" );
        displayFAQ(div, false);

    }

    ///if you wrote it it will say that and also use your own quirk.
    void displayFAQ(Element div, bool wroteFAQ) {
        Quirk quirk;
        String text;
        if(wroteFAQ) {
            text = "The ${player.htmlTitle()} is reading an FAQ? Huh, I wonder where they found that?";
            quirk = player.quirk;
        }else {
            text = "The ${player.htmlTitle()} is reading an FAQ? Huh, I wonder where they found that?";
            if(rand.nextBool()) {
                quirk = randomHumanSim(rand, player);  //eeeeeeh...it's probably fine to just pass myself
            }else {
                quirk = randomTrollSim(rand, player);  //probably
            }
        }
        //alright, i've got the intro, and i've got the quirk. what now? well, need to print out the phrase and then a link to pop up the faq
        //then i need to make clicking that link do something, specifically make the faq visible.
        //so THEN i'll need to render the faq to a hidden element.  the GeneratedFAQ should probably handle that.

    }




    //simple, foreshadowing things
    void tier1(Element div) {
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        //chance of finding a faq
        findRandomFAQ(div);
        appendHtml(div, "The ${player.htmlTitle()} seems to understand how this bullshit game works. It's almost like they've been reading a FAQ or something.");
    }

    void tier2(Element div) {
        //this tier will unlock frog breeding and various free will shits besides english tier.
        //can also write a faq
        appendHtml(div, "The ${player.htmlTitle()} has been trying to explain to anyone who will listen how this bullshit game works. Maybe they should just write a FAQ?");
    }

    void tier3(Element div) {
        //TODO 3 will write a faq guaranteed, as well as doing some exploitation shit, like breeding combat frogs and shit, and unlocking free will english tier
        //woomod
        List<String> flavorText = <String>["In a moment of revelawesome The ${this.player.htmlTitle()} realizes a fundamental truth:"] ;
        if(player.aspect == Aspects.LIGHT || player.aspect == Aspects.VOID)     flavorText.add("'A Hero is just a person who stands up and makes a diffrence.'");
        if(player.aspect == Aspects.HOPE || player.aspect == Aspects.SPACE)     flavorText.add("'Anything one imagines, one can make real.'");
        if(player.aspect == Aspects.DOOM || player.aspect == Aspects.TIME)     flavorText.add("'Fate is just the choices we have yet to make.'");
        if(player.aspect == Aspects.BREATH || player.aspect == Aspects.MIND)     flavorText.add("'Reality is written in the ink of people's lives.'");
        if(player.aspect == Aspects.RAGE || player.aspect == Aspects.LIFE)     flavorText.add("'Knowledge and Desire are meaningless without the strengh to see them through.'");
        if(player.aspect == Aspects.BLOOD || player.aspect == Aspects.HEART)     flavorText.add("'When we combine the light that shines within, there is nothing we can't do.'");

        appendHtml(div,flavorText.join("")); //won't let me just add strings without yellow squiggle.
    }

    void tier4(Element div) {
        //todo waste tier, will be dope as fuk
    }
}
