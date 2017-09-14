import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Flow extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#ee0000"//
    ..aspect_light = '#ff0000'//
    ..aspect_dark = '#d10000'//
    ..shoe_light = '#00ffff'//
    ..shoe_dark = '#00d1d1'//
    ..cloak_light = '#e68f39'//
    ..cloak_mid = '#d67e2b'//
    ..cloak_dark = '#c46b1d'//
    ..shirt_light = '#e65c00'//
    ..shirt_dark = '#b82e00'//
    ..pants_light = '#ffd966'//
    ..pants_dark = '#d1ab3b';//

  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Fire", "Track", "Mercury", "Heat", "Burns", "Mixtapes", "Spaghetti"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["BURN WARDEN", "FIRESTARTER", "RAP GOD"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Flamer", "Florist", "Friar", "Foodie"]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Nightcore", "Flow", "Sick", "Fire", "Fast", "Sonic", "burning", "speed",]);

  @override
  String denizenSongTitle = "Mixtape "; //a compilation of sick beats.

  @override
  String denizenSongDesc = " An ill beat is laid down. It's the one that is dropped when the Pimp is in the crib. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

//todo make these fellas do stuff.

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("mobility", 2, true),
    new AssociatedStat("MANGRIT", 1, true),
    new AssociatedStat("RELATIONSHIPS", -2, true)
  ]);

  Flow(int id) :super(id, "Flow", isCanon: true);
}