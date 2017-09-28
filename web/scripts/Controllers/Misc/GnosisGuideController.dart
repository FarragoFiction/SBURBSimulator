import "dart:html";
import "../../SBURBSim.dart";

Quiz quiz;
int guideNum = 1;
void main() {
    loadGuide1();
    querySelector("#avatar").onClick.listen((e) {
        guideNum = 3;
        loadGuide();
    });
}

void loadGuide() {
    window.scrollTo(0, 400);
    if(quiz != null) quiz.clearSelf();
    if(guideNum == 1) loadGuide1();
    if(guideNum == 2) loadGuide2();
    if(guideNum == 3) loadGuide3();
}

void loadGuide1() {
    quiz = new Quiz(querySelector("#guide"),"Gnosis and YOU: An interactive Guide.", ":) :) :)  Let's do this shit, let's make it hapen! And what better way to make shit happen than in a shitty interactive quiz! Truly, it is the most eglitarian of all mediums.<br><br>Together, we shall go on a magical journey of exploration, learning about what Gnosis means in SBURBSim and MAYBE, even a little bit about ourselves.");

    QuizQuestion question1 = new QuizQuestion(1,"How Bullshit is Gnosis?","I wonder what is the refrance???")
        ..addAnswer(new QuizAnswer(1, 1, false, "Extremely", null))
        ..addAnswer(new QuizAnswer(2, 1, false, "Not at all.", null))
        ..addAnswer(new QuizAnswer(3, 1, false, "Wait. Is this a refrance?", "Probably."))
        ..addAnswer(new QuizAnswer(4, 1, false, "Like, should I be recognizing this?", "Maybe not."));

    QuizQuestion question2 = new QuizQuestion(2,"Okay, but seriously. I keep seeing 'gnosis' referred  to all over the place.","No way you literally mean the philosophy thing.")
        ..addAnswer(new QuizAnswer(1, 2, false, "Clearly the answer you seek lies with the one who provides answers.", "Wait. Shit. Wrong riddle."))
        ..addAnswer(new QuizAnswer(2, 2, false, "No.", null))
        ..addAnswer(new QuizAnswer(3, 2, false, "Fuck that noise.", null))
        ..addAnswer(new QuizAnswer(4, 2, false, "Quit with the gigglesnort and make with the motherfucking telos.", "Wait. Is THAT a refrance???"));

    QuizQuestion question3 = new QuizQuestion(3,"... I'm WAITING.","No, legit, I think that last answer was a refrance.")
        ..addAnswer(new QuizAnswer(1, 3, false, "SIGH", null))
        ..addAnswer(new QuizAnswer(2, 3, false, "Fine.", null))
        ..addAnswer(new QuizAnswer(3, 3, false, "Just let me....set this up.", null))
        ..addAnswer(new QuizAnswer(4, 3, true, "Okay. Click this answer.", "Not the other ones tho. What did you think this was actually a QUIZ?"));

    quiz.addQuestion(question1);
    quiz.addQuestion(question2);
    quiz.addQuestion(question3);
    quiz.displaySelf();
}

void loadGuide2() {
    quiz = new Quiz(querySelector("#guide"),"Alright. Real Talk.", "Let's just assume all that bullshit from before drove away MOST people, yeah? I mean, you wander onto that page, see a bunch of giggle snort meta-talk and you don't bother to READ the entire thing to find out that it was the shittiest riddle yet published on this site.  <br><br> 'Click Here to Win', essentially.");

    QuizQuestion question1 = new QuizQuestion(1,"Wait, so you'll ACTUALLY tell me about the Gnosis mechanic?","I'm not sure I trust you.")
        ..addAnswer(new QuizAnswer(1, 1, false, "Would you just let me get my shit ready?", null))
    ..addAnswer(new QuizAnswer(1, 1, false, "Like seriously, stop talking for a bit. It's really confusing to figure out when it's me vs you. ", "Yeah, okay. Fair. "));

    QuizQuestion question2 = new QuizQuestion(2,"Okay, so let me set the stage for you...",null)
        ..addAnswer(new QuizAnswer(1, 2, false, "The Time was just after The Great Refactoring, the biggest, most BORING challenge in the history of the Sim.", null))
        ..addAnswer(new QuizAnswer(2, 2, false, "I was burnt out as fuck, and wanted to do some big dumb update that ALSO very obviously changed the sessions. ", null))
        ..addAnswer(new QuizAnswer(3, 2, false, "And I'd only recently gotten the Wastes into the Sim at all. I KNEW I'd have fun doing their meta bullshit, and that it'd be game breaking enough to satisfy my craving.", null))
        ..addAnswer(new QuizAnswer(4, 2, false, "So I implemented this huge fucking mechanic of SBURBLore and Gnosis and shit to represent 4th wall breaking meta shenanigans.", "Oh so THAT'S why this guide is confusing as fuck."));

    QuizQuestion question3 = new QuizQuestion(3,"Okay. But why call it 'gnosis'? ","Why just not call it 'bullshit' or 'meta' or whatever.")
        ..addAnswer(new QuizAnswer(1, 3, false, "Because Homestuck is filled with Gnostic references.", null))
        ..addAnswer(new QuizAnswer(2, 3, false, "Because gnostic shit is hidden or divine knowledge.", null))
        ..addAnswer(new QuizAnswer(3, 3, false, "Because I had several Observers (not least of which is WooMod, one of my ideasWranglers) talking about gnosticism non-stop.", null))
        ..addAnswer(new QuizAnswer(4, 3, true, "All of the above.","Wait, why is it suddenly like an actual quiz?"));

    quiz.addQuestion(question1);
    quiz.addQuestion(question2);
    quiz.addQuestion(question3);
    quiz.displaySelf();
}

void loadGuide3() {
    quiz = new Quiz(querySelector("#guide"),"Okay, Strap in for an Exposition Dump.", "For reals.");

    QuizQuestion question1 = new QuizQuestion(1,"The Tiers of Gnosis are:",null)
        ..addAnswer(new QuizAnswer(1, 1, false, "Tier 1: Learn the Rules", "Oh. I've seen this. They find FAQs, right?"))
        ..addAnswer(new QuizAnswer(2, 1, false, "Tier 2: Teach the Rules", "I guess this is when they are writing the FAQs?"))
        ..addAnswer(new QuizAnswer(3, 1, false, "Tier 3: Exploit the Rules", "Okay, yeah, I've seen, like, a scene where a light player killed everybody to GodTier them."))
        ..addAnswer(new QuizAnswer(4, 1, false, "Tier 4: Change the Rules", "What even is this?"));

    QuizQuestion question2 = new QuizQuestion(2,"Tier4 is the meat of everything. And it's the rarest in 'canon'. Unless you start mucking around with fanon classpects, you probably aren't going to see this more than a time or two in a hundred sessions.  Wastes, like me, are especially associated with it.<br><br> While the minor effects are too numerous to list, here's some of the major ones:"," Oh. So all this shit is part of your elaborate narcissism role play. Okay.")
        ..addAnswer(new QuizAnswer(1, 2, false, "Blood: Has the great idea to make cracked copies of SBURB to try to give to other friends. ", "...Is that why they were Null players?"))
        ..addAnswer(new QuizAnswer(2, 2, false, "Mind: Steals my goddamned gimmick and lets you use my YellowYard, except WITHOUT the Yard to keep it stable. ", "Wait. What's a YellowYard???"))
        ..addAnswer(new QuizAnswer(3, 2, false, "Rage: Realizes they are in a shitty game. Manifests the creators of said game for vengence. ", "Wackiness ensues if they manage to kill any of us. "))
        ..addAnswer(new QuizAnswer(3, 2, false, "Void: Realizes that you're watching them. Does everything they can to prevent this, even going so far as to lie to AB about session results. ", "Wow. Rude."))
        ..addAnswer(new QuizAnswer(3, 2, false, "Time: Goes back in time, murders their past self and replaces them as Alpha. Requires user input or this would be an infinite loop.  ", "There's no WAY this can go wrong."))
        ..addAnswer(new QuizAnswer(3, 2, false, "Heart: Randomizes everyones classpects and declares all ships canon. ", "100% less crashes from accidentally overriding space/time. "))
        ..addAnswer(new QuizAnswer(3, 2, false, "Breath: Escapes the confines of deterministic narration, does whatever they want. AB hates this. ", "So, functionally, you can't tell it's happening unless you try to view the same session again. Lame."))
        ..addAnswer(new QuizAnswer(3, 2, false, "Light: Becomes THE most important player in all of Homestuck. Er. SBURBSim.", "It's hilarious how wrong this goes. "))
        ..addAnswer(new QuizAnswer(3, 2, false, "Space: Let's you combo into your child session no matter what, and even (theoretically) your own Scratch. Requires user input or this would never end. ", "Wait. What do you mean 'theoretically'?"))
        ..addAnswer(new QuizAnswer(4, 2, false, "Hope: Refuses to believe important facts about the session. The session agrees with their beliefs. ", "I especially love it when they choose to believe that their enemies have dumb titles, like Cad of Piss."))
        ..addAnswer(new QuizAnswer(4, 2, false, "Life: Disables death entirely and makes everyone SO FULL OF LIFE. THEY ARE JUST PEACHY!!!!!!!!!!!", " And then realizes how terrible of an idea this is when it comes time to fight the Black King."))
        ..addAnswer(new QuizAnswer(4, 2, false, "Doom: So. Doom is already about rules, right? They change the very meaning of rules. Good luck making any sense out of this shit. ", " Seriously. Fuck Doom players."));

    QuizQuestion question3 = new QuizQuestion(3,"That sounds...really overwhelming.","You'd have to be insane to do that shit.")
        ..addAnswer(new QuizAnswer(1, 3, false, "Well, the conceit is that at Tier4 the Player hacks the code.", null))
        ..addAnswer(new QuizAnswer(2, 3, false, "And if you know anything about hacking somebody else's code...", null))
        ..addAnswer(new QuizAnswer(3, 3, false, "You'd know it's hard to do right.", null))
        ..addAnswer(new QuizAnswer(4, 3, false, "And even harder to do without unintended consequences.", null));

    QuizQuestion question4 = new QuizQuestion(4,"Okay. Well. I think I'm about out of gigglesnort-free answers. Feel free to check my Tumblr, tho.",null)
        ..addAnswer(new QuizAnswer(1, 4, false, "<a target='_blank' href = 'https://jadedresearcher.tumblr.com/tagged/gnosis'>All gnosis posts</a>", null))
        ..addAnswer(new QuizAnswer(2, 4, false, "<a target='_blank' href = 'https://jadedresearcher.tumblr.com/post/164794031394/gnosis-tier3-is-complete'>In depth on Tier3</a>", null));


    quiz.addQuestion(question1);
    quiz.addQuestion(question2);
    quiz.addQuestion(question3);
    quiz.addQuestion(question4);
    quiz.displaySelf();
}

String wrapInTollTip(String contents) {
    return "<span class = 'tooltip'><span class='tooltiptext'>$contents</span>";
}

class Quiz {

    List<QuizQuestion> _questions = new List<QuizQuestion>();
    int score = 0;
    String title = "";
    String description = "";
    Element parentDiv;

    Quiz( this.parentDiv,this.title, this.description);

    void calculateScore() {
        for(QuizQuestion q in _questions) {
            if(q.choseRight()) score ++;
        }
    }

    void addQuestion(QuizQuestion q) {
        _questions.add(q);
    }

    void displaySelf() {
        String myParts = "<div id = 'quiz'> <div id = 'header'>$title </div> <div id = 'description'>$description</div></div>";

        appendHtml(parentDiv, myParts);
        Element newDiv = querySelector("#quiz");
        for(QuizQuestion q in _questions) {
            q.displaySelf(newDiv);
        }
    }

    void clearSelf() {
        parentDiv.setInnerHtml("");
    }
}

class QuizQuestion
{
    String question;
    int id = 0;
    List<QuizAnswer> _answers = new List<QuizAnswer>();
    QuizAnswer chosen;
    String toolTip;

    QuizQuestion(this.id, this.question, this.toolTip);

    bool choseRight() {
        return chosen.isCorrect;
    }

    void addAnswer(QuizAnswer a) {
        _answers.add(a);
    }

    void displaySelf(Element div) {
        String tmpid = 'question$id';
        String toolWrapper = "<span>";
        if(toolTip != null) toolWrapper = wrapInTollTip(toolTip);
        String myParts = "<div id = '$tmpid' class = 'question'>$toolWrapper $question </span></div>";
        appendHtml(div, myParts);
        Element newDiv = querySelector("#$tmpid");
        for(QuizAnswer a in _answers) {
            a.displaySelf(newDiv);
        }
    }
}


class QuizAnswer {
    String answer;
    int id = 0;
    int parent_id = 0;
    String toolTip;
    bool isCorrect;

    QuizAnswer(this.id, this.parent_id, this.isCorrect, this.answer, this.toolTip);

    void displaySelf(Element div) {
        String toolWrapper = "<span>";
        if(toolTip != null) toolWrapper = wrapInTollTip(toolTip);
        String radioWrapper  = "<input type='radio'>";
        String elementID = "question${parent_id}_answer$id";
        String myParts = "<div id = '$elementID' class = 'answer'>$toolWrapper $radioWrapper $answer </span></div> ";
        appendHtml(div, myParts);

        if(isCorrect) {
            querySelector("#$elementID").onClick.listen((e) {
                guideNum ++;
                loadGuide();
            });
        }
    }
}