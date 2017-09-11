import "dart:html";
import "../SBURBSim.dart";
void main() {
    loadGuide();
}

void loadGuide() {
    Quiz quiz = new Quiz(querySelector("#guide"),"Gnosis and YOU: An interactive Guide.", ":) :) :) I am so glad you asked hypothetical Observer! Let's do this shit, let's make it hapen! And what better way to make shit happen than in a shitty interactive quiz! Truly, it is the most eglitarian of all mediums.<br><br>Together, we shall go on a magical journey of exploration, learning about what Gnosis means in SBURBSim and MAYBE, even a little bit about ourselves.");

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
        String myParts = "<div id = 'question${parent_id}_answer$id' class = 'answer'>$toolWrapper $radioWrapper $answer </span></div> ";
        appendHtml(div, myParts);
    }
}