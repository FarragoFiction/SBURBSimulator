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

//thing that creates the canvas happens before drawing can be a thing
//keep track of the methods you'll need to call for drawing to happen once appendHTML is called.
typedef DrawingMethod(String canvasID, List<Player> players);

class GetWasted extends Scene {
    //static Logger logger = Logger.get("GetWasted", false);
    List<DrawMethodWithParameter> drawingMethods = new List<DrawMethodWithParameter>();
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 13; //omg if i can balance things where 13 is the best tipping point i will be so fucking amused. (hey, did you know 13 is the SBURBSim arc number???)
    //for everything that's not a class or aspect but can be in any faq
    WeightedList<FAQFile> miscFAQS = new WeightedList<FAQFile>();
    //special ones based on current circumstances
    FAQFile murderModeFAQ = new FAQFile("Misc/MurderMode.xml");
    FAQFile tricksterFAQ = new FAQFile("Misc/Trickster.xml");
    FAQFile robotFAQ = new FAQFile("Misc/Robot.xml");
    FAQFile grimDarkFAQ = new FAQFile("Misc/GrimDark.xml");
    FAQFile bikeStuntsFAQ = new FAQFile("Misc/BikeStunts.xml");
    WeightedList<Aspect> possibleAspects = new WeightedList<Aspect>.from(Aspects.all, initialWeightSetter:(Aspect a, double w) => w * (a.isCanon ? 1.0 : 0.1));
    WeightedList<SBURBClass> possibleClasses = new WeightedList<SBURBClass>.from(SBURBClassManager.all, initialWeightSetter:(SBURBClass c, double w) => w * (c.isCanon ? 1.0 : 0.1));


    GetWasted(Session session) : super(session) {
        //TODO if i get enough generic shit, separate out into categories and weight as appropriate
        miscFAQS.add(new FAQFile("Misc/Meta.xml"), 0.1);
        miscFAQS.add(new FAQFile("Misc/FirstPlayers.xml"), 0.1);
        miscFAQS.add(new FAQFile("Misc/Generic.xml"));
    }

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
        if(p.gnosis >=4) return false; //you are done yo
        //linear works well for these
        if(p.gnosis == 1 || p.gnosis == 4) {
            return (p.getStat("sburbLore") >= tippingPointBase * (p.gnosis + 1)); //linear growth, but the base is high.
        }else {
            return (p.getStat("sburbLore") >= tippingPointBase/2 * (p.gnosis + 1));
        }
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
        }else if (player.gnosis == 3) {
            tier3(div);
        }else if(player.gnosis == 4) {
            tier4(div);
        }
    }

    ///this isn't WRITING an faq, it's finding one.  less constraints.
    ///gotta take in a random or i'll lose determinism
    void getRandomFAQSections(Element div, GeneratedFAQ gfaq) {
        gfaq.sectionsRequested ++;
       // print ("trying to find random faq in session: ${session.session_id}, this is ${gfaq.sectionsRequested} time" );
        FAQFile f;
        WeightedList<FAQFile> possibilities = new WeightedList<FAQFile>();
        //class and aspect are less likely than generic, since they will have less entries
        possibilities.add(gfaq.author.aspect.faqFile,0.5);
        possibilities.add(gfaq.author.class_name.faqFile,0.5);
        possibilities.addAll(miscFAQS);
        //conditional
        if(gfaq.author.murderMode)   possibilities.add(murderModeFAQ);
        if(gfaq.author.trickster)   possibilities.add(tricksterFAQ);
        if(gfaq.author.robot)   possibilities.add(robotFAQ);
        if(gfaq.author.grimDark > 3)   possibilities.add(grimDarkFAQ);

        f = gfaq.rand.pickFrom(possibilities);
        if(f == murderModeFAQ) print("AB: MurderModeFAQ in session ${session.session_id} ");
        if(f == tricksterFAQ) print("AB: TricksterFAQ in session ${session.session_id} ");
        if(f == robotFAQ) print("AB: RobotFAQ in session ${session.session_id} ");
        if(f == grimDarkFAQ) {
            gfaq.grimDark = true;
            print("AB: GrimDarkFAQ in session ${session.session_id} ");
        }
        f.getRandomSectionAsync(getRandomFAQSectionsCallback, div, gfaq);
        //FUTURE JR: THAT CALL UP THERE IS ASYNC SO YOU CAN'T DO ANYTH1NG ELSE NOW. ONLY CALLBACKS
    }

    ///since the getting a section might be async, can't rely on returns, only callbacks
    void getRandomFAQSectionsCallback(FAQSection s, Element div, GeneratedFAQ gfaq) {
        //print("callback chose section $s");
        if(s != null) gfaq.sections.add(s);
        if(gfaq.sectionsRequested< gfaq.sectionsWanted) {
            //print ("callback gonna keep looking for sections" );
            getRandomFAQSections(div,gfaq); //get more
        }else if (gfaq.sections.length == gfaq.sectionsRequested) {
            //print ("getting ready to display ${div.id}, callback found sections: ${gfaq.sections}" );
            displayFAQ(div,gfaq);
        }else{
            print("??????????????????????????????????????? Why the FUCK did I get a callback for a section i didn't request????????????????????????????????????????????");
        }
    }

    //TODO leave this here for now, but put with other player stuff later when i shove into a class
    Player makeRandomPlayer(r) {
        //weighted against fanon
        SBURBClass c = r.pickFrom(possibleClasses);
        Aspect a = r.pickFrom(possibleAspects);

        Player p = new Player(session, c, a, null, null, null);
        //TODO let the player be one of us, if so, VERY high chance of meta FAQ
       // print("making an faq from player $p");
        p.interest1 = InterestManager.getRandomInterest(r);
        p.interest2 = InterestManager.getRandomInterest(r);
        if (p.isTroll) {
            p.quirk = randomTrollSim(r, p); //not same quirk as guardian;
        } else {
            p.quirk = randomHumanSim(r, p);
        }
        //so they can make stupid faqs
        if(rand.nextDouble() < .1) p.murderMode = true;
        if(rand.nextDouble() < .01) p.trickster = true;
        if(rand.nextDouble() < .01) p.robot = true;
        if(rand.nextDouble() < .1) p.grimDark = 4;
        p.chatHandle = getRandomChatHandle(r, p.class_name, p.aspect, p.interest1, p.interest2);
        return p;
    }

    void findRandomFAQ(Element div, Player reader) {
        //TODO pick an ascii out, aspect symbols generically, but if there's any rare segments could be bike or 4th wall etc.
        //TODO have local list of faq files for meta bullshit, like the First Player, the creators and wranglers, or maybe some of debug rambling
        ///futureJR: you're gonna wonder why i'm making a new random with the existing seed here
        /// it's because async is a fickle fucking bitch, and since i can't predict how long it will take, other scenes can eat the rand
        Random r = new Random(rand.nextInt());
        Player author = makeRandomPlayer(r); //can't use standard means cuz it uses wrong random
        GeneratedFAQ gfaq = new GeneratedFAQ(author,<FAQSection>[],r);
        gfaq.reader = reader; //have to store
        //TODO misc faqs and also only way to get meta faqs, like about First Players or Session 13
        getRandomFAQSections(div, gfaq); //<-- this is async, don't do anything after this dunkass
    }
    void writeFAQ(Element div) {
        //TODO pick an ascii out, aspect symbols generically, but if there's any rare segments could be bike or 4th wall etc.
        //TODO have local list of faq files for meta bullshit, like the First Player, the creators and wranglers, or maybe some of debug rambling
        ///futureJR: you're gonna wonder why i'm making a new random with the existing seed here
        /// it's because async is a fickle fucking bitch, and since i can't predict how long it will take, other scenes can eat the rand
        Random r = new Random(rand.nextInt());
        Player author = this.player; //can't use standard means cuz it uses wrong random
        GeneratedFAQ gfaq = new GeneratedFAQ(author, <FAQSection>[],r);
        gfaq.reader = author;
        //procedurally generated rap faqs. Question: How sick are your beats?
        getRandomFAQSections(div, gfaq); //<-- this is async, don't do anything after this dunkass

    }


    ///if you wrote it it will say that and also use your own quirk.
    ///IMPORTANT: FUTURE JR CAN'T RELY ON INSTANCE OF PLAYER BECAUSE ALL THIS SHIT IS ASYNC. player could be swapped for next scene.
    void displayFAQ(Element div, GeneratedFAQ faq) {
        if(faq.rendered) return; //don't render a second time you dunkass
        String text;
       // print("gonna display generated faq in div ${div.id} with ${faq.sections.length} sections ${faq.sections}");
        //TODO take one of the headers from sections and pass it here.
        if(faq.reader == faq.author) {
            text = "The ${faq.author.htmlTitle()}has been trying to explain to anyone who will listen how this bullshit game works. They finally just write a goddamned FAQ so they don't have to keep repeating themselves. I wonder what it says?";
        }else {
            text = "The ${faq.reader.htmlTitle()} seems to understand how this bullshit game works. They are reading a FAQ? Huh, I wonder where they found that?";
        }
        String id = "faq${div.id}${faq.author.id}";
        //alright, i've got the intro, and i've got the quirk. what now? well, need to print out the phrase and then a link to pop up the faq
        //then i need to make clicking that link do something, specifically make the faq visible.
        //so THEN i'll need to render the faq to a hidden element.  the GeneratedFAQ should probably handle that.
        appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>${faq.makeHtml(id)}</div>");
        //appendHtml(div, "$text <button id = 'button$id'>Read FAQ?</button> <br><br><div id = '$id'>DIV: Be Hidden</div>");
        hide(querySelector("#$id"));
        querySelector("#button$id").onClick.listen((e) {
            toggle(querySelector("#$id"));
        });

        querySelector("#close$id").onClick.listen((e) {
            hide(querySelector("#$id"));
        });
        faq.rendered = true;
    }

    String processTier3(Element div) {
        if(player.aspect == Aspects.SPACE || player.aspect == Aspects.BREATH) return exploitMobility(div);
        if(player.aspect == Aspects.HOPE || player.aspect == Aspects.LIGHT) return exploitFate(div);
        if(player.aspect == Aspects.TIME || player.aspect == Aspects.MIND) return exploitTime(div);
        if(player.aspect == Aspects.RAGE || player.aspect == Aspects.VOID) return exploitGlitches(div);
        if(player.aspect == Aspects.HEART || player.aspect == Aspects.BLOOD) return exploitFriendship(div);
        if(player.aspect == Aspects.LIFE || player.aspect == Aspects.DOOM) return exploitDoom(div);
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";
    }

    //set up teleporters or flying mounts so quests are WAY easier to do
    String exploitMobility(Element div) {
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB. ";
        if(player.aspect == Aspects.BREATH) {
            ret = "They alchemize a series of game breaking as fuck flying items and pass them out to everyone";
        }else if(player.aspect == Aspects.SPACE) {
            ret = " They set up a frankly scandalous series of transportalizers";
        }else {
            ret = "";
        }
        ret += " , allowing all players to basically ignore their gates entirely and skip all the boring walking parts of their land quests. ";

        //i can't just call DoLandQuest cuz it will try to render itself, while this is a built string. so no helpers. oh well.
        print("AB: Exploiting mobility in session ${session.session_id}.");
        for(int i = 0; i<5; i++) {
            for(Player p in session.players) {
                if(p.land != null && p.grimDark <2) {
                    //print out random quest
                    if(!p.dead) {
                        ret += "<Br>The ${p.htmlTitle()} does quests at ${p.shortLand()}, ${p.getRandomQuest()}. ";
                    }
                    p.increaseLandLevel();
                }else if(!p.dead) {
                    ret += "The ${p.htmlTitle()} grinds against random enemies. ";
                }
                //i will let even the dead get power tho, cuz the mobility exploit is still there when they get revived
                p.increasePower();
            }
        }

        return ret;

    }

    //auto english tier someone who it will work for
    String exploitFate(Element div) {
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";
    }

    //make doomed timeclone army
    String exploitTime(Element div) {
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";

    }

    //skaian magicent kinda deal
    String exploitGlitches(Element div) {
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";

    }

    //gather everyone on a planet with fast, repatable quests, have everybody do speed questing to get max interaction effects for effort given
    String exploitFriendship(Element div) {
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";

    }

    //make a prophecy, then make the prophecy happen and get around it (like that doom buff for makeDead)
    //so make dead auto works
    String exploitDoom(Element div) {
        //if it's doom it's straight up exploiting a prophecy
        //if life, it's using your ghost to buff yourself a LOT.
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB.";
        for(Player p in session.players) {
            //can't exploit a prophecy if they are already dead.
            if(!p.dead && p.prophecy != ProphecyState.FULLFILLED) {
                Player ghost = session.afterLife.findAnyUndrainedGhost(rand);
                ///only added if somebody has this apply.
                String subRet = "They curse the ${p.htmlTitle()} with a prophecy of doom, only to kill them instantly and then revive them. The bonus the ${p.htmlTitle()} gets from subverting their fate is verging on cheating.";
                if(player.aspect == Aspects.LIFE) subRet = "The ${player.htmlTitle()} exploits the rules of SBURB.  They kill the ${p.htmlTitle()} then revive them with a huge bonus from absorbing their own ghost.";

                String divID = "gnosis3${div.id}player${p.id}";
                subRet += "<br><canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
                //picture shown differs based on method.
                if(p.dreamSelf && !p.isDreamSelf && p != player) { //corpse smooch
                    p.prophecy = ProphecyState.ACTIVE;
                    p.makeDead("exploiting SBURB mechanics");
                    drawingMethods.add(new DrawMethodWithParameter(drawCorpseSmooch,divID, [p, player]));
                    p.makeAlive();
                    ret += subRet;
                }else if(p.godTier) { //they will god tier revive
                    p.prophecy = ProphecyState.ACTIVE;
                    p.makeDead("exploiting SBURB mechanics");
                    drawingMethods.add(new DrawMethodWithParameter(drawGodRevive,divID,[p, player]));
                    p.makeAlive();
                    ret += subRet;
                }else if(player != player && ghost != null && (player.class_name == SBURBClassManager.ROGUE || player.class_name == SBURBClassManager.MAID)) {  //you will ghost revive their ass
                    p.prophecy = ProphecyState.ACTIVE;
                    p.makeDead("exploiting SBURB mechanics");
                    drawingMethods.add(new DrawMethodWithParameter(drawGhostRevive,divID,[p, ghost, player]));
                    p.makeAlive();
                    ret += subRet;
                }
            }
        }
        return ret;
    }

    ///first player is corpse, second is smoocher
    void drawCorpseSmooch(String canvasID, List<Player> players) {
        Drawing.drawCorpseSmooch(querySelector("#${canvasID}"), players[0], players[1]);
    }

    ///first player is corpse,second is ghost, third is player
    void drawGodRevive(String canvasID, List<Player> players) {
        Drawing.drawGodRevival(querySelector("#${canvasID}"), [players[0]], []);
    }

    ///first player is corpse, second is ghost wrangler
    void drawGhostRevive(String canvasID, List<Player> players) {
        CanvasElement canvas = Drawing.drawReviveDead(querySelector("#${canvasID}"), players[0], players[1], players[2].name);

        CanvasElement pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
        Drawing.drawSprite(pSpriteBuffer, players[2]);
        Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer, 0, 0);
    }




    //simple, foreshadowing things
    void tier1(Element div) {
        session.hasTier1Events = true;
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        //chance of finding a faq
        findRandomFAQ(div, player); //have to pass player cause async bs means i can't trust instance vars to not change
    }

    void tier2(Element div) {
        session.hasTier2Events = true;
        //this tier will unlock frog breeding and various free will shits besides english tier.
        //can also write a faq
        writeFAQ(div);
        //in addition to unlocking other scenes, have some tier 2 shit here as well
        //small boost to space player land leve, for example. maybe some grist for everyone (once that's a thing)
        Player space = findAspectPlayer(this.session.players, Aspects.SPACE);
        if(space == null) return;
        space.increaseLandLevel(5.0);
        String ret = "<Br><br>Holy shit, the ${player.htmlTitle()} just figured out how important Frogs are to beating this game. ";
        if(space == player) {
            ret += " They waste no time and just fucking DO it. ";
            if(player.class_name == SBURBClassManager.WASTE) ret += " They DO waste some space though. It's only natural. ";
        }else {
            ret += " They bug and fuss and meddle until the ${space.htmlTitle()} just fucking DOES it. ";
        }
        ret += "<br><br>";
        appendHtml(div, ret );

    }

    void tier3(Element div) {
        session.hasTier3Events = true;
        List<String> flavorText = <String>["In a moment of revelawesome The ${this.player.htmlTitle()} realizes a fundamental truth:"] ;
        if(player.aspect == Aspects.LIGHT || player.aspect == Aspects.VOID)     flavorText.add("'A Hero is just a person who stands up and makes a diffrence.' ");
        if(player.aspect == Aspects.HOPE || player.aspect == Aspects.SPACE)     flavorText.add("'Anything one imagines, one can make real.' ");
        if(player.aspect == Aspects.DOOM || player.aspect == Aspects.TIME)     flavorText.add("'Fate is just the choices we have yet to make.' ");
        if(player.aspect == Aspects.BREATH || player.aspect == Aspects.MIND)     flavorText.add("'Reality is written in the ink of people's lives.' ");
        if(player.aspect == Aspects.RAGE || player.aspect == Aspects.LIFE)     flavorText.add("'Knowledge and Desire are meaningless without the strengh to see them through.' ");
        if(player.aspect == Aspects.BLOOD || player.aspect == Aspects.HEART)     flavorText.add("'When we combine the light that shines within, there is nothing we can't do.' ");
        if(flavorText.length == 1) flavorText.add("Nothing is true, everything is permitted."); //i.e. aspect not found
        flavorText.add("<BR><BR>");
        flavorText.add(processTier3(div));
        appendHtml(div,flavorText.join("")); //won't let me just add strings without yellow squiggle.
        drawAll();
    }

    void tier4(Element div) {
        session.hasTier4Events = true;
        //todo waste tier, will be dope as fuk
        //FUTUREJR: DO NOT FORGET THIS JOKE:  WASTES OF HOPE SHOULD SET GameEntity.minPower TO 9001.
        /*	//if i have less than expected grist, then no frog, bucko
	int expectedGristContributionPerPlayer = 8000;
	int minimumGristPerPlayer = 5000; //less than this, and no frog is possible. can also be moded by hope player
	*/
        appendHtml(div, "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT. ${player.htmlTitle()} has:  ${player.gnosis} gnosis.");
    }

    //i have been keeping track of every canvas i have created. now that it's appended, draw them.
    void drawAll() {
        for(DrawMethodWithParameter m in drawingMethods) {
            m.call();
        }
        drawingMethods.clear();
    }
}

class DrawMethodWithParameter {
    DrawingMethod method;
    String parameter;
    List<Player> players;
    DrawMethodWithParameter(this.method, this.parameter, this.players);

    void call() {
        method(parameter, players);
    }
}

