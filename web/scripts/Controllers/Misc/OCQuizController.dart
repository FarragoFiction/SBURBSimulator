import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:math' as Math;
import "OCControllerParent.dart";

/*
    TODO:
    Have drop down for class, aspect, species, interest cat 1 and interest cat 2.

    in canvas, display 3 sprites (one of each type), title (in aspect color),
    specific interests, chat handle, moon,
    and then land facts
    Name, denizen, consorts, and then sample smells, feels, sounds.
    Then pick three example quest chains that are valid for the player.
 */



Session curSessionGlobalVar;
OCGenerator ocgen;

main() {
    loadNavbar();

    globalInit();
    ocgen = new OCGeneratorQuiz(1);
    curSessionGlobalVar =ocgen.session;
    loadFuckingEverything("I really should stop doing this",ocgen.start );
    //TODO have a form element for picking session id, which should overright the rand number
    //have a bigger canvas
    //write out the quests straight up.

}

//when it loads a player, it also uses a set random number.
class OCGeneratorQuiz extends OCGenerator {
    TextInputElement seedElement;
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
    void drawText(Player p, CanvasElement canvas) {
        CanvasRenderingContext2D ctx = canvas.context2D;
        int start = 400;
        int space_between_lines = 25;
        int left_margin = 10;
        int right_margin = 210;
        int line_height = 18;
        int current = 350;

        int line_num = 2;
        ctx.font = "40px land";
        ctx.fillStyle = p.aspect.palette.text.toStyleString();
        ctx.fillText(p.titleBasic(),left_margin*2,current);
        ctx.font = "18px land";
        ctx.fillStyle = "#000000";


        ctx.fillText("Land: ", left_margin, current + line_height * line_num);
        ctx.fillText(p.land.name, right_margin, current + line_height * line_num);
        ctx.font = "18px Times New Roman";

        line_num++;
        left_margin = 35; //indenting for land shit.
        p.land.initQuest([p]);
        ctx.fillText("Quests: ", left_margin, current + line_height * line_num);
        ctx.fillText(sanitizeString(p.land.getLandText(p,"")), right_margin, current + line_height * line_num);
        line_num++;


    }

}




