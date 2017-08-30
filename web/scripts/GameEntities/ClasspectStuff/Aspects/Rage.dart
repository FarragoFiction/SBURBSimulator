import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rage extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9900cc"
        ..aspect_light = '#974AA7'
        ..aspect_dark = '#6B347D'
        ..shoe_light = '#3D190A'
        ..shoe_dark = '#2C1207'
        ..cloak_light = '#7C3FBA'
        ..cloak_mid = '#6D34A6'
        ..cloak_dark = '#592D86'
        ..shirt_light = '#381B76'
        ..shirt_dark = '#1E0C47'
        ..pants_light = '#281D36'
        ..pants_dark = '#1D1526';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Mirth", "Whimsy", "Madness", "Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams", "Denial"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MOPPET OF MADNESS", "FLEDGLING HATTER", "RAGAMUFFIN REVELER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Raconteur", "Reveler", "Reader", "Reporter", "Racketeer"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo", "Horrorcore", "Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"]);


    @override
    String denizenSongTitle = " Aria"; // a musical piece full of emotion;

    @override
    String denizenSongDesc = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Rage', 'Ares', 'Dyonisus', 'Bacchus', 'Abbadon', 'Mammon', 'Mania', 'Asmodeus', 'Belphegor', 'Set', 'Apophis', 'Nemesis', 'Menoetius', 'Shogorath', 'Loki', 'Alastor', 'Mol Bal', 'Deimos', 'Achos', 'Pallas', 'Deimos', 'Ania', 'Lupe', 'Lyssa', 'Ytilibatsni', 'Discord']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "fighting hordes upon hordes of enemies in increasingly unfair odds until defeating them all in a berserk rage", //You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.
        "figuring out increasingly illogical puzzles until lateral thinking becomes second nature",
        "dealing with the most annoying dungeon challenges ever, each more irritating and aneurysm inducing than the last"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "ripping underlings apart with loud, violent screams",
        "throwing the mother of all temper tantrums",
        "fighting through millions of enemies in search of the fabled ‘chill-pill’",
        "ripping a mini boss a literal new one. Ouch"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        //http://rumkin.com/tools/cipher/atbash.php (thinking of lOSS here)
        //"~~~You can't believe how easy it is. You just have to go... a little crazy. And then, suddenly, it all makes sense, and everything you do turns to gold.~~~",
        //"~~~ The denizen, Bacchus, thinks that grammar is important. That rules are important. That so much is important. You'll show him. ~~~",
        //"~~~ Nothing makes sense here anymore. Just the way you like it. The consorts are whipped into a frothing fury. Bacchus is awake.  ~~~",

        "~~~You can't believe how vzhb it is. You just have to go... a little xizab. Zmw gsvm, suddenly, rg all makes sense, zmw everything blf wl gfimh gl gold. ~~~",
        "~~~ Gsv denizen, XXXXXX, gsrmph gszg grammar rh important. Gszg rules ziv important. Gszg hl nfxs rh rnkligzmg. You'll show him.  ~~~",
        "~~~ Mlgsrmt nzpvh hvmhv sviv zmbnliv. Qfhg gsv dzb blf orpv rg. Gsv xlmhligh ziv dsrkkvw rmgl z uilgsrmt ufib. XXXXXX rh zdzpv.   ~~~"
    ]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("MANGRIT", 2, true),
        new AssociatedStat("mobility", 1, true),
        new AssociatedStat("sanity", -1, true),
        new AssociatedStat("RELATIONSHIPS", -1, true),
        new AssociatedStat("sburbLore", 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Rage(int id) :super(id, "Rage", isCanon: true);
}