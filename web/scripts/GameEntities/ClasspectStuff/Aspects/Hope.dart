import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Hope extends Aspect {

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Honcho","Humorist","Horse","Haberdasher","Hooligan"]);



    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>  ["Hope","Fake", "Belief", "Bullshit", "Determination", "Burn", "Stubborn", "Religion", "Will", "Hero", "Undying", "Dream", "Sepulchritude", "Prophet", "Apocryphal"]);


    @override
    String denizenSongTitle = "Etude" ;//a musical exercise designed to improve the performer;

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

    Hope(int id):super(id, "Hope", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        List<String> allStats = player.allStats()..remove("power")..add("MANGRIT");

        player.associatedStats.add(new AssociatedStat("sanity", 2, true));
        player.associatedStats.add(new AssociatedStat("maxLuck", 1, true));
        player.associatedStats.add(new AssociatedStat(player.rand.pickFrom(allStats), -2, true));
    }
}