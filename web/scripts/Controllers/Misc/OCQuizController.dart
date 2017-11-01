import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:math' as Math;
import "OCControllerParent.dart";

/*
    TODO:
    Have drop down for class, aspect, species, interest cat 1 and interest cat 2.

    in canvas, display 3 sprites (one of each type), title (in aspect color),
    specific interests, chat handle, moon,
    and then land facts
    Name, denizen, consorts, and then sample smells, feels, sounds.
    Then pick three example quest chains that are valid for the player.
 */



Session curSessionGlobalVar;
OCGenerator ocgen;
main() {
    loadNavbar();

    globalInit();
    ocgen = new OCGenerator(1);
    curSessionGlobalVar =ocgen.session;
    loadFuckingEverything("I really should stop doing this",ocgen.start );

}
