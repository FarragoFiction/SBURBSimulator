import '../Misc/CurrentUpdateProgress.dart';
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
    TodoHandler todoHandler = new TodoHandler(TodoHandler.SESSIONCUSTOMIZERTODO, container);
    sessionForm = new SessionForm(session,container);
    makeStartButton();

}


void makeStartButton() {
    ButtonElement startButton = new ButtonElement()..text = "Start Session";
    container.append(startButton);
    startButton.onClick.listen((MouseEvent e){
        session.logger.info("DEBUG CUSTOM SESSION: starting session from button press");
        container.appendHtml("Starting a session with ${session.bigBadsReadOnly.length} possible big bads, like ${session.bigBadsReadOnly}");
        session.startSession();
    });
}


class CustomStoryController extends SimController {
    CustomStoryController() : super();
}