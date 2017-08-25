import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Sweets extends Aspect {

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#55E18C"
    ..aspect_light = '#FF0000'
    ..aspect_dark = '#B20000'
    ..shoe_light = '#FF71F6'
    ..shoe_dark = '#D25BC6'
    ..cloak_light = '#990410'
    ..cloak_mid = '#790B02'
    ..cloak_dark = '#390000'
    ..shirt_light = '#56F500'
    ..shirt_dark = '#49D300'
    ..pants_light = '#17AC01'
    ..pants_dark = '#056A00';

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Smasher","Sweety","Sexlord"]);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("freeWill", 11, true),
    new AssociatedStat("alchemy", 11, true),
    new AssociatedStat("minLuck", 11, true),
    new AssociatedStat("mobility", 11, true),
    new AssociatedStat("RELATIONSHIPS", 11, true),
    new AssociatedStat("MANGRIT", 11, true),
    new AssociatedStat("hp", 11, true),
    new AssociatedStat("sburbLore", -0.5, false)
  ]);

  Sweets(int id) :super(id, "Sweets", isCanon: false);
}