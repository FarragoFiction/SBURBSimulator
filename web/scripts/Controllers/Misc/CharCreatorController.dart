import 'dart:html';
import '../../SBURBSim.dart';
import '../../navbar.dart';
import '../../v2.0/char_creator_helper.dart';

CharCreatorController self;
void main()
{
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
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
  querySelector("#button").onClick.listen((Event e) => renderURLToSendPlayersIntoSBURB());
  SimController.instance.startSession();
  loadFuckingEverything("I really should stop doing this",renderPlayersForEditing );
}

void newPlayer() {
  self.newPlayer();
}

void renderURLToSendPlayersIntoSBURB() {
  //print("clicked render button");
  self.renderURLToSendPlayersIntoSBURB();
}

void renderPlayersForEditing() {
  self.renderPlayersForEditing();
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
  void easterEggCallBack() {
    initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar);
    charCreatorHelperGlobalVar = new CharacterCreatorHelper(curSessionGlobalVar.players);

  }

  void updateRender(){
    for(num i = 0; i<curSessionGlobalVar.players.length; i++){
      var player = curSessionGlobalVar.players[i];
      charCreatorHelperGlobalVar.redrawSinglePlayer(player);
    }
  }



  void renderPlayersForEditing(){
    charCreatorHelperGlobalVar.drawAllPlayers();
    updateRender();
    (querySelector("#button")as ButtonElement).disabled =false;
  }

  void renderURLToSendPlayersIntoSBURB(){
    //print("getting ready to grab players");
    grabAllPlayerInterests();
    grabCustomChatHandles();
    numURLS ++;
    //print("getting ready to generate urls");
    String html = "<Br><br><a href = 'index2.html?seed=$initial_seed&${generateURLParamsForPlayers(curSessionGlobalVar.players,true)}' target='_blank'>Be Responsible For Sending Players into SBURB? (Link $numURLS)</a>  | <a href = 'rare_session_finder.html?seed=$initial_seed&${generateURLParamsForPlayers(curSessionGlobalVar.players,true)}' target='_blank'>Have AB find different ways a session with these players could go?</a>";
    if(curSessionGlobalVar.players.length == 1)  html = "<Br><br><a href = 'dead_index.html?seed=$initial_seed&${generateURLParamsForPlayers(curSessionGlobalVar.players,true)}' target='_blank'>Be Responsible For Sending Player into a Dead Session? (Link $numURLS)</a> | <a href = 'dead_session_finder.html?seed=$initial_seed&${generateURLParamsForPlayers(curSessionGlobalVar.players,true)}' target='_blank'>Have AB try to find a dead session where this player wins?</a>";

    appendHtml(querySelector("#character_creator"),html);
  }

  void newPlayer(){
    Player p = randomPlayerWithClaspect(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
    curSessionGlobalVar.players.add(p);
    if(curSessionGlobalVar.players.length == 13) window.alert("Like, go ahead and all, but this is your Official Warning that the sim is optimized for no more than 12 player sessions.");
    charCreatorHelperGlobalVar.drawSinglePlayerForHelper(p);

  }

  void grabCustomChatHandleForPlayer(Player player){
    InputElement e = querySelector("#chatHandle${player.id}");
    player.chatHandle = e.value.replaceAll(new RegExp(r"""<(,?:.|\n)*?>""", multiLine:true), '');
  }



//among other things, having chat handles in plain text right in the url lets people know what to expect.
  void grabCustomChatHandles(){
    for(num i = 0; i<curSessionGlobalVar.players.length; i++){
      grabCustomChatHandleForPlayer(curSessionGlobalVar.players[i]);
    }
  }


  void grabAllPlayerInterests(){
    for(num i = 0; i<curSessionGlobalVar.players.length; i++){
      grabPlayerInterests(curSessionGlobalVar.players[i]);
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