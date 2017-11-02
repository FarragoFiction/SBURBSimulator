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
}




