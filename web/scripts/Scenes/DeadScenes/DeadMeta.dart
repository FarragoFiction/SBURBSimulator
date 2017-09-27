import "dart:html";
import "../../SBURBSim.dart";

/// // a scene where the chosen meta player fucks with the single player

class DeadMeta extends Scene {
    bool doneOnce = false;
    bool finished = false;
    DeadMeta(Session session) : super(session);
    String player1Start;
    String player2Start;
    //for generic convos.
    List<String> fuckOff;
    List<String> youAsshole;
    List<String> notSoBad;

    @override
    void renderContent(Element div) {
        if(fuckOff == null) {
            fuckOff = <String>["Oh my god just leave me alone!", "Fuck off.", "Just go away!", "I am NOT up for your bullshit right now!", "Oh my fucking god, go AWAY!", "NOT right now.", "No. Just, no. Go away.", "Does it HAVE to be right now?", "No. ", "I can't fucking deal with you right now. Fuck off."];
            youAsshole = <String>["God. I really do hate you.", "You are just a magnificent asshole, you know that?", "You are the very worst asshole in existance.", "I cannot fucking STAND you.", "Amazing. You are Paradox Space's biggest asshole.", "Wow. Rude.", "You fucking asshole.", "Who died and made you king asshole?", "You are the asshole. It is you."];
            notSoBad = <String>["Huh. That...was actually kind of decent of you.", "Wow. Thanks, I guess? ","Huh. Not what I would have expected you to say.",  "Don't think that makes up for what an asshole you usually are.", "Uh. Thanks?", "Oh. Okay. Thanks?", "Huh. I ALMOST forgot you were an asshole there."];
        }
        Player player = session.players[0];

        if(!doneOnce) return intro(div);
        if(!player.landFuture.thirdCompleted) return middle(div);
        if(player.landFuture.thirdCompleted) return end(div);
    }

    void middle(Element div) {
        Player meta = (session as DeadSession).metaPlayer;
        Player player = session.players[0];

        Conversation conversation;

        if(meta == session.mutator.metaHandler.authorBot || meta == session.mutator.metaHandler.authorBotJunior) {
            conversation = session.rand.pickFrom(ABMiddle());
        }else if(meta == session.mutator.metaHandler.jadedResearcher ) {
            conversation = session.rand.pickFrom(JRMiddle());
        }else {
            conversation = session.rand.pickFrom(GenericMiddle());
        }
        conversation.haveConversation(div, meta, player, player2Start, player1Start);
        doneOnce = true;
    }

    //only happens once.
    void end(Element div) {
        finished = true;
        Player meta = (session as DeadSession).metaPlayer;
        Player player = session.players[0];

        Conversation conversation;

        if(meta == session.mutator.metaHandler.authorBot || meta == session.mutator.metaHandler.authorBotJunior) {
            conversation = session.rand.pickFrom(ABEnd());
        }else if(meta == session.mutator.metaHandler.jadedResearcher ) {
            conversation = session.rand.pickFrom(JREnd());
        }else {
            conversation = session.rand.pickFrom(GenericEnd());
        }
        conversation.haveConversation(div, meta, player, player2Start, player1Start);
        doneOnce = true;

    }



    //done exactly once
    void intro(Element div) {
        Player meta = (session as DeadSession).metaPlayer;
        Player player = session.players[0];

        Conversation conversation;

        if(meta == session.mutator.metaHandler.authorBot || meta == session.mutator.metaHandler.authorBotJunior) {
            conversation = session.rand.pickFrom(ABIntro());
        }else if(meta == session.mutator.metaHandler.jadedResearcher ) {
            conversation = session.rand.pickFrom(JRIntro());
        }else {
            conversation = session.rand.pickFrom(GenericIntro());
        }

        conversation.haveConversation(div, meta, player, player2Start, player1Start);
        doneOnce = true;

    }

    List<Conversation> JRIntro() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["You're probably gonna fail, you know."], ["..."],["Whoa, who the fuck are you?", "Fuck off."]))
             ..add(new PlusMinusConversationalPair(["I'm totally serious, yo. Dead sessions are meant to be unwinnable."], ["..."],["Well that's just fucking great. And how the fuck do you know this?", "There's no way you know that."]))
             ..add(new PlusMinusConversationalPair(["Dude, I'm like the fucking Author. Of COURSE I know what I'm talking about."], ["..."],["Well fuck you for me existing.", "Fuck off."]));

        List<PlusMinusConversationalPair> convo2 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Hey, I'm the Author."], ["..."],["What the fuck?", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["Yup, totally made this thing you're in. Weird, huh?"], ["..."],["Well that's just fucking great.", "There's no way."]))
            ..add(new PlusMinusConversationalPair(["Anyways, have fun totally losing this dead session."], ["..."],["Well fuck you for me existing.", "Fuck off."]));


        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        ret.add(new Conversation(convo2));
        ret.addAll(GenericIntro());
        return ret;
    }

    List<Conversation> GenericIntro() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["You're probably gonna fail, you know."], ["..."],["Whoa, who the fuck are you?", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["I'm serious. Dead sessions are meant to be unwinnable."], ["..."],["Well that's just fucking great. And how the fuck do you know this?", "There's no way you know that."]))
            ..add(new PlusMinusConversationalPair(["I helped make this thing,  I know what I'm talking about."], ["..."],["Well fuck you for me existing.", "Fuck off."]));

        List<PlusMinusConversationalPair> convo2 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Hey, I'm one of the creators for this thing."], ["..."],["What the fuck?", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["Yup, totally helped make this thing you're in. Weird, huh?"], ["..."],["Well that's just fucking great.", "There's no way."]))
            ..add(new PlusMinusConversationalPair(["Anyways, have fun totally losing this dead session."], ["..."],["Well fuck you for me existing.", "Fuck off."]));


        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        ret.add(new Conversation(convo2));
        return ret;
    }

    List<Conversation> GenericMiddle() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Haha, wow, this sure looks hard!"], ["..."],fuckOff))
            ..add(new PlusMinusConversationalPair(["I sure am glad I wasn't part of a dead session."], ["..."],youAsshole))
            ..add(new PlusMinusConversationalPair(["Harsh. Fine, I'm out."], ["..."],fuckOff));

        List<PlusMinusConversationalPair> convo2 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Shit, that looks like it sucked. "], ["..."],fuckOff))
            ..add(new PlusMinusConversationalPair(["No seriously, that was absolutely something you didn't deserve. "],["..."], notSoBad))
            ..add(new PlusMinusConversationalPair(["Anyways, have fun totally losing this dead session."], ["..."],fuckOff));


        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        ret.add(new Conversation(convo2));
        return ret;
    }

    List<Conversation> JRMiddle() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["So how are you liking it?"], ["..."],fuckOff))
            ..add(new PlusMinusConversationalPair(["Inorite. Gotta hand it to Hussie to really design a good pointless, bullshit, unwinnable game concept. "], ["..."],["Who?", "What the fuck are you talking about?"]))
            ..add(new PlusMinusConversationalPair(["Whoop! That's like, way more meta levels above you than you need to worry about. Forget I said anything. "], ["..."],["Already have.", "God. I really do hate you."]));

        List<String> terribleIdeas = new List<String>()
            ..add("I'm thinking I figure out how to make everybody replace the word 'dick' with 'bulge'.")
            ..add("I could probably modify SBURB until it just shit out B horror movies forever.")
            ..add("What if, and stay with me here, what if everybody DIDN'T player SBURB, and instead went to high school.  And dated.")
            ..add("What if I filled SBURB with shitty easter eggs. It'd be like fucking Easter all up ins.  Instead of Christmas.")
            ..add("What if I made a robot clone of myself?")
            ..add("What if I came up with a series of riddles, each more shitty and less rewarding than the last?")
            ..add("What if I had a trollsona? I'm thinking...jade blooded researcher? ");

        List<PlusMinusConversationalPair> convo2 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Have I told you about my latest amazing idea? ${session.rand.pickFrom(terribleIdeas)} "], ["..."],["What the fuck?", "Fuck off.", "Oh god, why would you do this?", "What would even be the point of that?", "What the fuck would that acomplish?", "Why. Why is this my life?"]))
            ..add(new PlusMinusConversationalPair(["I have literally never had a better idea in my life."], ["..."],["Well that's just fucking great.", "There's no way.", "You know, I can believe that.", "Oh god."]));


        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        ret.add(new Conversation(convo2));
        ret.addAll(GenericMiddle());
        return ret;
    }

    List<Conversation> ABMiddle() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["There is a ${bullshit}% chance that you will fail should you become distracted. "], ["..."],["And let me guess, you're the perfect distraction.", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["I can hardly be blamed for you failing to be a flawless automaton."], ["..."],fuckOff))
            ..add(new PlusMinusConversationalPair(["I suppose I will let you focus, rad robot that I am."], ["..."],["Jegus fuck.", "..."]));

        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        ret.addAll(GenericMiddle());
        return ret;
    }



    List<Conversation> GenericEnd() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Haha, wow, this sure looks hard!"], ["..."],["Oh my god just leave me alone!", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["I'm totally serious, yo. Dead sessions are meant to be unwinnable."], ["..."],["Well that's just fucking great. And how the fuck do you know this?", "There's no way you know that."]))
            ..add(new PlusMinusConversationalPair(["Dude, I'm like the fucking Author. Of COURSE I know what I'm talking about."], ["..."],["Well fuck you for me existing.", "Fuck off."]));

        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        return ret;
    }

    List<Conversation> JREnd() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Oh shit, you ACTUALLY fucking did it!"], ["..."],["No thanks to you.", "No shit, sherlock."]))
            ..add(new PlusMinusConversationalPair(["Well, congratulations are in order, I guess? Good job. "], ["..."],["Yeah, fuck you.", "I don't need your fucking pity."]))
             ..add(new PlusMinusConversationalPair(["Fuck man, talk about a sore winner. Be seeing you. "], ["..."],["Yeah, fuck you too.", "Wait, what?"]));

        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        return ret;
    }

    List<Conversation> ABEnd() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["Holy shit, way to beat the odds there."], ["..."],["Let me guess, you thought only a robot could do it?", "And I'm not even a robot. Probably."]))
            ..add(new PlusMinusConversationalPair(["Welp, have fun in the afterparty. "], ["..."],["The what?", "Wait, what?"]));

        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        return ret;
    }

    double get bullshit {
        return 90 + (session.rand.nextDouble()*10);
    }

    List<Conversation> ABIntro() {
        // c= new PlusMinusConversationalPair(["Hey!"], ["Hey!", "Oh cool, I was just thinking of you!"],["What's up?", "Hey"]);
        List<PlusMinusConversationalPair> convo1 = new List<PlusMinusConversationalPair>()
            ..add(new PlusMinusConversationalPair(["There is a ${bullshit}% chance you are going to fail, you know."], ["..."],["Whoa, who the fuck are you?", "Fuck off."]))
            ..add(new PlusMinusConversationalPair(["Dead sessions are designed to be totally unwinnable. I know this because I am the AuthorBot. "], ["..."],["Well that's just fucking great. And how the fuck do you know this?", "There's no way you know that."]))
            ..add(new PlusMinusConversationalPair(["Well shit, I'm a flawless mechanical automaton. I know what I'm talking about. But sure, go ahead and fail to trust your technological betters.  See how that works out for you."], ["..."],["I don't have to fucking believe anything a robot says.", "Fuck off."]));

        List<Conversation> ret = new List<Conversation>();
        ret.add(new Conversation(convo1));
        return ret;
    }



    @override
    bool trigger(List<Player> playerList) {
        if(player1Start == null) player1Start = session.players[0].chatHandleShort()+ ": ";
        if(player2Start == null) player2Start = (session as DeadSession).metaPlayer.chatHandleShortCheckDup(session.players[0].chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
        return !finished && !session.players[0].dead && session.rand.nextDouble()>.9;
    }
}


