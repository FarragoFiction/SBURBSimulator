import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Sand extends Aspect {

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#b88654"
    ..aspect_light = '#783e05'
    ..aspect_dark = '#4a0f00'
    ..shoe_light = '#0b6c6e'
    ..shoe_dark = '#005d5e'
    ..cloak_light = '#f5b06c'
    ..cloak_mid = '#e6a05e'
    ..cloak_dark = '#b87232'
    ..shirt_light = '#ffd966'
    ..shirt_dark = '#d1ab3b'
    ..pants_light = '#7d5e00'
    ..pants_dark = '#6e4f00';



  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Lies", "Beach", "Shore", "Secrets", "Pirates", "Suspicion", "Corruption", "[REDACTED]", "Cake"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["MR SANDMAN", "CASTLE COORDINATOR", "POKER FACADE"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Strategist", "Slider", "Sculpter", "Scamp", "Sleazebag"]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["FALSE", "Wrong", "Sand", "Distraction", "Ruse", "Crumble", "abscond", "beach", "grain", "[Data Expunged]"]);


  //@override
  //String denizenSongTitle = "Silence";

  @override
  String denizenSongDesc = " BLUH BLUH, ask Cactus to write this. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


  /*@override
  List<String> denizenNames = new List<String>.unmodifiable(<String>['Void', 'Selene', 'Erebus', 'Nix', 'Artemis', 'Kuk', 'Kaos', 'Hypnos', 'Tartarus', 'Hœnir', 'Skoll', "Czernobog", 'Vermina', 'Vidar', 'Asteria', 'Nocturne', 'Tsukuyomi', 'Leviathan', 'Hecate', 'Harpocrates', 'Diova']);

  @override
  List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
    "destroying and/or censoring embarrassing consort records",
    "definitely doing quests, just...not where we can see them",
    "playing a hilariously fun boxing minigame"
  ]);
  @override
  List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
    "Wait, yes! The Void player is… nope. They’re gone.",
    "doing something about their land, but it’s difficult to make out.",
    "fixing temples from the ravages of… something? It’s a best guess. Those temples were totally ravaged a minute ago though.",
    "somehow just doing normal quests with no void interference whatsoever. Huh"
  ]);

  @override
  List<String> denizenQuests = new List<String>.unmodifiable(<String>[
    "???",
    "[redacted]",
    "[void players, am I right?]"
  ]);
*/
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("RELATIONSHIPS", 3, true), //Never truthful. but nobody knows that, do they?
    new AssociatedStat("sanity", -2, true) //no, you are not sane for cheating your way out of everything.

  ]);

  Sand(int id) :super(id, "Sand", isCanon: false);

}