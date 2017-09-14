import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Law extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#c42eff"//
    ..aspect_light = 'a703ff'//
    ..aspect_dark = '#9800f0'//
    ..shoe_light = '#fcf9bd'//
    ..shoe_dark = '#e0d29e'//
    ..cloak_light = '#9900ff'//
    ..cloak_mid = '#8800f0'//
    ..cloak_dark = '#7800e0'//
    ..shirt_light = '#b3a7d4'//
    ..shirt_dark = '#a599c4'//
    ..pants_light = '#a64e78'//
    ..pants_dark = '#963f66';//

  @override
  List<String> landNames = new List<String>.unmodifiable(<String>[]);

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
  Law(int id) :super(id, "Law", isCanon: true);
}