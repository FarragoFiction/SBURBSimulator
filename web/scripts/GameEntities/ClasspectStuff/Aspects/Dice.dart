import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Dice extends Aspect {

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#1E1903"
    ..aspect_light = '#0F0F0B'
    ..aspect_dark = '#0A0A07'
    ..shoe_light = '#26261B'
    ..shoe_dark = '#191912'
    ..cloak_light = '#593D35'
    ..cloak_mid = '#4C342D'
    ..cloak_dark = '#33231E'
    ..shirt_light = '#E5E5DA'
    ..shirt_dark = '#BFBFB5'
    ..pants_light = '#D8B6AD'
    ..pants_dark = '#B2968E';

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Dangerous","Dazzler","Dickface"]);

  static List<String> _randomStats = Player.playerStats.toList()
    ..remove("power")
    ..remove("maxLuck")
    ..remove("minLuck")
    ..add("MANGRIT");

  @override
  List<String> denizenNames = new List<String>.unmodifiable(<String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("maxLuck", 5, true),
    new AssociatedStat("minLuck", -5, true),
    new AssociatedStatRandom(_randomStats, 1, true)
  ]);

  Dice(int id) :super(id, "Dice", isCanon: false);
}