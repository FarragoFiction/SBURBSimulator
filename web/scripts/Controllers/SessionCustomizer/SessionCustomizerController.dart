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
        // Math.seed = getParameterByName("seed");  //TODO replace this somehow
        SimController.instance.initial_seed = int.parse(getParameterByName("seed",null));
    }else{
        var tmp = getRandomSeed();
        // Math.seed = tmp; //TOdo do something else here but rand is inside of session......
        SimController.instance.initial_seed = tmp;
    }
    session = new Session(SimController.instance.initial_seed);
    container = querySelector("#story");
    todo("SessionForm is a new file/class");
    todo("before that button is pressed, display a SessionForm");
    todo("SessionForm has a text area input for a BigBad data string. (hide this when it goes out for real)");
    todo("SessionForm has a ItemSection (new class/file)");
    todo("ItemSection lists all Items, and lets you make a new Item with any existing trait");
    todo("ItemSection lets you select an item.");
    todo("SessionForm has a CarapaceSection (new class/file)");
    todo("CarapaceSection lists all carapaces (image next to each)");
    todo("CarapaceSection lets you activate/deactive each carapace");
    todo("CarapaceSection lets you add the selected item to either the carapaces sylladex or their specibus.");
    todo("Can save session to a .txt file");
    todo("can load a session from a .txt file");
    todo("SessionForm has a PlayerSection (new class/file");
    todo("PlayerSection lists all players (image next to each)");
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
        container.appendHtml("Starting a session with ${session.bigBads.length} big bads.");
        session.startSession();
    });
}


class CustomStoryController extends SimController {
    CustomStoryController() : super();
}