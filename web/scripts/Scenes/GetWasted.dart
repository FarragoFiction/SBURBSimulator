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
    ///gotta take in a random or i'll lose determinism
    void getRandomFAQSections(Element div, GeneratedFAQ gfaq) {
        gfaq.sectionsRequested ++;
        print ("trying to find random faq in session: ${session.session_id}, this is ${gfaq.sectionsRequested} time" );
        FAQFile f;
        if(gfaq.rand.nextBool()) {
            f = gfaq.author.aspect.faqFile;
        }else {
            f = gfaq.author.class_name.faqFile;
        }

        f.getRandomSectionAsync(getRandomFAQSectionsCallback, div, gfaq);
        //FUTURE JR: THAT CALL UP THERE IS ASYNC SO YOU CAN'T DO ANYTH1NG ELSE NOW. ONLY CALLBACKS
    }

    ///since the getting a section might be async, can't rely on returns, only callbacks
    void getRandomFAQSectionsCallback(FAQSection s, Element div, GeneratedFAQ gfaq) {
        print("callback chose section $s");
        if(s != null) gfaq.sections.add(s);
        if(gfaq.sectionsRequested< gfaq.sectionsWanted) {
            print ("callback gonna keep looking for sections" );
            getRandomFAQSections(div,gfaq); //get more
        }else if (gfaq.sections.length == gfaq.sectionsRequested) {
            print ("getting ready to display ${div.id}, callback found sections: ${gfaq.sections}" );
            displayFAQ(div, false,gfaq);
        }else{
            print("??????????????????????????????????????? Why the FUCK did I get a callback for a section i didn't request????????????????????????????????????????????");
        }
    }

    //TODO leave this here for now, but put with other player stuff later when i shove into a class
    Player makeRandomPlayer(r) {
        SBURBClass c = r.pickFrom(SBURBClassManager.all);
        Aspect a = r.pickFrom(Aspects.all);

        Player p = new Player(session, c, a, null, null, null);
        print("making an faq from player $p");
        p.interest1 = InterestManager.getRandomInterest(r);
        p.interest2 = InterestManager.getRandomInterest(r);
        if (p.isTroll) {
            p.quirk = randomTrollSim(r, p); //not same quirk as guardian;
        } else {
            p.quirk = randomHumanSim(r, p);
        }
        p.chatHandle = getRandomChatHandle(r, p.class_name, p.aspect, p.interest1, p.interest2);
        return p;
        }

    void findRandomFAQ(Element div) {
        //TODO pick an ascii out, aspect symbols generically, but if there's any rare segments could be bike or 4th wall etc.
        //TODO have local list of faq files for meta bullshit, like the First Player, the creators and wranglers, or maybe some of debug rambling
        ///futureJR: you're gonna wonder why i'm making a new random with the existing seed here
        /// it's because async is a fickle fucking bitch, and since i can't predict how long it will take, other scenes can eat the rand
        Random r = new Random(rand.nextInt());
        Player author = makeRandomPlayer(r); //can't use standard means cuz it uses wrong random
        GeneratedFAQ gfaq = new GeneratedFAQ(author,"THIS IS JUST A TEST OKAY???", <FAQSection>[],r);

        getRandomFAQSections(div, gfaq); //<-- this is async, don't do anything after this dunkass
    }

    ///if you wrote it it will say that and also use your own quirk.
    ///IMPORTANT: FUTURE JR CAN'T RELY ON INSTANCE OF PLAYER BECAUSE ALL THIS SHIT IS ASYNC. player could be swapped for next scene.
    void displayFAQ(Element div, bool wroteFAQ, GeneratedFAQ faq) {
        if(faq.rendered) return; //don't render a second time you dunkass
        String text;
        print("gonna display generated faq in div ${div.id} with ${faq.sections.length} sections ${faq.sections}");
        //TODO take one of the headers from sections and pass it here.
        if(wroteFAQ) {
            text = "They are writing a FAQ? I wonder what it says?";
        }else {
            text = "The ${faq.author.htmlTitle()} seems to understand how this bullshit game works. They are reading a FAQ? Huh, I wonder where they found that?";
        }
        String id = "faq${div.id}${faq.author.id}";
        //alright, i've got the intro, and i've got the quirk. what now? well, need to print out the phrase and then a link to pop up the faq
        //then i need to make clicking that link do something, specifically make the faq visible.
        //so THEN i'll need to render the faq to a hidden element.  the GeneratedFAQ should probably handle that.
        appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>${faq.makeHtml()}</div>");
        //appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>DIV: Be Hidden</div>");
        hide(querySelector("#$id"));
        querySelector("#button$id").onClick.listen((e) {
            print("toggling ${id}");
            toggle(querySelector("#$id"));
        });
        faq.rendered = true;
    }




    //simple, foreshadowing things
    void tier1(Element div) {
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        //chance of finding a faq
        findRandomFAQ(div); //have to pass player cause async bs means i can't trust instance vars to not change
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

