import '../../SBURBSim.dart';
import '../../navbar.dart';
import 'dart:html';
import 'dart:math' as Math;
import "OCControllerParent.dart";
import "dart:async";

/*
    TODO:
    Have drop down for class, aspect, species, interest cat 1 and interest cat 2.

    in canvas, display 3 sprites (one of each type), title (in aspect color),
    specific interests, chat handle, moon,
    and then land facts
    Name, denizen, consorts, and then sample smells, feels, sounds.
    Then pick three example quest chains that are valid for the player.
 */



OCGenerator ocgen;
main() {
    loadNavbar();

    start();
}

Future<Null> start() async {
    await globalInit();
    //4 is number of players, session id is left to be todays date
    ocgen = new OCGenerator(4);
    Session session =ocgen.session;
    loadFuckingEverything(session,"I really should stop doing this",ocgen.start );
}
