import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:math' as Math;
import "OCControllerParent.dart";
import "../../Rendering/text/opentype.dart" as OT;
import 'dart:async';


/*
    TODO:
    Have drop down for class, aspect, species, interest cat 1 and interest cat 2.

    in canvas, display 3 sprites (one of each type), title (in aspect color),
    specific interests, chat handle, moon,
    and then land facts
    Name, denizen, consorts, and then sample smells, feels, sounds.
    Then pick three example quest chains that are valid for the player.
 */



OCGenerator ocgen;

main() {
    loadNavbar();
    globalInit();
    new StoryJustQuestController(); //so we can do quests and stufff.
    ocgen = new OCGeneratorQuiz(1);
    curSessionGlobalVar =ocgen.session;
    loadFuckingEverything("I really should stop doing this",ocgen.start );
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
        super.createDropDowns();
        createSeedInput();

  }

    void createSeedInput() {
        seedElement = textElementThatRedrawsPlayers(holderElement("Date in Number Form (ex: 20090413). Pick an important date that doesn't change, like your birthday."), new List<SBURBClass>.from(SBURBClassManager.all), "seed");
    }

    TextInputElement textElementThatRedrawsPlayers<T>(Element div, List<T> list, String name) {
        TextInputElement selectElement = genericTextElement(div, list,  name);
        selectElement.value = todayToSession();
        selectElement.onChange.listen((e) => redrawPlayers());
        return selectElement;
    }


//whoever calls me is responsible for wiring it up
    TextInputElement genericTextElement<T> (Element div, List<T> list, String name)
    {
        TextInputElement selector = new TextInputElement()
            ..name = name
            ..id = name;
        div.append(selector);
        return selector;
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

        doQuests(p);
    }

    void doQuests(Player p) {
      if(storyElementReplacement == null) {
          storyElementReplacement = new DivElement();
          SimController.instance.storyElement.append(storyElementReplacement);
          SimController.instance.storyElement = storyElementReplacement;
      }
      storyElementReplacement.setInnerHtml("");
        //make sure they are default before questing.
        p.godTier = false;
        p.isDreamSelf = false;
        QuestsAndStuff questsAndStuff = new QuestsAndStuff(session);
        questsAndStuff.landParties.add(new QuestingParty(session, p, null));
        int currentCounter = 0;
        int maxCounter = 20; //don't go forever
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
            p.renderSelf();
            questsAndStuff.renderContent(session.newScene(null));
            maxCounter ++;
        }
    }

}




