import "dart:async";
import "dart:html";
import '../../SBURBSim.dart';
import '../../navbar.dart';
import "SessionForm.dart";

Element container;
Session session;
SessionForm sessionForm;

Future<Null> main() async {
    Loader.init();
    await Loader.loadManifest();
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
    checkEasterEgg(session);
    container = querySelector("#story");

    todo("special sessions work (and don't get replaced)");
    todo("can customize denizen");
    todo("CarapaceSection lets you remove the selected item from the sylladex");
    todo("new way to serialize a player/entity that doesn't care about brevity (can replace any player with this new datastring)");
    todo("Can serialize a session");
    todo("can serialize a carapace");
    todo("can serialize a sylladex (just item numbers in allItems list, assume is stable)");
    todo("can save a session to a .txt file");
    todo("can load a session from a .txt file");
    todo("if only one player, use dead session controller");
    todo("make sure it works for special sessions like 13 or 413!");
    todo("Each Player has a QuirkSection that lets  you modify quirks.");
    todo("PlayerSection lets you pick the name of their sprite, and the name of the fraymotif that sprite has");
    todo("players/carapaces get one custom fraymotif name (all custom fraymotifs just do everything at once)");
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
        session.startSession();
    });
}


class CustomStoryController extends SimController {
    CustomStoryController() : super();
}