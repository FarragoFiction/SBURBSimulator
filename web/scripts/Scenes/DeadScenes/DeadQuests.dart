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
        String html = "";
    }

    @override
    bool trigger(List<Player> playerList) {
       throw ("todo");
    }
}