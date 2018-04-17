import "dart:html";
import "../../SBURBSim.dart";
///this sounds like a badass cowboy thing
class DeadReckoning extends Scene {

    DeadReckoning(Session session) : super(session);

@override
void renderContent(Element div) {
    // TODO: implement renderContent
    String content = "<Br><br>While there are no meteors, and no babies, a Reckoning is a Universal Constant, and has just been triggered through Skaia's unknowable will.  It is no longer possible to progress in this game.  ";
    Player player = session.players[0];
    if(player.unconditionallyImmortal) {
        session.stats.won = true;
        content += " Despite bullshit odds, the ${player.htmlTitleWithTip()} has won. What will they do now, with their Unconditional Immortality? <Br><Br> <button id = 'deadButton'> Perhaps they will invade a new session?</button>";
        if(session.session_id == 4037) {
            content += "<div class = 'void'><img src = 'images/misc/shogunReview.png'></void>";
        }
    }else {
        content += " We all fail to be surprised that the ${player.htmlTitle()}  didn't manage to beat such a bullshit game. Guess they are stuck here, huh?";
    }
    appendHtml(div, content);
    ButtonElement button = querySelector("#deadButton");
    if(button != null) {
        button.onClick.listen((e) {
            startNewSession();
        });
    }
    lastRender(div);
    if(!player.unconditionallyImmortal) {
        yellowLawnRing(div);
    }
}

    void yellowLawnRing(Element div) {
        Relationship r = session.players[0].getRelationshipWith((session as DeadSession).metaPlayer);
        if(!session.players[0].dead && (r.value >0 || this.session.janusReward || (session.session_id == 4037))) {
            session.logger.info("AB: Shit. Better tell JR about this Dead Yard.");
            if((session as DeadSession).metaPlayer != session.mutator.metaHandler.jadedResearcher && (session as DeadSession).metaPlayer != session.mutator.metaHandler.authorBot) metaScene(div);
            YellowYard s = new YellowYard(this.session);
            s.timePlayer = session.players[0];
            s.trigger(null);
            s.renderContent(div, true);
        }

    }

    void metaScene(Element div) {
        session.logger.info("AB:  meta player is trying to get a yellow yard going.");
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);
        //CanvasElement canvas, Player player1, Player player2, String chat, String topicImage
        DeadSession d = session as DeadSession;
        String player1Start = d.players[0].chatHandleShort()+ ": ";
        String player2Start = d.metaPlayer.chatHandleShortCheckDup(session.players[0].chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.


        List<PlusMinusConversationalPair> convoSource = new List<PlusMinusConversationalPair>();
        convoSource.add(new PlusMinusConversationalPair(["Okay. I really feel like a dick about this whole 'hassling you' thing.","Hey. Uh. I wanted to apologize about the whole, 'hassling you' thing."], ["Thanks","It's okay. You were just doing your job."],["What the fuck?", "Fuck off."]..addAll(DeadMeta.fuckOff)));
        convoSource.add(new PlusMinusConversationalPair(["Okay, but I'm going to let JR know.","JR will be able to help you.", "I'm going to let AB know to get JR."], ["Who?"],["Well that's just fucking great.", "Who?"]));
        convoSource.add(new PlusMinusConversationalPair(["Bye"], DeadMeta.goodbye,DeadMeta.notSoBad));

        Conversation convo = new Conversation(convoSource);
        String chat = convo.returnStringConversation(d.metaPlayer, d.players[0], player2Start, player1Start,d.players[0].getRelationshipWith(d.metaPlayer).value > 0);
        Drawing.drawChat(canvasDiv, d.metaPlayer, d.players[0], chat, "discuss_sburb.png");
    }

void startNewSession() {
    Element div = SimController.instance.storyElement;
    div.setInnerHtml("");
    Player player = session.players[0];
    String divID = "canvasdeadInvader";
    String ret = "The ${player.htmlTitle()} enters a new session. Huh.  <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
    if(session.session_id == 4037) {
        //SBURBClassManager.LORD.name = "Shogun";
        session.players.first.aspect = Aspects.SAUCE;
        session.players.first.chatHandle = "The Shogun";

        session.players.first.renderSelf("Just Shogun");
        ret = "The ${player.htmlTitle()} enters a new session. There. Are you happy, Shogun? I made your fucking origin story. Can I finally fucking leave this attic?  <canvas id='${divID}' width='${canvasWidth.toString()}' height='${canvasHeight.toString()}'>  </canvas>";
    }
    appendHtml(div, ret);
    CanvasElement canvas = querySelector("#$divID");
    Element buffer = Drawing.getBufferCanvas(canvas.width, canvas.height);
    Drawing.drawSinglePlayer(buffer, player);
    Drawing.copyTmpCanvasToRealCanvas(canvas, buffer);
    querySelector('body').style.backgroundImage = "url(images/Skaia_Clouds.png)";
    SimController.instance.storyElement.style.backgroundColor = "white";
    querySelector("#debug").style.backgroundColor = "white";
    querySelector("#charSheets").style.backgroundColor = "white";
    window.scrollTo(0, 0);

    session.processCombinedSession();
    //TODO have an 'enemy' mechanic for sessions. normal use case is if everybody hates you AND you have killed
    //you get an enemy flag, which makes you strifable (new scene? ). EVERYBODY who is available will drop what they are doing to fight you.
    //dead session players aren't necessarily set to enemy. but i bet quite a few of them will earn it naturally, caliborn style
}

@override
bool trigger(List<Player> playerList) {
    return true;
}

    void lastRender(Element div) {
        div = querySelector("#charSheets");
        //div.setInnerHtml(""); //clear yellow yards and scratches and combos and all TODO figure out why this breaks everything
        if (div == null || div.text.length == 0) return; //don't try to render if there's no where to render to
        for (int i = 0; i < this.session.players.length; i++) {
            CanvasElement canvasDiv = new CanvasElement(width: 800, height: 1000);
            div.append(canvasDiv);
            CanvasElement tmp_canvas = Drawing.getBufferCanvas(canvasDiv.width, canvasDiv.height);
            Drawing.drawCharSheet(tmp_canvas, this.session.players[i]);
            //will be null for new players.
            if (session.players.first.firstStatsCanvas != null) Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, session.players.first.firstStatsCanvas, 0, 0);
            Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, tmp_canvas, 400, 0);
        }
    }

}