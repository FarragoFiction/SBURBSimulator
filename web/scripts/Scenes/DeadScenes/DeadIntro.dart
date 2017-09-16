import "dart:html";
import "../../SBURBSim.dart";


///completely different intro from a regular session, none of that boring "dialogue" that regular sessions start with.
///
class DeadIntro extends Scene {

    DeadIntro(Session session) : super(session);

    @override
    void renderContent(Element div) {
        Player player = session.players[0];
        String divID = "deadIntro${session.players[0].id}";
        String narration = "A wave of destruction heralds the arrival of the ${player.htmlTitle()}. They are the only Player. SBURB was never meant to be single player, and they have activated the secret 'Dead Session' mode as a punishment. Or is it a reward?  ";
        narration += " Skaia is black and lifeless. The Land itself is merely the ${player.htmlTitle()}'s now barren home world, dragged kicking and screaming into the session. ";
        narration += "What can they even do now? Is there even a way to win? ";
        String html = "<canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas><br><Br>$narration";
        appendHtml(div, html);
        Drawing.drawSinglePlayer(querySelector("#${divID}"), player);

    }

    @override
    bool trigger(List<Player> playerList) {
        return true;
    }
}