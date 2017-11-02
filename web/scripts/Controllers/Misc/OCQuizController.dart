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
    @override
    int canvasHeight = 1000;
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
        int right_margin = 110;
        int line_height = 18;
        int current = 350;

        int line_num = 2;
        ctx.font = "40px land";
        ctx.fillStyle = p.aspect.palette.text.toStyleString();
        ctx.fillText("${p.land.name} ",left_margin*2,current);
        ctx.font = "18px land";
        ctx.fillStyle = "#000000";


        ctx.font = "18px Times New Roman";

        line_num++;
        left_margin = 35; //indenting for land shit.
        String text = doQuests(p);
        ctx.fillText("Quests: ", left_margin, current + line_height * line_num);

        Drawing.wrap_text(ctx, text,right_margin, current + line_height * line_num, line_height, 600, "left");
        line_num++;


    }

    String doQuests(Player p) {
        String text = "";
        for(int i = 0; i< 3; i++) {
            p.land.initQuest([p]);
            text += p.land.getLandText(p,"",false); //no tooltip
        }

        /*
        TODO figure out how to remove html and convert to things like like breaks.
        maybe html to svg to canvas:  https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Drawing_DOM_objects_into_a_canvas
        get all tet to be part of text (i.e. loop until finished).

        PROBLEMS: quests happen directly to a div (since might have images).  want to ignore reward images and shit.

        want to print quest text out. and also ignore the inside of strifes.
         */
        return text;
    }

}




