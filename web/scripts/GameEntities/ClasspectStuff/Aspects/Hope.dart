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
    List<String> physicalMcguffins = ["hope","magic feather", "wand", "talisman", "spell book", "stone tablet", "idol", "lottery ticket"];

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
        addTheme(new Theme(<String>["Meditation", "Altars", "Hymns", "Chapels", "Priests", "Angels","Belief","Hope","Faith", "Determination"])
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
                new Quest("The ${Quest.PLAYER1}  is approached by a Crafty ${Quest.CONSORT} who offers them a magical ${Quest.PHYSICALMCGUFFIN}, guaranteed to grant them the power to believe things into existance once per year. The ${Quest.PLAYER1} is shocked to discover it was a ruse, and the Crafty ${Quest.CONSORT} has already escaped to the side with their ill earned boonies. "),
                new Quest("The ${Quest.PLAYER1} is contemplating the magical ${Quest.PHYSICALMCGUFFIN} they wasted their boonies on.  Why would the Crafty ${Quest.CONSORT} tell such specific lies? Maybe...this is some kind of... challenge? The The ${Quest.PLAYER1} spends time imagining what they would try to make if it were true."),
                new Quest("The ${Quest.PLAYER1} finds a grey town of despondant ${Quest.CONSORT}s. Their belief is gone, and they have no hope for the future. After some amount of shenanigans, the ${Quest.PLAYER1} learns that ${Quest.DENIZEN} has been hoarding all the belief and steals it from the ${Quest.CONSORT}s regularly. They have to be stopped!"),
                new DenizenFightQuest("The ${Quest.PLAYER1} approaches ${Quest.DENIZEN}, magical ${Quest.PHYSICALMCGUFFIN} in hand. The ${Quest.DENIZEN} rears up and rumbles 'I DO NOT BELIEVE YOU ARE GOING TO FIGHT ME.'.   The ${Quest.PLAYER1} feels frozen. They cannot take a single step towards ${Quest.DENIZEN}, even as it looms menacingly towards them. What is going on? Suddenly, they feel the ${Quest.PHYSICALMCGUFFIN} in their hand. They wish it were real. They wish so hard because if it were they could just WISH they could fight back. Suddenly, they are able to attack!  The Strife is on!","${Quest.DENIZEN}'s belief was no match for the power of the ${Quest.PHYSICALMCGUFFIN}. They are dead, and hope will be free to flourish among the ${Quest.CONSORT}s once again.","The ${Quest.PHYSICALMCGUFFIN} could not stand up to ${Quest.DENIZEN} after all. The ${Quest.PLAYER1} has been defeated.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Possibilities","Alternatives","Change","Possibility", "Potential", "Hope"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Be the Change You Believe In", [
                new Quest("The ${Quest.PLAYER1} finds a grey town of despondant ${Quest.CONSORT}s. Their daily lives are without meaning, without joy, and will never change. ${Quest.DENIZEN} has stolen all possibilities, all hope away. There is only this.  The ${Quest.PLAYER1} vows to find a way to help. The ${Quest.CONSORT}s fail to be inspired."),
                new Quest("The ${Quest.PLAYER1} learns that part of the reason the ${Quest.CONSORT}s are hopeless is that the local ${Quest.PHYSICALMCGUFFIN} mine has dried up. Without ${Quest.PHYSICALMCGUFFIN} the ${Quest.CONSORT} economy is completley flat. There are no jobs!  The ${Quest.PLAYER1} refuses to give up. They search high and low until they finally find a new source of ${Quest.PHYSICALMCGUFFIN} for the consorts. There is a festival to celebrate. Things are finally looking up!"),
                new Quest("Disaster strikes! The new ${Quest.PHYSICALMCGUFFIN} mine has been utterly destroyed. It is obvious that it is the work of ${Quest.DENIZEN}. They simply refuse to allow hope to survive. The ${Quest.PLAYER1} is going to need to deal with them."),
                new DenizenFightQuest("The ${Quest.CONSORT}s deserve Hope, they deserve a better life. The ${Quest.PLAYER1} is going to show them. But before they can work on fixing their problems, ${Quest.DENIZEN} must be fought. The ${Quest.PLAYER1} dramatically challenges them.","Hope. Survives.","Hope is dead.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}