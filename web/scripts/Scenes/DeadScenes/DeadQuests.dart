import "dart:html";
import "../../SBURBSim.dart";


///if a land is out of quests, destroy the land, queue up next "quest" in dead land (i.e. write a blurb aobut whatever happened to the destroyed land)
///and then get the next land ready.
///first set of DeadLand quests should be doing tedius, boring shit.  (i.e. planets.length == 0 && won == false)
///once those are done, planets are created and given to the session.
///once all planets are clear, big stupid boss fight. then victory.
class DeadQuests extends Scene {
    int section = 1;
    DeadQuests(Session session) : super(session);

    @override
    void renderContent(Element div) {

        //TODO eventually moon should just have a copy of the player on it.
        if(session.rand.nextDouble() > .9 ) {
            processMoon(div); //will handle dream vs not dream stuff
        }else if(section == 1) {
            processMetaLandIntro(div); //when it ends will handle intro.
        }else if (section == 2) {
            processMiddleQuests(div);
        }else if(section == 3) {
            processEndQuests(div);
        }

    }


    void processMoon(Element div) {
        Player player = session.players[0];
        player.moon.initQuest([player]);
        String html = "${player.moon.getChapter()} ${player.moon.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        if(player.moon != null) {
            player.moon.doQuest(div, player, null);
        }else {
            session.furthestRing.doQuest(div, player, null);
        }
    }

    void processEndQuests(div) {
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        player.land.initQuest([player]);
        String html = "${player.land.getChapter()}  ";
        appendHtml(div, html);
        //doQuests will append itself.
        if(!player.land.doQuest(div, player, null)) (session as DeadSession).failed = true;
        if(player.land.thirdCompleted) {
            section = 4;
            //window.alert("I finished the last set!");
        }
    }

    void processMiddleQuests(Element div) {
        //;
        /*
           Middle quests consist of  every quest in teh dead session's current land
           then a quest from the next denizen quest, and choosing new current land
           then every quest in the now current land, etc.
           when you beat, have dead session numberLandsRemaining decrement.
         */
        Player player = session.players[0];
        Land l = (session as DeadSession).currentLand;
        if(!l.noMoreQuests) l.initQuest([player]);
        if(l.noMoreQuests || l.currentQuestChain == null) {
            //;
            chooseChildLand();
            middleIntermissions(div);
            return;
        }
       // ;
        List<GameEntity> choices = findLiving(player.companionsCopy);
        GameEntity helper = rand.pickFrom(choices);


        String helperText = "";
        if(helper != null) {
            //session.logger.info("Getting help in dead session from $helper");
            helperText = "$helperText ${player.interactionEffect(helper)} "; //players always have an effect.
            if (helper is Sprite) {
                helperText = "$helperText ${helper.htmlTitle()} ${(helper as Sprite).helpPhrase}<br><br>";
            } else if (helper is Consort) {
                //session.logger.info("AB: consort helper.");
                helperText = "$helperText The ${helper.htmlTitle()} is ${(helper as Consort).sound}ing. It's somehow helpful. ";
            } else if (helper is Leprechaun) {
                //session.logger.info("AB: leprechaun helper.");
                helperText = "$helperText The ${helper.htmlTitle()} is using Aspect powers in appropriate ways to clear the lands challenges for their Lord. ";
            } else {
                helperText = "$helperText The ${helper.htmlTitle()} is helping where they can. ";
            }
        }

        String html = "${l.getChapter()}The ${player.htmlTitleWithTip()} is in the ${l.name}. $helperText ${l.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        l.doQuest(div, player, null);

    }


    void chooseChildLand() {
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        //will make a regular player land but with extra themes from the dead session.
        if(ds.numberLandsRemaining >1 ) {
            ds.currentLand = ds.players[0].spawnLand();
            //they aren't denizens for dead session, there can be only one.
            ds.currentLand.denizenFeature.name = "${ds.currentLand.shortName} Boss";
        }else {
            ds.currentLand = null;
        }
       // ;
    }

    void middleIntermissions(Element div) {
       // ;
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        player.land.initQuest([player]);
        String html = "${player.land.getChapter()}  ";
        appendHtml(div, html);
        //doQuests will append itself.
        if(!player.land.doQuest(div, player, null)) (session as DeadSession).failed = true;
        if(player.land.secondCompleted) {
            section = 3;
            //window.alert("I finished the second set!");
        }
    }

    void introduceSecondPartOfQuests(Element div) {
        //;
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        //TODO have the first quest in the dead land's denizen quests print out, which should
        //explain teh pool/bowling/solitaire/whatever theme.
        player.land.initQuest([player]);
        String html = "${player.land.getChapter()}The ${player.htmlTitle()} looks up at the ${ds.numberLandsRemaining} planets now orbiting the ${player.land.name}.  ${ds.metaPlayer.chatHandle} is a smug asshole as they explain what needs to happen next. ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.land.doQuest(div, player, null);
        section = 2;
    }

    void processMetaLandIntro(Element div) {
        //;
        Player player = session.players[0];
        player.land.initQuest([player]);
        String html = "${player.land.getChapter()}The ${player.htmlTitle()} is in the ${player.land.name}.  ${player.land.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.land.doQuest(div, player, null);
        if(player.land.firstCompleted) {
            chooseChildLand();
            introduceSecondPartOfQuests(div);
        }
    }

    @override
    bool trigger(List<Player> playerList) {
        if((session as DeadSession).failed && session.timeTillReckoning > 11) session.timeTillReckoning = 10;
       return !(session as DeadSession).failed && section <4 && !session.players[0].dead && session.rand.nextDouble()<.75;  //doesn't ALWAYS happen, there's also meta shit.
    }
}