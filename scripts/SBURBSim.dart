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

// temporary functions to be replaced later!

Session curSessionGlobalVar;

T getRandomElementFromArray<T>(List<T> list) {
	return list[0];
}

int getRandomInt(int lower, int upper) {
	return lower;
}