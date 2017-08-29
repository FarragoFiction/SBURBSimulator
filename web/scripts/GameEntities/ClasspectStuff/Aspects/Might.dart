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
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Crash", "MIGHT", "Endure", "Grip", "Endure", "Wave", "Crash", "Fist"]);


  @override
  String denizenSongTitle = "Mantra"; //a sacred utterance, a numinous sound, a syllable, word, or phonemes believed by practitioners to have psychological and spiritual powers.

  @override
  String denizenSongDesc = "A low note is hummed. It is the one Perseverance plays to keep itself going. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


  //Because i dont know what to put here yet.
  @override
  List<String> denizenNames = new List<String>.unmodifiable(<String>['Light', 'Helios', 'Ra', 'Cetus', 'Iris', 'Heimdall', 'Apollo', 'Coeus', 'Hyperion', "Belobog", 'Phoebe', 'Metis', 'Eos', 'Dagr', 'Asura', 'Amaterasu', 'Sol', 'Tyche', 'Odin ', 'Erutuf']);


  @override
  List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
    "winning at increasingly unfair gambling challenges",
    "researching way too much lore and minutia to win at trivia contests",
    "explaining how to play a mini game to particularly stupid consorts until they finally get it"
  ]);
  @override
  List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
    "distracting underlings by with over the top displays of their game powers",
    "teaching the local consorts how to count cards without eating them.",
    "educating themselves on the consequences of betting against the house. As it happens, there are no consequences.",
    "collecting the complete history and mythos of their land into an easy to navigate 1,000 volume encyclopedia."
  ]);

  @override
  List<String> denizenQuests = new List<String>.unmodifiable(<String>[
    "realizing the the entire point of SBURB has been a lie",
    "learning the true purpose of SBURB",
    "realizing just how important frogs and grist and the Ultimate Alchemy truly are"
  ]);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("MANGRIT", 2, true),
    new AssociatedStat("freeWill", -1, true),
    new AssociatedStat("mobility", -1, true),
    new AssociatedStat("sanity", 1, true),
  ]);

  Might(int id) :super(id, "Might", isCanon: false);
}