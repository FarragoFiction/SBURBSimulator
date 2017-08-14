import '../SBURBSim.dart';
import '../navbar.dart';
import 'dart:html';
import 'dart:async';
import '../v2.0/char_creator_helper.dart';

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
    var tmp = getRandomSeed();
    self.initial_seed = tmp;
  }
  querySelector("#button2").onClick.listen((e) => newPlayer());
  querySelector("#button").onClick.listen((e) => renderURLToSendPlayersIntoSBURB());
  SimController.instance.startSession();
  loadFuckingEverything("I really should stop doing this",renderPlayersForEditing );
}

void newPlayer() {
  self.newPlayer();
}

void renderURLToSendPlayersIntoSBURB() {
  print("clicked render button");
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
    print("getting ready to grab players");
    grabAllPlayerInterests();
    grabCustomChatHandles();
    numURLS ++;
    print("getting ready to generate urls");
    String html = "<Br><br><a href = 'index2.html?seed=$initial_seed&${generateURLParamsForPlayers(curSessionGlobalVar.players,true)}' target='_blank'>Be Responsible For Sending Players into SBURB? (Link $numURLS)</a>";
    appendHtml(querySelector("#character_creator"),html);
  }

  void newPlayer(){
    var p = randomPlayerWithClaspect(curSessionGlobalVar,SBURBClassManager.PAGE, "Void");
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
    player.interest1 = interest1TextDom.value.replaceAll(new RegExp(r"""<(?:.|\n)*?>""", multiLine:true), '');
    player.interest1Category = interestCategory1Dom.value;
    player.interest2 = interest2TextDom.value.replaceAll(new RegExp(r"""<(?:.|,\n)*?>""", multiLine:true), '');
    player.interest2Category = interestCategory2Dom.value;
  }





}