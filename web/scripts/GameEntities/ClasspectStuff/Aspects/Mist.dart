import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Mist extends Aspect{
  @override
  AspectPalette palette = new AspectPalette()
    ..accent = '#A4C1F4'
    ..aspect_light = '#A4C1F4'
    ..aspect_dark = '#95AFDD'
    ..shoe_light = '#FFFFA5'
    ..shoe_dark = '#BEBE9E'
    ..cloak_light = '#A4C1F4'
    ..cloak_mid = '#95AFDD'
    ..cloak_dark = '#88A0CC'
    ..shirt_light = '#D9D2E9'
    ..shirt_dark = '#BBB5CA'
    ..pants_light = '#CCC5DB'
    ..pants_dark = '#A49FB1';

  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Mist", "Steam", "Substance", "Vapor", "Fog", "Clouds", "Rivers", "Humidity"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["HAZE HASTENER", "MISTER MASTER", "MANY-BODY"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Moper", "Martyr", "Manager", "Morning", "Matter" ]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Everything", "Encompass", "Halation", "Mist", "Universal", "Steamy", "Most"]);

  @override
  String denizenSongTitle = "Ensemble"; //a musical piece involving several instruments

  @override
  String denizenSongDesc = "A harmonized chord sounds. It is the one Everybody knows. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

  //todo: actually add denizens for mist players

  static List<String> _randomStats = Player.playerStats.toList()
    ..remove("power")
    ..add("MANGRIT");

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("mobility", 2.0, true),
    new AssociatedStat("MANGRIT", -1.0, true),
  ]);


  Mist(int id) :super(id, "Mist", isCanon: true);

  @override
  String activateCataclysm(Session s, Player p) {
    return s.mutator.voidStuff(s, p);
  }
}
