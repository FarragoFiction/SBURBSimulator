import "dart:async";
import "dart:html";
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "SessionForm.dart";

Element container;
Session session;
SessionForm sessionForm;

Future<Null> main() async {
    await globalInit();
    window.onError.listen((Event event){
        ErrorEvent e = event as ErrorEvent;
        //String msg, String url, lineNo, columnNo, error
        printCorruptionMessage(SimController.instance.currentSessionForErrors,e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
        return;
    });
    loadNavbar();
    new CustomStoryController(); //will set this as SimController's instance variable.
    if(getParameterByName("seed",null) != null){
        SimController.instance.initial_seed = int.parse(getParameterByName("seed",null));
    }else{
        var tmp = getRandomSeed();
        SimController.instance.initial_seed = tmp;
    }
    session = new Session(SimController.instance.initial_seed);
    session.reinit("initialization from customizer");
    session.getPlayersReady();
    container = querySelector("#story");

    todo("CarapaceSection lets you add the selected item to either the carapaces sylladex or their specibus.");
    todo("make sure crowns exist in lists");
    todo("CarapaceSection lets you remove the selected item from teh sylladex");
    todo("Can save session to a .txt file");
    todo("can load a session from a .txt file");
    todo("SessionForm has a PlayerSection (new class/file");
    todo("PlayerSection lists all players (image next to each)");
    todo("make sure it works for special sessions like 13 or 413!");
    todo("PlayerSection has a text area box for putting a dataUrl to alter players.");
    todo("PlayerSection lets you add the selected item to either sylladex or specibus.");
    todo("Each Player has a QuirkSection that lets  you modify quirks.");
    todo("PlayerSection lets you pick the name of their sprite, and the name of the fraymotif that sprite has");
    todo("PlayerSection lets you pick the name of their Land");
    todo("PlayerSection lets you pick the name of their Consorts");
    todo("PlayerSection lets you pick the sound their consorts make");
    todo("PlayerSection lets you pick initial relationships. (drop down of types, drop down of targets)");
    todo("Can give a session a Name.");
    todo("Can choose 13 sessions to save to localStorage (if they aren't too big? Only have 2.2 mb)");
    todo("can view list of your saved sessions, load them into this page, etc");
    todo("pretty everything up??? ask PL for help???");
    sessionForm = new SessionForm(session,container);
    makeStartButton();

}

void todo(String text) {
    LIElement newTodo = new LIElement()..setInnerHtml("<b>TODO:</b> $text");
    container.append(newTodo);
}

void makeStartButton() {
    ButtonElement startButton = new ButtonElement()..text = "Start Session";
    container.append(startButton);
    startButton.onClick.listen((MouseEvent e){
        session.logger.info("DEBUG CUSTOM SESSION: starting session from button press");
        container.appendHtml("Starting a session with ${session.bigBads.length} big bads.");
        session.startSession(true); //don't reinit
    });
}


class CustomStoryController extends SimController {
    CustomStoryController() : super();
}