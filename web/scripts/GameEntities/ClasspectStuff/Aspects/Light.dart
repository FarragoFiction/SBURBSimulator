import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Light extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff9933"
        ..aspect_light = '#FEFD49'
        ..aspect_dark = '#FEC910'
        ..shoe_light = '#10E0FF'
        ..shoe_dark = '#00A4BB'
        ..cloak_light = '#FA4900'
        ..cloak_mid = '#E94200'
        ..cloak_dark = '#C33700'
        ..shirt_light = '#FF8800'
        ..shirt_dark = '#D66E04'
        ..pants_light = '#E76700'
        ..pants_dark = '#CA5B00';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Treasure", "Light", "Knowledge", "Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHOWOFF SQUIRT", "JUNGLEGYM SWASHBUCKLER", "SUPERSTITIOUS SCURRYWART"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Laborer", "Launderer", "Layabout", "Legend", "Lawyer", "Lifeguard"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lucky", "LIGHT", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"]);


    @override
    String denizenSongTitle = "Opera"; //lol, cuz light players never shut up;

    @override
    String denizenSongDesc = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


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

    Light(int id) :super(id, "Light", isCanon: true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("maxLuck", 2, true));
        player.associatedStats.add(new AssociatedStat("freeWill", 1, true));
        player.associatedStats.add(new AssociatedStat("sanity", -1, true));
        player.associatedStats.add(new AssociatedStat("hp", -1, true));
        player.associatedStats.add(new AssociatedStat("sburbLore", 0.25, false));//yes, technically it's from an aspect, but it's not NORMAL.
    }
}