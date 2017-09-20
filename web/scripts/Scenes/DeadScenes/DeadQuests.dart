import "dart:html";
import "../../SBURBSim.dart";


///if a land is out of quests, destroy the land, queue up next "quest" in dead land (i.e. write a blurb aobut whatever happened to the destroyed land)
///and then get the next land ready.
///first set of DeadLand quests should be doing tedius, boring shit.  (i.e. planets.length == 0 && won == false)
///once those are done, planets are created and given to the session.
///once all planets are clear, big stupid boss fight. then victory.
class DeadQuests extends Scene {

    DeadQuests(Session session) : super(session);

    @override
    void renderContent(Element div) {
        if((session as DeadSession).currentLand != null) {
            throw "don't support child lands yet";
        }else {
            processMetaLand(div);
        }
    }

    void processMetaLand(Element div) {
        Player player = session.players[0];
        player.landFuture.initQuest(player);
        String html = "${player.landFuture.getChapter()}The ${player.htmlTitle()} is in the ${player.landFuture.name}.  ${player.landFuture.randomFlavorText(session.rand, player)} ";
        appendHtml(div, html);
        //doQuests will append itself.
        player.landFuture.doQuest(div, player, null);
        //TODO have trigger know if there are no more quests to do
    }

    @override
    bool trigger(List<Player> playerList) {
       return session.rand.nextBool();  //doesn't ALWAYS happen, there's also meta shit.
    }
}