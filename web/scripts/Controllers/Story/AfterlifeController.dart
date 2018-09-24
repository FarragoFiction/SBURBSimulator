import '../../SBURBSim.dart';
import '../../navbar.dart';
import '../../v2.0/char_creator_helper.dart';
import 'dart:html';
import 'dart:async';

AfterlifeController self;
Session session;

Future<Null> main() async {
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(SimController.instance.currentSessionForErrors,e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });

  new AfterlifeController();
  await globalInit(); // initialise classes and aspects if necessary
  session = Session.defaultSession;
  self = SimController.instance;
  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    int tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  self.loadPlayers(session);
  globalCallBack = self.renderGhosts;
  ;
  load(session, session.players, [], "ghostNewBullshitReallyIShouldJustBeUsingCallbackAlone");


}

/*
  doesn't do sim stuff, it's overrides are errors, but need it to do a few other things. whatever.
 */
class AfterlifeController extends SimController {

  List<Player> players;


  AfterlifeController() : super();


  void loadPlayers(Session session){
    session.players = getReplayers(session);
    for(num i = 0; i<session.players.length; i++){
      session.players[i].ghost = true; //not storing that as a bool. 'cause fuck you,thats why'
    }
  }

  void renderSingleGhost(Player ghost, int i) {
    //;
    Element div = querySelector("#afterlifeViewer");
    String html = "<div class = 'eulogy'><div class = 'eulogy_text'>The " + ghost.htmlTitle() + " died " + ghost.causeOfDeath + ".";
    if(ghost.causeOfDrain != null && ghost.causeOfDrain.isNotEmpty){
      html += " They were drained to the point of uselessness by the" + ghost.causeOfDrain + ".  They will recover eventually. ";
    }
    html +="</div>";
    String divID = "Eulogy$i";
    html += "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas></div>";
    appendHtml(div, html);
    CanvasElement canvas = querySelector("#canvas"+ divID);

    var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
    Drawing.drawSprite(pSpriteBuffer,ghost);

    Drawing.copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0);
  }

  void renderGhosts() {
    for(int i =0; i<session.players.length; i++) {
      Player p = session.players[i];
      renderSingleGhost(p, i);
    }
  }



}