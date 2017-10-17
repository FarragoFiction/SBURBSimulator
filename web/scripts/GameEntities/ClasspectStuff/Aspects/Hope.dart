import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

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
    List<String> symbolicMcguffins = ["hope","beliefs", "imagination", "dreams", "waves"];

    @override
    List<String> physicalMcguffins = ["hope","magic feather", "wand", "talisman", "spell book", "stone tablets", "idol", "lottery ticket"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Hope', 'Isis', 'Marduk', 'Fenrir', 'Apollo', 'Sekhmet', 'Votan', 'Wadjet', 'Baldur', 'Zanthar', 'Raphael', 'Metatron', 'Jerahmeel', 'Gabriel', 'Michael', 'Cassiel', 'Gavreel', 'Aariel', 'Uriel', 'Barachiel ', 'Jegudiel', 'Samael', 'Taylus', 'Tzeench']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SANITY, 2.0, true),
        new AssociatedStat(Stats.MAX_LUCK, 1.0, true),
        new AssociatedStatRandom(Stats.pickable, -2.0, true)
    ]);

    Hope(int id) :super(id, "Hope", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.hope(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Meditation", "Altars", "Hymns", "Chapels", "Priests", "Angels"])
            ..addFeature(FeatureFactory.CHANTINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Learn to Believe", [
                new Quest("The ${Quest.PLAYER1} is just minding their own business when they see a wizened ${Quest.CONSORT} walk sedately off a cliff. Before they can even panic, though, the wizened ${Quest.CONSORT} is revealed to be walking sedately in mid air! How did he do that? The ${Quest.PLAYER1} calls out to the  wizened ${Quest.CONSORT}. When pressed, she reveals that the key is to BELIEVE. Never waver, never lose faith. Just believe. The ${Quest.PLAYER1} begs to be taught the secrets of such STRONG belief, and the wizened ${Quest.CONSORT} agrees to mentor them."),
                new Quest("The ${Quest.PLAYER1} isn't doing so well. They meditate, they do everything they can to believe, but still they fall when they step off a small ledge.   The wizened ${Quest.CONSORT} admonishes them with a gentle ${Quest.CONSORTSOUND}.  Unless they can believe 6 impossible things before breakfast, they will never make progress. "),
                new Quest("A village of ${Quest.CONSORT}s has been destroyed and looted. ${Quest.DENIZEN} is quietly blamed by the survivors. Their lair is unreachable by normal means, being across a vast gulf. Any bridges or ropes that cross the chasm are immediately destroyed by underlings.  The wizened ${Quest.CONSORT} calls over the ${Quest.PLAYER1} and hands them a ${Quest.PHYSICALMCGUFFIN}. They didn't want to give the ${Quest.PLAYER1} this ${Quest.PHYSICALMCGUFFIN}, for it would make belief far too easy and it is more rewarding to do things the right way. But the need is too dire. The wizened ${Quest.CONSORT} asks that the ${Quest.PLAYER1} defeat ${Quest.DENIZEN} and retrieve their belongings."),
                new DenizenFightQuest("${Quest.PHYSICALMCGUFFIN} in hand, the ${Quest.PLAYER1} marches forward across the empty air of the chasm. They challenge ${Quest.DENIZEN} to combat.","The ${Quest.PLAYER1} is victorious. They bring all the stolen valuables to the ${Quest.CONSORT} village and thank the wizened ${Quest.CONSORT} for the ${Quest.PHYSICALMCGUFFIN}. In a dramatic reveal, the wizened ${Quest.CONSORT} reveals that the magic of belief was in the ${Quest.PLAYER1} all along. The ${Quest.PHYSICALMCGUFFIN} was just a trinket they bought online. The ${Quest.PLAYER1} learns to have faith in themselves. ","The ${Quest.PLAYER1} fails to believe hard enough. They are defeated.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Lies", "Bullshit", "Deceit","Slander", "Fakes", "Con Artists", "Ruses"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CHAMELEONCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Believe the Lies", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Belief","Hope","Faith", "Determination","Possibility", "Potential"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Don't Give Up", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}