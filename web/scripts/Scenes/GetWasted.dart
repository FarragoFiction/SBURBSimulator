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
    List<DrawMethodWithParameter> drawingMethods = new List<DrawMethodWithParameter>();
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 20; //omg if i can balance things where 13 is the best tipping point i will be so fucking amused. (hey, did you know 13 is the SBURBSim arc number???)
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
        for (Player p in session.getReadOnlyAvailablePlayers()) { //unlike grim dark, corpses are not allowed to have eureka moments.
            if (this.loreReachedTippingPoint(p)) {
                possibilities.add(p);
            }
        }
        this.player = rand.pickFrom(possibilities);
        return this.player != null;
    }

    bool loreReachedTippingPoint(Player p) {
        int tippingPoint = tippingPointBase;
        if(p.aspect == Aspects.TIME) tippingPoint = tippingPoint * 4; //time has way too easy a chance to get here.
        if(p.gnosis ==3) tippingPoint = tippingPoint *2; //very last tier should be extra hard.
        if(p.gnosis >=4 || p.gnosis <0) return false; //you are done yo, or you are doing something weird (WM probably caused it)
        //linear works well for these
        return (p.getStat("sburbLore") >= tippingPoint * (p.gnosis + 1));
    }

    @override
    void renderContent(Element div) {
        session.logger.verbose("Getting Wasted in session ${session.session_id}");
        this.player.setStat("sburbLore", 0);
        this.player.gnosis ++;
        session.removeAvailablePlayer(this.player);
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
       // session.logger.info ("trying to find random faq in session: ${session.session_id}, this is ${gfaq.sectionsRequested} time" );
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
        if(f == murderModeFAQ)  //session.logger.info("AB:  MurderModeFAQ in session ${session.session_id} ");
        if(f == tricksterFAQ)  //session.logger.info("AB:  TricksterFAQ in session ${session.session_id} ");
        if(f == robotFAQ)  //session.logger.info("AB:  RobotFAQ in session ${session.session_id} ");
        if(f == grimDarkFAQ) {
            gfaq.grimDark = true;
             //session.logger.info("AB:  GrimDarkFAQ in session ${session.session_id} ");
        }
        f.getRandomSectionAsync(getRandomFAQSectionsCallback, div, gfaq);
        //FUTURE JR: THAT CALL UP THERE IS ASYNC SO YOU CAN'T DO ANYTH1NG ELSE NOW. ONLY CALLBACKS
    }

    ///since the getting a section might be async, can't rely on returns, only callbacks
    void getRandomFAQSectionsCallback(FAQSection s, Element div, GeneratedFAQ gfaq) {
        ////session.logger.info("callback chose section $s");
        if(s != null) gfaq.sections.add(s);
        if(gfaq.sectionsRequested< gfaq.sectionsWanted) {
            //session.logger.info ("callback gonna keep looking for sections" );
            getRandomFAQSections(div,gfaq); //get more
        }else if (gfaq.sections.length == gfaq.sectionsRequested) {
            //session.logger.info ("getting ready to display ${div.id}, callback found sections: ${gfaq.sections}" );
            displayFAQ(div,gfaq);
        }else{
            //session.logger.info("??????????????????????????????????????? Why the FUCK did I get a callback for a section i didn't request????????????????????????????????????????????");
        }
    }

    //TODO leave this here for now, but put with other player stuff later when i shove into a class
    Player makeRandomPlayer(r) {
        //weighted against fanon
        SBURBClass c = r.pickFrom(possibleClasses);
        Aspect a = r.pickFrom(possibleAspects);

        Player p = new Player(session, c, a, null, null, null);
        //TODO let the player be one of us, if so, VERY high chance of meta FAQ
       // //session.logger.info("making an faq from player $p");
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
       // //session.logger.info("gonna display generated faq in div ${div.id} with ${faq.sections.length} sections ${faq.sections}");
        //TODO take one of the headers from sections and pass it here.
        if(faq.reader == faq.author) {
            text = "The ${faq.author.htmlTitle()}has been trying to explain to anyone who will listen how this bullshit game works. They finally just write a goddamned FAQ so they don't have to keep repeating themselves. I wonder what it says?";
        }else {
            text = "The ${faq.reader.htmlTitle()} seems to understand how this bullshit game works. They are reading a FAQ? Huh, I wonder where they found that?";
        }
        String id = "faq${div.id}${faq.author.id}";
        //alright, i've got the intro, and i've got the quirk. what now? well, need to session.logger.info out the phrase and then a link to pop up the faq
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
        if(player.aspect == Aspects.TIME || player.aspect == Aspects.BREATH || player.aspect == Aspects.MIST) return exploitMobility(div);
        if(player.aspect == Aspects.HOPE || player.aspect == Aspects.LIGHT || player.aspect == Aspects.DICE || player.aspect == Aspects.SWEETS) return exploitFate(div);
        if(player.aspect == Aspects.RAGE || player.aspect == Aspects.MIND || player.aspect == Aspects.RAIN) return exploitTime(div);
        if(player.aspect == Aspects.SPACE || player.aspect == Aspects.VOID || player.aspect == Aspects.CHAOS || player.aspect == Aspects.SPARK) return exploitGlitches(div);
        if(player.aspect == Aspects.HEART || player.aspect == Aspects.BLOOD || player.aspect == Aspects.SAND) return exploitFriendship(div);
        if(player.aspect == Aspects.LIFE || player.aspect == Aspects.DOOM || player.aspect == Aspects.MIGHT) return exploitDoom(div);
        return "OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT.";
    }

    //set up teleporters or flying mounts so quests are WAY easier to do
    String exploitMobility(Element div) {
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB. ";
        if(player.aspect == Aspects.BREATH) {
            ret = "They alchemize a series of game breaking as fuck flying items and pass them out to everyone";
            ret += " , allowing all players to basically ignore their gates entirely and skip all the boring walking parts of their land quests. ";
        }else if(player.aspect == Aspects.TIME) {
            ret = " They set up a frankly scandalous series of time shenanigans";
            ret += " , allowing all players to basically spam multiple quests 'at the same time'. ";
        }else{
            ret = "They set up a series of overpowered mist-based teleportation systems";
            ret += " , allowing all players to basically spam multiple quests one after another";
        }
            ret = "";
        //i can't just call DoLandQuest cuz it will try to render itself, while this is a built string. so no helpers. oh well.
         //session.logger.info("AB:  Exploiting mobility in session ${session.session_id}.");
        for(int i = 0; i<5; i++) {
            for(Player p in session.players) {
                if(p.land != null && p.grimDark <2) {
                    //session.logger.info out random quest
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

    //auto english tier someone be lucky enough or hopeful enough that it works for EVERYONE
    String exploitFate(Element div) {
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB.  They know what it takes to reach god tier, and whoever they can't convince, they ambush. ";
        if(this.player.aspect == Aspects.HOPE) {
            ret += " They believe with all their heart that this plan will work.  It helps that they don't even have a clue that whole 'god tier destiny' bullshit exists.  ";
        }else if (this.player.aspect == Aspects.LIGHT){
            ret += " Regardless of what destiny says, they are lucky enough bastards that the plan goes off without a hitch. ";
        }else if (this.player.aspect == Aspects.DICE) {
            ret += " They alchemize a game breaking pair of dice. The dice cast a completely random effect. Upon rolling, all player randomly godtier! Scooore! ";
        }else if (this.player.aspect == Aspects.SWEETS) {
            ret += "They're so hyper! CANDY! LOVE! JOY! FUN! THEY RUN AROUND, KILLING EVERYBODY IN AN ATTEMPT TO MAKE THEM JUST LIKE THEM! All they managed to do was godtier them though. ";
        }

        List<Player> fledglingGods = new List<Player>();
        for(Player p in session.players) {
            if(!p.godTier) {
                //you don't even have to be alive for this to work, they'll just drag your body to the slab and hope/luck it into working.
                if(!p.dead) p.makeDead("exploiting SBURB to becoome a god.");
                p.makeGodTier();
                fledglingGods.add(p);
            }
        }

        String divID = "gnosis3${div.id}player${player.id}";
        ret += "<br><canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";

        drawingMethods.add(new DrawMethodWithParameter(drawGodTiers,divID, fledglingGods));
        return ret;
    }

    //make doomed timeclone army
    String exploitTime(Element div) {
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB. They begin seriously planning to utterly fuck over the timeline. ";
        if(this.player.aspect == Aspects.RAGE) {
            ret += " They use their innate sense of ignoring Skaia's wishes to plan to fuck shit up in subtle ways.  No, Skaia, I WON'T be eating that apple when you want me to. Don't like that, don't make me get the god pjs out, I'll do it!";
        }else if (this.player.aspect == Aspects.MIND){
            ret += " They use their innate sense of the consequences of actions to fuck up causality entirely. Pardoxes ahoy. ";
        }else if (this.player.aspect == Aspects.RAIN) {
          ret += " Completely unintentionally, they create a shit ton of clones. Apparently their alternate timeline self meant to or something? Ugh, mist.";
        }
          List<Player> timePlayers = findAllAspectPlayers(
              session.players, Aspects.TIME);

        List<Player> doomedTimeClones = new List<Player>();
        ret += " As expected, a small army of doomed time clones arrives to stop their many, many terrible ideas and fallback ideas. Now the various boss fights should be a lot easier. ";
        for(int i = 0; i<12; i++) {
            Player chosen;
            //if multiple time players, any can be here
            Player timePlayer = rand.pickFrom(timePlayers);
            if(timePlayer.isActive() || (!timePlayer.isActive() && rand.nextBool())){
                chosen = timePlayer;
            }else{
                chosen = rand.pickFrom(session.players);
            }
            Player doomedTimeClone = Player.makeDoomedSnapshot(chosen);
            chosen.addDoomedTimeClone(doomedTimeClone);
            doomedTimeClones.add(doomedTimeClone);

        }
        String divID = "gnosis3${div.id}player${player.id}";
        ret += "<br><canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";

        drawingMethods.add(new DrawMethodWithParameter(drawPoseAsTeam,divID, doomedTimeClones));
        return ret;
    }

    //skaian magicent kinda deal
    String exploitGlitches(Element div) {
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB.";
        if(player.aspect == Aspects.VOID) {
            ret += " Uh.  Where did they go? <div class = 'void'> ";
        }else if(player.aspect == Aspects.SPACE) {
            ret +=
            " They discover a glitchy, half finished area. I didn't even know it was there???  Wow, look at all that grist and fraymotifs they come out with. What the fuck?<br>";
        }else if(player.aspect == Aspects.CHAOS) {
            " They temporarily blink out of existence. When they return, everybody seems to have learned a new fraymotif??? And what's the giant pile of grist doing there?";
        }else if(player.aspect == Aspects.SPARK) {
            " They focus all their energy into breaking the game, and BOOM! They find themselves in a glitchy area full of framotifs and grist! Hell yeah!";
        }
        for(Player p in session.players) {
            //conceit is they found a glitched denizen hoarde.  Grist and tier 3 fraymotifs for everyone. Most denizens only give 2, but this is glitchy and hidden.
            String title = "Skaian Magicant Hidden Track: ${p.aspect.name} Edition";
            if(!p.dead) ret += "<br> The ${p.htmlTitle()} collects the fraymotif $title, as well as a sizeable hoarde of grist.";
            Fraymotif f = new Fraymotif(title, 2);
            Iterable<AssociatedStat> plus = p.associatedStatsFromAspect; //buff self and heal. used to be only positive, but that gave witches/sylphs/princes/bards the shaft;
            //just like real denizen songs, but way stronger
            for (AssociatedStat pl in plus) {
                f.effects.add(new FraymotifEffect(pl.name, 0, true));
                f.effects.add(new FraymotifEffect(pl.name, 0, false));
            }
            Iterable<AssociatedStat> minus = p.associatedStatsFromAspect; //debuff enemy, and damage. used to be only negative, but that gave witches/sylphs/princes/bards the shaft;
            for (AssociatedStat m in minus) {
                f.effects.add(new FraymotifEffect(m.name, 2, true));
                f.effects.add(new FraymotifEffect(m.name, 2, false));
            }
            f.desc = "An unfinished secret track begins to play.  You don't think anybody meant for this to be unlockable. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter.  ";
            p.fraymotifs.add(f);
            p.grist += 1000;

        }
        if(player.aspect == Aspects.VOID) {
            ret += "</div>";
        }
        return ret;
    }

    //gather everyone on a planet with fast, repatable quests, have everybody do speed questing to get max interaction effects for effort given
    String exploitFriendship(Element div) {
        session.logger.info("AB: friendship tier3 happening.");
        String ret = "The ${player.htmlTitle()} exploits the rules of SBURB.";
        if(player.aspect == Aspects.BLOOD) {
            ret +=  "They find a fast, repeatable quest and organize everyone into ever-changing adventuring pairs to take advantage of the game's interaction effect bonus. ";
        }else {
            ret +=  "They find something called a 'Shipping Dunegon' and arrange everyone into various 'canon' and 'crackship' speed dates to take advantage of the game's interaction effect bonus. ";
        }
        ret += "<br>";
        //quest has shitty rewards. you get only interaction effects until i come back later and decide to balance shit
        for(Player p1 in session.players) {
                bool printedOnce = false;
                List<Player> shuffledPlayers = new List<Player>.from(session.players);
                shuffle(session.rand, shuffledPlayers);
                for(Player p2 in shuffledPlayers) {
                    if(p1 != p2) {
                        //happens multiple times but only session.logger.infos one, cuz it's not gonna be different
                        if(! printedOnce && !p2.dead && !p1.dead) { //prefer not to print about the dead
                            printedOnce = true;
                            ret += "<br>${p1.interactionEffect(p2)}  Other things with other friends happen as well, too numerous too list.";
                        }
                        p1.interactionEffect(p2);
                        p1.interactionEffect(p2);
                        p1.increasePower();
                    }
                }
        }
        return ret;

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
                if(player.aspect == Aspects.MIGHT) subRet = "The ${player.htmlTitle()} exploits the rules of SBURB. They kill all players, reviving them more powerful then ever with their OP might abilities.";
                if(player.aspect == Aspects.LIFE) subRet = "They kill the ${p.htmlTitle()} then revive them with a huge bonus from absorbing their own ghost.";

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


    void drawGodTiers(String canvasID, List<Player> players) {
        Drawing.drawGetTiger(querySelector("#${canvasID}"), players);
    }

    void drawPoseAsTeam(String canvasID, List<Player> players) {
        Drawing.poseAsATeam(querySelector("#${canvasID}"), players);
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

    void drawTier4(String canvasID, List<Player> players) {
        Drawing.drawEpicGodShit(querySelector("#${canvasID}"), players[0]);
    }




    //simple, foreshadowing things
    void tier1(Element div) {
        session.stats.hasTier1Events = true;
        //from manic i have hope, breath, doom and time, murder mode and rage upcoming
        //find FAQs, like Kanaya did. Will either be quirkless or in a random quirk. MOST things here will be intro effects
        //chance of finding a faq
        findRandomFAQ(div, player); //have to pass player cause async bs means i can't trust instance vars to not change
    }

    void tier2(Element div) {
        session.stats.hasTier2Events = true;
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
        session.stats.hasTier3Events = true;
        List<String> flavorText = <String>["In a moment of revelawesome The ${this.player.htmlTitle()} realizes a fundamental truth:"] ;
        if(player.aspect == Aspects.LIGHT || player.aspect == Aspects.VOID || player.aspect == Aspects.DICE)     flavorText.add("'A Hero is just a person who stands up and makes a diffrence.' ");
        if(player.aspect == Aspects.HOPE || player.aspect == Aspects.SPACE || player.aspect == Aspects.MIGHT)     flavorText.add("'Anything one imagines, one can make real.' ");
        if(player.aspect == Aspects.DOOM || player.aspect == Aspects.TIME || player.aspect == Aspects.MIST)     flavorText.add("'Fate is just the choices we have yet to make.' ");
        if(player.aspect == Aspects.BREATH || player.aspect == Aspects.MIND || player.aspect == Aspects.RAIN)     flavorText.add("'Reality is written in the ink of people's lives.' ");
        if(player.aspect == Aspects.RAGE || player.aspect == Aspects.LIFE || player.aspect == Aspects.SAND)     flavorText.add("'Knowledge and Desire are meaningless without the strengh to see them through.' ");
        if(player.aspect == Aspects.BLOOD || player.aspect == Aspects.HEART || player.aspect == Aspects.SPARK || player.aspect == Aspects.SWEETS)     flavorText.add("'When we combine the light that shines within, there is nothing we can't do.' ");
        if(flavorText.length == 1) flavorText.add("Nothing is true, everything is permitted."); //i.e. aspect not found
        flavorText.add("<BR><BR>");
        flavorText.add(processTier3(div));
        appendHtml(div,flavorText.join("")); //won't let me just add strings without yellow squiggle.
        drawAll();
    }

    void tier4(Element div) {
        if(player.trickster) {
            String rant = "Haha. No. Never ever ever again will I let a trickster into my code. Wow. No. Tier4 is locked to this asshole.  Sure I'll let the ${player.htmlTitle()} have the stat, but like HELL are they allowed to do anything with it.";
            appendHtml(div, "$rant");
            return;
        }
        session.stats.hasTier4Events = true;
        String divID = "tier4${div.id}${player.id}";
        String rant = "<Br><Br>Wait. What? Oh my fuck. Some asshole waste is fucking around in my code. Don't they know how dangerous that is??? God, if shit crashes, it's on them.";
        if(player.class_name == SBURBClassManager.GRACE) rant = "Bluh.  I don't trust that Grace in my code one bit. But I guess they ARE supposed to be more subtle than us Wastes....so....Maybe things WON'T crash?";
        if(player.class_name != SBURBClassManager.GRACE && player.class_name != SBURBClassManager.WASTE) rant = "... Oh. Fuck.  What the hell is a ${player.class_name.name.toUpperCase()} doing in my code. How did this even happen. Don't come crying to me when they fuck things up.";
        appendHtml(div, "$rant<canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>${player.aspect.activateCataclysm(session, player)}");
        session.mutator.checkForCrash(session);
        drawingMethods.add(new DrawMethodWithParameter(drawTier4,divID,[player]));
        drawAll();

        //TODO do I want any generic graphic here?

        //hell yes, tier 4, bitches.
        //TODO for void have ALL stats set to true, even if contradictory. can't use AB to get a read on the session. Number stats become obvious lies.
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

