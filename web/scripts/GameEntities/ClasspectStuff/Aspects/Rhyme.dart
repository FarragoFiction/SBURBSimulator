import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rhyme extends Aspect{

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#10dede"//
    ..aspect_light = '#00ffff'//
    ..aspect_dark = '#00d1d1'//
    ..shoe_light = '#ff0000'//
    ..shoe_dark = '#d10000'//
    ..cloak_light = '#4985e6'//
    ..cloak_mid = '#3a76d6'//
    ..cloak_dark = '#2d6ac4'//
    ..shirt_light = '#331c73'//
    ..shirt_dark = '#050045'//
    ..pants_light = '#8d7cc2'//
    ..pants_dark = '#7c6db3';//


  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Gel", "Ice", "Tape", "Poetry", "Caucophony"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["LIL LYRICIST", "ICE CREAMER", "COOLER THAN BEING COOL"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Rhymer", "Rapper", "Rental", "Redux", "Rave", "Reason"]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Vaporwave", "Chill", "Ice", "Rhyme", "Slow"]);

  @override
  String denizenSongTitle = "Rap";

  @override
  String denizenSongDesc = "BLUH BLUH, Ask Cactus to write this. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


  Rhyme(int id) :super(id, "Rhyme", isCanon: false);
}