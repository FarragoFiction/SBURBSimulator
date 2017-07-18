library SBURBSim;

import 'dart:math' as Math;
import 'dart:html';
import 'dart:typed_data';
import 'dart:collection';
import 'dart:convert';

part "player.dart";
part "fraymotif.dart";
part "session.dart";
part "scene_controller.dart";
part "quirk.dart";
part "random_tables.dart";
part "gameEntity.dart";
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
