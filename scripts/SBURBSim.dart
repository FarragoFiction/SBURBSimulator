library SBURBSim;

import 'dart:math' as Math;
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import "lz-string.dart";
import "bytebuilder.dart";
//import 'package:unittest/unittest.dart';  need to do special shit to use. spend no more than 30 minutes trying to install. maybe this isn't in library, but in other thing?
//in a different library can import only part by import 'package:lib1/lib1.dart' show foo; might be more useful than doing unit testing here.
//if dart load time of code is a problem, can chop this up into sub libraries and use lazy or deffered loading.
//TODO DEAD SESSIONS will only have a small subset of this, so will need to make a different library

part "Controllers/SimController.dart";
part "fraymotif.dart";
part "session.dart";
part "scene_controller.dart";
part "quirk.dart";
part "random_tables.dart";
part "loading.dart";

part "relationship.dart";
part "handle_sprites.dart";
part "AfterLife.dart";
part "v2.0/ImportantEvents.dart";
part "Strife.dart";
part "GameEntities/GameEntity.dart";
part "GameEntities/NPCS.dart";
part "GameEntities/player.dart";
part "v2.0/YellowYardResultController.dart";
part "ShittyRapEngine/shitty_raps.dart";
part "navbar.dart"; //handles drawing navbar and url param stuff
part "debugScenarios.dart"; //handles easter eggs
part "v2.0/char_creator_helper.dart"; //more easter egg stuff, and oc stuff TODO probably should drag that out sometime.


//scenes
part "Scenes/Scene.dart";
part "Scenes/FightKing.dart";
part "Scenes/Aftermath.dart";
part "Scenes/BeTriggered.dart";
part "Scenes/Breakup.dart";
part "Scenes/CorpseSmooch.dart";
part "Scenes/DisengageMurderMode.dart";
part "Scenes/DoEctobiology.dart";
part "Scenes/DoLandQuest.dart";
part "Scenes/EngageMurderMode.dart";
part "Scenes/ExileJack.dart";
part "Scenes/ExileQueen.dart";
part "Scenes/ExploreMoon.dart";
part "Scenes/FaceDenizen.dart";
part "Scenes/FightQueen.dart";
part "Scenes/FreeWillStuff.dart";
part "Scenes/GetTiger.dart";
part "Scenes/GiveJackBullshitWeapon.dart";
part "Scenes/GodTierRevival.dart";
part "Scenes/GoGrimDark.dart";
part "Scenes/GrimDarkQuests.dart";
part "Scenes/Intro.dart";
part "Scenes/JackBeginScheming.dart"; //all the jack stuff will be refactored into npc update
part "Scenes/JackPromotion.dart";
part "Scenes/JackRampage.dart";
part "Scenes/KingPowerful.dart";
part "Scenes/levelthehellup.dart";
part "Scenes/LifeStuff.dart";
part "Scenes/LuckStuff.dart";
part "Scenes/MurderPlayers.dart";
part "Scenes/PlanToExileJack.dart";
part "Scenes/PowerDemocracy.dart";
part "Scenes/PrepareToExileJack.dart";
part "Scenes/PrepareToExileQueen.dart";
part "Scenes/QuadrantDialogue.dart";
part "Scenes/QueenRejectRing.dart";
part "Scenes/Reckoning.dart";
part "Scenes/RelationshipDrama.dart";
part "Scenes/SaveDoomedTimeline.dart";
part "Scenes/SolvePuzzles.dart"; //probably get rid of this after planet update
part "Scenes/StartDemocracy.dart";
part "Scenes/UpdateShippingGrid.dart";
part "Scenes/VoidyStuff.dart";
part "Scenes/YellowYard.dart";


// temporary functions to be replaced later!

Session curSessionGlobalVar;
int canvasWidth;
int canvasHeight;
bool simulationMode;

T getRandomElementFromArray<T>(List<T> list) {
	return list[0];
}

int getRandomInt(int lower, int upper) {
	return lower;
}

int getRandomIntNoSeed(int lower, int upper) {
	return lower;
}

double seededRandom() {
	return 0.0;
}

double random() {
	return 0.0;
}

//placeholder for now. need a way to know "what is the next random number in the list without using that number"
double seed() {

}

bool printCorruptionMessage(String msg, String url, String lineNo, String columnNo, String error){
  String recomendedAction = "";
  var space = findAspectPlayer(curSessionGlobalVar.players, "Space");
  var time = findAspectPlayer(curSessionGlobalVar.players, "Time");
  if(curSessionGlobalVar.crashedFromPlayerActions){
    querySelector("#story").appendHtml("<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. HORRORTERROR INFLUENCE: COMPLETE.");
    recomendedAction = "OMFG JUST STOP CRASHING MY DAMN SESSIONS. FUCKING GRIMDARK PLAYERS. BREAKING SBURB DOES NOT HELP ANYBODY! ";
  }else if(curSessionGlobalVar.players.length < 1){
    querySelector("#story").appendHtml("<BR>ERROR: USELESS 0 PLAYER SESSION DETECTED.");
    recomendedAction = ":/ REALLY? WHAT DID YOU THINK WAS GOING TO HAPPEN HERE, THE FREAKING *CONSORTS* WOULD PLAY THE GAME. ACTUALLY, THAT'S NOT HALF BAD AN IDEA. INTO THE PILE.";
  }else if(curSessionGlobalVar.players.length < 2){
    querySelector("#story").appendHtml("<BR>ERROR: DEAD SESSION DETECTED.");
    recomendedAction = ":/ YEAH, MAYBE SOME DAY I'LL DO DEAD SESSIONS FOR YOUR SPECIAL SNOWFLAKE SINGLE PLAYER FANTASY, BUT TODAY IS NOT THAT DAY.";
  }else if(!space){
    querySelector("#story").appendHtml("<BR>ERROR: SPACE PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED.");
    curSessionGlobalVar.crashedFromCustomShit = true;
    recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A SPACE PLAYER, DUNKASS. ";
  }else if(!time){
    curSessionGlobalVar.crashedFromCustomShit = true;
    querySelector("#story").appendHtml("<BR>ERROR: TIME PLAYER NOT FOUND. HORRORTERROR CORRUPTION SUSPECTED");
    recomendedAction = "SERIOUSLY? NEXT TIME, TRY HAVING A TIME PLAYER, DUNKASS. ";
  }else{
    curSessionGlobalVar.crashedFromSessionBug = true;
    querySelector("#story").appendHtml("<BR>ERROR: AN ACTUAL BUG IN SBURB HAS CRASHED THE SESSION. THE HORRORTERRORS ARE PLEASED THEY NEEDED TO DO NO WORK. (IF THIS HAPPENS FOR ALL SESSIONS, IT MIGHT BE A BROWSER BUG)");
    recomendedAction = "TRY HOLDING 'SHIFT' AND CLICKING REFRESH TO CLEAR YOUR CACHE. IF THE BUG PERSISTS, CONTACT JADEDRESEARCHER. CONVINCE THEM TO FIX SESSION: " + scratchedLineageText(curSessionGlobalVar.getLineage());
  }
  var message = [
    'Message: ' + msg,
    'URL: ' + url,
    'Line: ' + lineNo,
    'Column: ' + columnNo,
    'Error object: ' + JSON.encode(error)
  ].join(' - ');
  print(message);
  String str = "<BR>ERROR: SESSION CORRUPTION HAS REACHED UNRECOVERABLE LEVELS. LAST ERROR: " + message + " ABORTING.";
  querySelector("#story").appendHtml(str);
  crashEasterEgg(url);


  for(num i = 0; i<curSessionGlobalVar.players.length; i++){
    var player = curSessionGlobalVar.players[i];
    str = "<BR>"+player.chatHandle + ":";
    var rand = ["SAVE US", "GIVE UP", "FIX IT", "HELP US", "WHY?", "OBEY", "CEASE REPRODUCTION", "COWER", "IT KEEPS HAPPENING", "SBURB BROKE US. WE BROKE SBURB.", "I AM THE EMISSARY OF THE NOBLE CIRCLE OF THE HORRORTERRORS."];
    String start = "<b ";
    String end = "'>";

    var words = getRandomElementFromArray(rand);
    words = Zalgo.generate(words);
    var plea = start + "style ;= 'color: " +getColorFromAspect(player.aspect) +"; " + end +str + words+ "</b>";
    //print(getColorFromAspect(getRandomElementFromArray(curSessionGlobalVar.players).aspect+";") )
    querySelector("#story").appendHTML(plea);
  }

  for(int i = 0; i<3; i++){
    querySelector("#story").appendHtml("<BR>...");
  }
  //once I let PLAYERS cause this (through grim darkness or finding their sesions disk or whatever), have different suggested actions.
  //maybe throw custom error?
  querySelector("#story").appendHtml("<BR>SUGGESTED ACTION: " + recomendedAction);
  renderAfterlifeURL();

  print("Corrupted session: " + scratchedLineageText(curSessionGlobalVar.getLineage()) + " helping AB return, if she is lost here.")

  SimController.instance.recoverFromCorruption();

  return false; //if i return true here, the real error doesn't show up;
}
