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
part "Scenes/ForeshadowYellowYard.dart";
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