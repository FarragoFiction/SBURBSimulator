import '../../SBURBSim.dart';
import '../../navbar.dart';
import '../../v2.0/char_creator_helper.dart';
import 'dart:html';
import 'dart:async';

CharViewerController self;

void main()
{
  loadNavbar();
  window.onError.listen((Event event){
    ErrorEvent e = event as ErrorEvent;
    //String msg, String url, lineNo, columnNo, error
    printCorruptionMessage(e);//(e.message, e.path.toString(), e.lineno.toString(), e.colno.toString(), e.toString());
    return;
  });
  querySelector("#draw12Button").onClick.listen((e) => draw12());
  new CharViewerController();
  self = SimController.instance;
  globalInit();
  self.renderHeader();
  var params = window.location.href.substring(window.location.href.indexOf("?")+1);
  if (params == window.location.href) params = "";
  appendHtml(querySelector("#character_creator"),"<a target='_blank' href = 'index2.html?selfInsertOC=true&" + params + "'>Send Random Fan OCs From This Category Into SBURB?</a> &nbsp &nbsp &nbsp<a target='_blank' href = 'rare_session_finder.html?selfInsertOC=true&" + params + "'>AB Report For Fan OCs From This Category</a><Br><Br><Br>");
  //TODO what does passing true here mean again, really should make it callbacks eventually.
  loadFuckingEverything("I really should stop doing this",renderPlayersForEditing );
}

void draw12() {
  self.draw12();
}

void renderPlayersForEditing() {
  self.renderPlayersForEditing();
}
/*
  doesn't do sim stuff, it's overrides are errors, but need it to do a few other things. whatever.
 */
class CharViewerController extends SimController {
  CharacterEasterEggEngine easterEggEngine;

  List<Player> players;

  CharacterCreatorHelper charCreatorHelper; //TODO, oh shit, this wasn't done yet. get it working, too. set to right type

  CharViewerController() : super();

  void renderHeader(){
    String header = "";
    if(getParameterByName("reddit","")  == "true") header += " reddit";
    if(getParameterByName("tumblr","")  == "true") header += " tumblr";
    if(getParameterByName("discord","")  == "true") header += " discord";
    if(getParameterByName("creditsBuckaroos","")  == "true") header += " creditsBuckaroos";
    if(getParameterByName("ideasWranglers","")  == "true") header += " ideasWranglers";
    if(getParameterByName("patrons","")  == "true") header += " patrons";
    if(getParameterByName("patrons2","")  == "true") header += " patrons2";
    if(getParameterByName("patrons3","")  == "true") header += " patrons3";
    if(getParameterByName("canon","")  == "true") header += " canon";
    if(getParameterByName("otherFandoms","")  == "true") header += " otherFandoms";
    if(getParameterByName("creators","")  == "true") header += " creators";
    if(getParameterByName("bards","")  == "true") header += " bards<span class='void'>Not gonna lie, gonna add a secret boss for each one of these assholes</span>";
    header += "";
    if(header!= "" ) querySelector("#header").setInnerHtml(header);

  }



  void renderPlayersForEditing(){
    easterEggEngine = new CharacterEasterEggEngine();
    easterEggEngine.loadArraysFromFile(callBackForLoadOCsFromFile,null,null);
  }



//won'te be needed for AB or for simulation because instead of it being like reddit=true, SESSIONS with fan OCS will be generated right here.;
//range slider for "number of players", and will auto select that number of players from list (repeats if necessary.)
//check box for "guarantee space/time".
//just generates a URL for the session. that you click right on this page. so only this page needs to load the ocs from file.
  void callBackForLoadOCsFromFile(){
    players = easterEggEngine.processEasterEggsViewer(new Random());
    charCreatorHelper = new CharacterCreatorHelper(players);
    charCreatorHelper.draw12PlayerSummaries();
  }




  void draw12(){
    charCreatorHelper.draw12PlayerSummaries();
  }


}