import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Might extends Aspect {

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#364447"//
    ..aspect_light = '#28517b'//
    ..aspect_dark = '#143D67'//
    ..shoe_light = '#E7D7A0'//
    ..shoe_dark = '#D6A482'//
    ..cloak_light = '#A9D5DF'//
    ..cloak_mid = '#95c1cb'//
    ..cloak_dark = '#77a3ad'//
    ..shirt_light = '#162E33'//
    ..shirt_dark = '#11292e'//
    ..pants_light = '#021a1f'//
    ..pants_dark = '#021015';//

  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Waves", "Ocean", "Gyms", "Pillars", "Force", "Rocks", "Stability", "Cliffs", "Strength", "Surf"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["STANDALONE STRONGMAN", "EMPOWERING EMPEROR", "MINCEMIGHT"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Might", "Minder", "Mainsail", "Mastiff", "Morpher", "Mortician", ]);


  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Crash", "MIGHT", "Endure", "Grip", "Punch", "Wave", "Fist"]);


  @override
  String denizenSongTitle = "Mantra"; //a sacred utterance, a numinous sound, a syllable, word, or phonemes believed by practitioners to have psychological and spiritual powers.

  @override
  String denizenSongDesc = "A low note is hummed. It is the one Perseverance plays to keep itself going. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


  @override
  List<String> denizenNames = new List<String>.unmodifiable(<String>['Might', 'Grendel', 'Heracles', 'Odysseus', 'Lancelot', 'Arthur', 'Beowulf', 'Achilles', 'Samson', 'Goliath']);//most of these are not gods, but rather strong individuals from legends.

  //todo: make these a bit less repetitive. too many deal with fighting against the odds.
  @override
  List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
    "surfing a tsunami wave that appeared just for the occasion",
    "punching out a horde of underlings, one by one",
    "following through with a plan after the circumstances have foiled it and succeeding anyway"
  ]);
  @override
  List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
    "standing their ground in the face of a difficult foe",
    "performing an unbelievably complex bike stunt",
    "teaching consorts proper weightlifting technique",
    "finally defeating the last of their planet's underlings"
  ]);

  @override
  List<String> denizenQuests = new List<String>.unmodifiable(<String>[
    "training for training's sake",
    "rennovating a consort village to protect it from natural disasters",
    "defeating powerful underlings by refusing to give in to the pain"
  ]);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("MANGRIT", 2, true),
    new AssociatedStat("freeWill", -1, true),
    new AssociatedStat("mobility", -1, true),
    new AssociatedStat("sanity", 1, true),
  ]);

  Might(int id) :super(id, "Might", isCanon: true);

  @override
  String activateCataclysm(Session s, Player p) {
    return s.mutator.hope(s, p);
  }
}