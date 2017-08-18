import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Hope extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ffcc66"
        ..aspect_light = '#FDF9EC'
        ..aspect_dark = '#D6C794'
        ..shoe_light = '#164524'
        ..shoe_dark = '#06280C'
        ..cloak_light = '#FFC331'
        ..cloak_mid = '#F7BB2C'
        ..cloak_dark = '#DBA523'
        ..shirt_light = '#FFE094'
        ..shirt_dark = '#E8C15E'
        ..pants_light = '#F6C54A'
        ..pants_dark = '#EDAF0C';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Angels", "Hope", "Belief", "Faith", "Determination", "Possibility", "Hymns", "Heroes", "Chapels", "Lies", "Bullshit"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["GADABOUT PIPSQUEAK", "BELIVER EXTRAORDINAIRE", "DOCTOR FEELGOOD"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Honcho", "Humorist", "Horse", "Haberdasher", "Hooligan"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Hope", "Fake", "Belief", "Bullshit", "Determination", "Burn", "Stubborn", "Religion", "Will", "Hero", "Undying", "Dream", "Sepulchritude", "Prophet", "Apocryphal"]);


    @override
    String denizenSongTitle = "Etude"; //a musical exercise designed to improve the performer;

    @override
    String denizenSongDesc = " A resounding hootenanny begins to play. It is the one Irony performs to remember the past. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Hope', 'Isis', 'Marduk', 'Fenrir', 'Apollo', 'Sekhmet', 'Votan', 'Wadjet', 'Baldur', 'Zanthar', 'Raphael', 'Metatron', 'Jerahmeel', 'Gabriel', 'Michael', 'Cassiel', 'Gavreel', 'Aariel', 'Uriel', 'Barachiel ', 'Jegudiel', 'Samael', 'Taylus', 'Tzeench']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "performing bullshit acts of faith, like walking across invisible bridges",
        "becoming the savior of the local consorts, through fulfillment of various oddly specific prophecies",
        "brainstorming a variety of ways the local consorts can solve their challenges"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "leading a huge army of zealous consorts into battle",
        "learning ancient chants and forgotten mythos of their lands strange almost-religion",
        "willing enemies out of existence with but a thought",
        "winning an argument with gravity"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "realizing that the consorts real problem is their lack of morale",
        "inspiring impressionable consorts who then go on to inspire others ",
        "defeating the underling that was causing the local consorts to not believe in themselves"
    ]);

    static List<String> _randomStats = Player.playerStats.toList()
        ..remove("power")
        ..add("MANGRIT");

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("sanity", 2, true),
        new AssociatedStat("maxLuck", 1, true),
        new AssociatedStatRandom(_randomStats, -2, true)
    ]);

    Hope(int id) :super(id, "Hope", isCanon: true);
}