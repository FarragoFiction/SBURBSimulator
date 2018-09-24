import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import '../../v2.0/char_creator_helper.dart';
import "dart:async";

CharCreatorController self;
//only one session on this page
Session session;
Future<Null> main() async

{
  loadNavbar();
  await globalInit();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error

    return;
  });
  new CharCreatorController();
  self = SimController.instance;
  if(getParameterByName("seed",null) != null){
    self.initial_seed = int.parse(getParameterByName("seed",null));
  }else{
    int tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  querySelector("#button2").onClick.listen((Event e) => newPlayer());
  querySelector("#buttonNotVoid").onClick.listen((Event e) => newPlayerButNotVoid());

  querySelector("#button").onClick.listen((Event e) => renderURLToSendPlayersIntoSBURB());
  session = new Session(SimController.instance.initial_seed);
  checkEasterEgg(session);
  self.easterEggCallBack(session);
  //session.startSession();
  //loadFuckingEverything(session,"I really should stop doing this",renderPlayersForEditing );
  renderPlayersForEditing();
}

void newPlayer() {

  self.newPlayer();
}

void newPlayerButNotVoid() {

  self.newPlayerButNotVoid();
}

void renderURLToSendPlayersIntoSBURB() {
  //
  self.renderURLToSendPlayersIntoSBURB();
}

void renderPlayersForEditing() {
  self.renderPlayersForEditing(session);
}
/*
  doesn't do sim stuff, it's overrides are errors, but need it to do a few other things. whatever.
 */
class CharCreatorController extends SimController {
  CharacterCreatorHelper charCreatorHelperGlobalVar;
  int numURLS = 0;

  CharCreatorController() : super() {
  }

  //don't actually start the session, but get players ready.
  @override
  void easterEggCallBack(Session session) {
    //initializePlayers(session.players, session);
    charCreatorHelperGlobalVar = new CharacterCreatorHelper(session.players);

  }

  void updateRender(){
    for(num i = 0; i<session.players.length; i++){
      var player = session.players[i];
      charCreatorHelperGlobalVar.redrawSinglePlayer(player);
    }
  }



  void renderPlayersForEditing(Session session){
    charCreatorHelperGlobalVar.drawAllPlayers(session);
    updateRender();
    (querySelector("#button")as ButtonElement).disabled =false;
  }

  void renderURLToSendPlayersIntoSBURB(){
    //
    grabAllPlayerInterests();
    grabCustomChatHandles();
    numURLS ++;
    //
    String html = "<Br><br><a href = 'index2.html?seed=$initial_seed&${generateURLParamsForPlayers(session.players,true)}' target='_blank'>Be Responsible For Sending Players into SBURB? (Link $numURLS)</a>  | <a href = 'rare_session_finder.html?seed=$initial_seed&${generateURLParamsForPlayers(session.players,true)}' target='_blank'>Have AB find different ways a session with these players could go?</a>";
    if(session.players.length == 1)  html = "<Br><br><a href = 'dead_index.html?seed=$initial_seed&${generateURLParamsForPlayers(session.players,true)}' target='_blank'>Be Responsible For Sending Player into a Dead Session? (Link $numURLS)</a> | <a href = 'dead_session_finder.html?seed=$initial_seed&${generateURLParamsForPlayers(session.players,true)}' target='_blank'>Have AB try to find a dead session where this player wins?</a>";

    DivElement deprecated = new DivElement();
    querySelector("#character_creator").append(deprecated);


    appendHtml(querySelector("#character_creator"),html);
  }

  void newPlayer(){
    Player p = randomPlayerWithClaspect(session,SBURBClassManager.PAGE, Aspects.VOID);

    session.players.add(p);

    if(session.players.length == 13) window.alert("Like, go ahead and all, but this is your Official Warning that the sim is optimized for no more than 12 player sessions.");
    p.canvas = null;
    p.renderSelf("newPlayer");

    charCreatorHelperGlobalVar.drawSinglePlayerForHelper(session,p);


  }

  void newPlayerButNotVoid(){
    Player p = randomPlayer(session);
    session.players.add(p);
    if(session.players.length == 13) window.alert("Like, go ahead and all, but this is your Official Warning that the sim is optimized for no more than 12 player sessions.");
    p.canvas = null;
    p.renderSelf("newPlayer");
    charCreatorHelperGlobalVar.drawSinglePlayerForHelper(session,p);

  }

  void grabCustomChatHandleForPlayer(Player player){
    InputElement e = querySelector("#chatHandle${player.id}");
    player.chatHandle = e.value.replaceAll(new RegExp(r"""<(,?:.|\n)*?>""", multiLine:true), '');
  }



//among other things, having chat handles in plain text right in the url lets people know what to expect.
  void grabCustomChatHandles(){
    for(num i = 0; i<session.players.length; i++){
      grabCustomChatHandleForPlayer(session.players[i]);
    }
  }


  void grabAllPlayerInterests(){
    for(num i = 0; i<session.players.length; i++){
      grabPlayerInterests(session.players[i]);
    }
  }



  void grabPlayerInterests(Player player){
    SelectElement interestCategory1Dom = querySelector("#interestCategory1${player.id}");
    SelectElement interestCategory2Dom = querySelector("#interestCategory2${player.id}");
    InputElement interest1TextDom = querySelector("#interest1${player.id}");
    InputElement interest2TextDom = querySelector("#interest2${player.id}");
    String i1 = interest1TextDom.value.replaceAll(new RegExp(r"""<(?:.|\n)*?>""", multiLine:true), '');
    String ic1 = interestCategory1Dom.value;
    String i2 = interest2TextDom.value.replaceAll(new RegExp(r"""<(?:.|,\n)*?>""", multiLine:true), '');
    String ic2 = interestCategory2Dom.value;
    //always make a new interest, it'll either add it or not.
    player.interest1 = new Interest(i1, InterestManager.getCategoryFromString(ic1));
    player.interest2 = new Interest(i2, InterestManager.getCategoryFromString(ic2));
  }





}