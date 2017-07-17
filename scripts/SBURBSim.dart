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
