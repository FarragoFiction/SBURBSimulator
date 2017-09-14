import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rain extends Aspect {
  @override
  AspectPalette palette = new AspectPalette()
    ..accent = '#00FFFF'
    ..aspect_light = '#00ffff'//
    ..aspect_dark = '#009090'
    ..shoe_light = '#FEFEFE'
    ..shoe_dark = '#707070'
    ..cloak_light = '#0000FF'
    ..cloak_mid = '#0000b3'
    ..cloak_dark = '#000080'
    ..shirt_light = '#9900ff'
    ..shirt_dark = '#5c0099'
    ..pants_light = '#00FF00'
    ..pants_dark = '#008000';


  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Neon", "Headaches", "Puddles", "Drip", "Mess", "Ice cream", "Sweets", "Boredom"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["PUDDLE PUMMELLER", "FLOOD FINISHER", "RAINBRO"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Rainer", "Retriever", "Rower", "Redux", "Rapport"]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Chaos", "disorder", "puddle", "Rain", "error", "color", "Swirl", "LOL",]);

  /*@override
  String denizenSongTitle = ;
*/
  @override
  String denizenSongDesc = "BLUH BLUH, Ask Cactus to write this. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


  @override
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("RELATIONSHIPS", -2, true),
        new AssociatedStat("sanity", -1, true),
        new AssociatedStat("maxLuck", 3, true)
    ]);

  Rain(int id) :super(id, "Rain", isCanon: true);

  @override
  String activateCataclysm(Session s, Player p) {
    return s.mutator.blood(s, p);
  }
}