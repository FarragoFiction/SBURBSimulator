import "dart:html";
import "../../SBURBSim.dart";


///if a land is out of quests, destroy the land, queue up next "quest" in dead land (i.e. write a blurb aobut whatever happened to the destroyed land)
///and then get the next land ready.
class DeadQuests extends Scene {

    DeadQuests(Session session) : super(session);

    @override
    void renderContent(Element div) {
        // TODO: implement renderContent
    }

    @override
    bool trigger(List<Player> playerList) {
        // TODO: implement trigger
    }
}