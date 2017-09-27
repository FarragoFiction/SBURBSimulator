import "dart:html";
import "../../SBURBSim.dart";

/// // a scene where the chosen meta player fucks with the single player

class DeadMeta extends Scene {
    bool doneOnce = false;
    DeadMeta(Session session) : super(session);
    String player1Start;
    String player2Start;

    @override
    void renderContent(Element div) {
        if(!doneOnce) return intro(div);

        //TODO do middle convos any time before winning.  do ending convos any time after winning (and set timeTillReckoning to 0);
        /**
         * not a pesterlog, literally part of the narration just like hussie and caliborn.
         *
         * use quirks and color though, go wild. and chat handle
         * JR: alsjdf
         * BL :;lakjsfd
         */
    }

    //done exactly once
    void intro(div) {
        Conversation convos  = session.rand.pickFrom(JRIntro());
        Player meta = (session as DeadSession).metaPlayer;
        Player player = session.players[0];
        String ret = "<br>";
        for(PlusMinusConversationalPair convo in convos.pairs) {
            String metaLine = convo.getOpeningLine(meta, player2Start);
            String playerLine = convo.getP2ResponseBasedOnBool(player, player1Start, player
                .getRelationshipWith(meta)
                .value > 0);
            ret += "<br><font color = '${meta.getChatFontColor()}'>$metaLine</font><br><font color = '${player.getChatFontColor()}'>$playerLine</font><br>";
        }
        appendHtml(div, ret);
        doneOnce = true;

    }

    List<Conversation> JRIntro() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["You probably gonna fail, you know."], ["..."],["Whoa, who the fuck are you?", "Fuck off."]))
             ..add(new PlusMinusConversationalPair(["I'm totally serious, yo. Dead sessions are meant to be unwinnable."], ["..."],["Well that's just fucking great. And how the fuck do you know this?", "There's no way you know that."]))
             ..add(new PlusMinusConversationalPair(["Dude, I'm like the fucking Author. Of COURSE I know what I'm talking about."], ["..."],["Well fuck you for me existing.", "Fuck off."]));


        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        return ret;
    }



    @override
    bool trigger(List<Player> playerList) {
        if(player1Start == null) player1Start = session.players[0].chatHandleShort()+ ": ";
        if(player2Start == null) player2Start = (session as DeadSession).metaPlayer.chatHandleShortCheckDup(session.players[0].chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
        return !session.players[0].dead && session.rand.nextBool();
    }
}


