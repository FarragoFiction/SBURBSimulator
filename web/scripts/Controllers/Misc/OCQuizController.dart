import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:math' as Math;
import "OCControllerParent.dart";
import "../../Rendering/text/opentype.dart" as OT;
import 'dart:async';



OCGeneratorQuiz ocgen;

Future<Null> main() async {
    loadNavbar();
    await globalInit();
    ButtonElement button = new ButtonElement();
    button.setInnerHtml("Do Quests");
    new StoryJustQuestController(); //so we can do quests and stufff.
    SimController.instance.storyElement.append(button);

    ocgen = new OCGeneratorQuiz(1);
    Session session =ocgen.session;
    button.onClick.listen((e) => ocgen.doQuests(ocgen.players.first));

    loadFuckingEverything(session, "I really should stop doing this",ocgen.start );
    //TODO have a form element for picking session id, which should overright the rand number
    //have a bigger canvas
    //write out the quests straight up.

}

class StoryJustQuestController extends SimController {
    StoryJustQuestController() : super();
}

//when it loads a player, it also uses a set random number.
class OCGeneratorQuiz extends OCGenerator {
    @override
    int canvasHeight = 375;
    TextInputElement seedElement;
    Element storyElementReplacement;
  OCGeneratorQuiz(int numPlayers) : super(numPlayers);


  //no reroll button
  @override
    void start() {
        createDropDowns();
        initPlayers();
    }

  @override
  void redrawPlayers() {
      //make random stable
      session.rand = new Random(int.parse(seedElement.value));
      super.redrawPlayers();
  }

  @override
  void createDropDowns() {
      createSeedInput();
      form.appendHtml("<br><Br>");
      super.createDropDowns();

  }

    void createSeedInput() {
        seedElement = textElementThatRedrawsPlayers(holderElement("Date in Number Form (ex: 20090413). Pick an important date that doesn't change, like your birthday."), new List<SBURBClass>.from(SBURBClassManager.all), "seed");
        seedElement.value = todayToSession();
    }





    @override
    Future<Null> drawText(Player p, CanvasElement canvas) async {
        CanvasRenderingContext2D ctx = canvas.context2D;
        int start = 400;
        int space_between_lines = 25;
        int left_margin = 10;
        int right_margin = 110;
        int line_height = 18;
        int current = 350;

        int line_num = 2;
        ctx.font = "40px land";
        ctx.fillStyle = p.aspect.palette.text.toStyleString();
        await OT.drawText("Fonts/CARIMA.ttf", ctx, "${p.land.name} ", left_margin*2,current, 40, fill: p.aspect.palette.text.toStyleString());
        //ctx.fillText("${p.land.name} ",left_margin*2,current);

        //doQuests(p); too much lag
        if(storyElementReplacement != null)storyElementReplacement.setInnerHtml("");
    }

    void doQuests(Player p) {
      if(storyElementReplacement == null) {
          storyElementReplacement = new DivElement();
          SimController.instance.storyElement.append(storyElementReplacement);
          SimController.instance.storyElement = storyElementReplacement;
      }
      storyElementReplacement.setInnerHtml("<h1>The tale of the ${p.htmlTitleBasic()}</h1>");
        //make sure they are default before questing.
        p.godTier = false;
        p.isDreamSelf = false;
        QuestsAndStuff questsAndStuff = new QuestsAndStuff(session);
        questsAndStuff.landParties.add(new QuestingParty(session, p, null));
        int currentCounter = 0;
        int maxCounter = 31; //don't go forever
        while(!p.land.noMoreQuests && currentCounter < maxCounter) {
            if(p.dead) { //nobody stays dead, this is your self insert fantasy, yo.
                if(p.isDreamSelf) {
                    p.godTier;
                    p.dead = false;
                }else {
                    p.dreamSelf;
                    p.dead = false;
                }
            }
            //p.renderSelf("doQuestsInOCController");
            questsAndStuff.renderContent(session.newScene(null));
            currentCounter ++;
        }
        if(currentCounter >= maxCounter && !p.land.noMoreQuests) {
            storyElementReplacement.appendHtml("<br><br> Let's just assume you don't ever end up beating the game, okay? This is getting ridiculous.");
        }
    }

}




