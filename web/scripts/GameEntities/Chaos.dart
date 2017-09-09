import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Chaos extends Aspect {

  @override
  AspectPalette palette = new AspectPalette()
    ..accent = "#003301"
    ..aspect_light = '#0F0F1F'
    ..aspect_dark = '#010102'
    ..shoe_light = '#E8C16E'
    ..shoe_dark = '#C7A141'
    ..cloak_light = '#1E212E'
    ..cloak_mid = '#141624'
    ..cloak_dark = '#0B0D1B'
    ..shirt_light = '#204021'
    ..shirt_dark = '#11201F'
    ..pants_light = '#192C26'
    ..pants_dark = '#121F11';

  @override
  List<String> landNames = new List<String>.unmodifiable(<String>["Everything", "Candy", "Insanity", "Murder", "Discord", "What...", "Chaos", "Mixing", "Clones", "Angels", "Fanfiction", "Teriyaki", "Drugs", "Landtitle"]);

  @override
  List<String> levels = new List<String>.unmodifiable(<String>["INSANITY INCARNATE", "MENTALY UNSTABLE", "TOTAL BADASS"]);

  @override
  List<String> handles = new List<String>.unmodifiable(<String>["Cockblocker", "Candycane", "Cola", "Couch", "Carepackage", "Carebear", "Cake", "Cellphone"]);

  @override
  List<String> fraymotifNames = new List<String>.unmodifiable(<String>["mangrit", "strength", "power", "might", "fire", "pure energy", "STRENGTH", "electricity", "will", "open doors", "possibility", "quantum physics", "lightning", "sparks", "chaos", "broken gears", "dice", "luck", "light", "playing cards", "suns", "absolute bullshit", "card suits", "hope"]);

  @override
  String denizenSongTitle = "Canon"; //a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops);

  @override
  String denizenSongDesc = "A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter.";


  @override
  List<String> denizenNames = new List<String>.unmodifiable(<String>['Chaos', 'Insignies', 'Mars', 'Crononburg', 'Alien', 'Hypotonous', 'Vulture', 'PercyJackson', 'Professional', 'God', 'AshKetchem', 'Stink', 'Kurloz', 'Vector385', 'Gigantic', 'Emo', 'Propostorous Being of Another World', 'Electric', 'Mortal']);

  @override
  List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
    "pulling pranks on everybody they pass by... this probably isn't important",
    "Bullying a child into joining a made-up mob",
    "Discussing plans to take over the empire... with themselves",
  ]);
  @override
  List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
    "apoligizing to everybody they pranked earlier on... this still isn't important",
    "ACTUALLY setting up a mob... and then bullying a child into joining it",
    "getting really annoyed with the voices in their head",
    "doing some really rad shit yo",
  ]);

  @override
  List<String> denizenQuests = new List<String>.unmodifiable(<String>[
    "sitting idle, waiting for their denizen to come to them",
    "being all chaotic and shit, exploring broken ruins yo",
    "alchemizing a ton of drugs, newspaper clippings, drugs, weapons, drugs..."
  ]);

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
    new AssociatedStat("MANGRIT", 2, true),
    new AssociatedStat("freeWill", -2, true),
    new AssociatedStat("minLuck", 1, true),
    new AssociatedStat("maxLuck", 1, true),
    new AssociatedStat("sburbLore", 0.2, false)
  ]);

  Chaos(int id) :super(id, "Chaos", isCanon: true);

  @override
  String activateCataclysm(Session s, Player p) {
    return s.mutator.chaos(s, p);
  }
}