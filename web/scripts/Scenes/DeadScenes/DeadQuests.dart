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

        if(section == 1) {
            processMetaLandIntro(div); //when it ends will handle intro.
        }else if (section == 2) {
            processMiddleQuests(div);
        }

    }

    void processMiddleQuests(Element div) {
        print("doing the middle quests which are whole planets worth of shit");
        /*
           Middle quests consist of  every quest in teh dead session's current land
           then a quest from the next denizen quest, and choosing new current land
           then every quest in the now current land, etc.
           when you beat, have dead session numberLandsRemaining decrement.
         */
        print("doing a meta land bullshit quest");
        Player player = session.players[0];
        Land l = (session as DeadSession).currentLand;
        l.initQuest(player);
        String html = "${l.getChapter()}The ${player.htmlTitle()} is in the ${l.name}.  ${l.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        l.doQuest(div, player, null);
        if(l.noMoreQuests) {
            chooseChildLand();
            middleIntermissions(div);
        }
    }


    void chooseChildLand() {
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        //will make a regular player land but with extra themes from the dead session.
        if(ds.numberLandsRemaining >1 ) {
            ds.currentLand = ds.players[0].spawnLand();
            //they aren't denizens for dead session, there can be only one.
            ds.currentLand.denizenFeature.name = "${ds.currentLand.name} Boss";
        }else {
            ds.currentLand = null;
        }
        print("choose a child land of ${ds.currentLand.name}");
    }

    void middleIntermissions(Element div) {
        print("sports intermissions.");
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        //TODO have the first quest in the dead land's denizen quests print out, which should
        //explain teh pool/bowling/solitaire/whatever theme.
        player.landFuture.initQuest(player);
        String html = "${player.landFuture.getChapter()}The ${player.htmlTitle()}  has completed one planet. ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.landFuture.doQuest(div, player, null);
    }

    void introduceSecondPartOfQuests(Element div) {
        print("introducing teh second part of the quest, where things really open up.");
        DeadSession ds = session as DeadSession;
        Player player = session.players[0];
        //TODO have the first quest in the dead land's denizen quests print out, which should
        //explain teh pool/bowling/solitaire/whatever theme.
        player.landFuture.initQuest(player);
        String html = "${player.landFuture.getChapter()}The ${player.htmlTitle()} looks up at the ${ds.numberLandsRemaining} planets now orbiting the ${player.landFuture.name}.  ${ds.metaPlayer.chatHandle} is a smug asshole as they explain what needs to happen next. ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.landFuture.doQuest(div, player, null);
        section = 2;
    }

    void processMetaLandIntro(Element div) {
        print("doing a meta land bullshit quest");
        Player player = session.players[0];
        player.landFuture.initQuest(player);
        String html = "${player.landFuture.getChapter()}The ${player.htmlTitle()} is in the ${player.landFuture.name}.  ${player.landFuture.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.landFuture.doQuest(div, player, null);
        if(player.landFuture.firstCompleted) {
            chooseChildLand();
            introduceSecondPartOfQuests(div);
        }
    }

    @override
    bool trigger(List<Player> playerList) {
       return session.rand.nextBool();  //doesn't ALWAYS happen, there's also meta shit.
    }
}