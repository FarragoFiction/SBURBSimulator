import "dart:html";

import "../SBURBSim.dart";
//import "../includes/Logger.dart";
import "../navbar.dart";

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
    //static Logger logger = Logger.get("GetWasted", false);
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 3;
    List<FAQSection> sections = new List<FAQSection>();
    int numTries = 0;
    int numSegmentsPerFAQ = 10;
    ///instead of a random chance of faq, don't try to make one if you're still making one from previous scene. fucking async bullshit.
    bool  stillMakingFAQ = false;

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
       // logger.verbose("Getting Wasted in session ${session.session_id}");
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
    void getRandomFAQSections(Element div, Player author, Random r) {
        numTries ++;
        print ("trying to find random faq in session: ${session.session_id}, this is $numTries time" );
        FAQFile f = rand.pickFrom(Aspects.all).faqFile;
        f.getRandomSectionAsync(rand,getRandomFAQSectionsCallback, div, author);
        //FUTURE JR: THAT CALL UP THERE IS ASYNC SO YOU CAN'T DO ANYTH1NG ELSE NOW. ONLY CALLBACKS
    }

    ///since the getting a section might be async, can't rely on returns, only callbacks
    void getRandomFAQSectionsCallback(FAQSection s, Element div, Player author, Random r) {
        print("chose section $s");
        if(s != null) sections.add(s);
        if(sections.length < numSegmentsPerFAQ && numTries < 10) {
            getRandomFAQSections(div,author,r); //get more
        }else {
            print ("found sections: ${sections}" );
            displayFAQ(div, false,author);
        }
    }

    void findRandomFAQ(Element div, Player author) {
        stillMakingFAQ = true;
        //TODO pick an ascii out, aspect symbols generically, but if there's any rare segments could be bike or 4th wall etc.
        //TODO have local list of faq files for meta bullshit, like the First Player, the creators and wranglers, or maybe some of debug rambling
        ///futureJR: you're gonna wonder why i'm making a new random with the existing seed here
        /// it's because async is a fickle fucking bitch, and since i can't predict how long it will take, other scenes can eat the rand
        getRandomFAQSections(div, author, new Random(rand.nextInt())); //<-- this is async, don't do anything after this dunkass
    }

    ///if you wrote it it will say that and also use your own quirk.
    ///IMPORTANT: FUTURE JR CAN'T RELY ON INSTANCE OF PLAYER BECAUSE ALL THIS SHIT IS ASYNC. player could be swapped for next scene.
    void displayFAQ(Element div, bool wroteFAQ, Player author) {
        Quirk quirk;
        String text;
        print("gonna display generated faq with ${sections.length} sections $sections");
        //TODO take one of the headers from sections and pass it here.
        GeneratedFAQ gfaq = new GeneratedFAQ(author,"THIS IS JUST A TEST OKAY???", sections);
        if(wroteFAQ) {
            text = "They are writing a FAQ? I wonder what it says?";
            quirk = player.quirk;
        }else {
            text = "They are reading a FAQ? Huh, I wonder where they found that?";
            if(rand.nextBool()) {
                quirk = randomHumanSim(rand, player);  //eeeeeeh...it's probably fine to just pass myself
            }else {
                quirk = randomTrollSim(rand, player);  //probably
            }
        }
        String id = "faq${div.id}${player.id}";
        //alright, i've got the intro, and i've got the quirk. what now? well, need to print out the phrase and then a link to pop up the faq
        //then i need to make clicking that link do something, specifically make the faq visible.
        //so THEN i'll need to render the faq to a hidden element.  the GeneratedFAQ should probably handle that.
        appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>${gfaq.makeHtml()}</div>");
        //appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>DIV: Be Hidden</div>");
        hide(querySelector("#$id"));
        querySelector("#button$id").onClick.listen((e) {
            print("toggling ${id}");
            toggle(querySelector("#$id"));
        });

        stillMakingFAQ = false;

    }




    //simple, foreshadowing things
    void tier1(Element div) {
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        //chance of finding a faq
        if(!stillMakingFAQ) findRandomFAQ(div, player); //have to pass player cause async bs means i can't trust instance vars to not change
        appendHtml(div, "The ${player.htmlTitle()} seems to understand how this bullshit game works. ");
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
