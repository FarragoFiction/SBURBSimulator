import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Domestic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.SANITY, 1.0, true), new AssociatedStat(Stats.RELATIONSHIPS, 1.0, true)]);
    @override
    List<String> handles1 = <String>["home", "motherly", "patient", "missing", "knitting", "rising", "stylish", "trendy", "homey", "baking", "recipe", "meddling", "mature"];

    @override
    List<String> handles2 = <String>["Baker", "Darner", "Mender", "Mentor", "Launderer", "Vegetarian", "Tailor", "Teacher", "Hestia", "Helper", "Decorator", "Sewer"];

    @override
    List<String> levels =<String>["BATTERBRAT", "GRITTY GUARDIAN"];

    @override
    List<String> interestStrings =<String>["Sewing", "Fashion", "Meditation", "Babies", "Peace", "Knitting", "Cooking", "Baking", "Gardening", "Crochet", "Scrapbooking"];



    Domestic() :super(8, "Domestic", "domestic", "boring");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Fashion","Catwalks","Clothes", "Dresses", "Suits", "Tailors"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Design the Dress", [
                new Quest("The ${Quest.PLAYER1} is visited by a Beautiful ${Quest.CONSORT} who wishes to commision a dress. Only the finest ${Quest.PHYSICALMCGUFFIN}will do for material The Beautiful ${Quest.CONSORT} refuses to take 'no' for an answer. "),
                new Quest(" The ${Quest.PLAYER1} had almost given up, but they finally find the perfect ${Quest.PHYSICALMCGUFFIN} to decorate the dress. Now they just need to sew it on."),
                new Quest("The ${Quest.PLAYER1} presents the  ${Quest.PHYSICALMCGUFFIN} dress to the Beautiful ${Quest.CONSORT}, who ${Quest.CONSORTSOUND}s with delight. They will be SURE to tell all their friends where they got such a wonderful dress.  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Baking","Cakes","Cupcakes", "Cookies", "Birthdays", "Sweets"])
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Bake the Cake", [
                new Quest("The ${Quest.PLAYER1} enters a competition to bake the single best cake that Paradox Space has ever seen. "),
                new Quest("The ${Quest.PLAYER1} is trying out recipe after recipe, but nothing really feels right until they try adding a pinch of ${Quest.PHYSICALMCGUFFIN}'. It is incredible how much of a difference it makes! "),
                new Quest("It's finally time for competition! The Distinguised ${Quest.CONSORT} takes a slow, thoughtful bite of the ${Quest.PLAYER1}'s cake. There is a pause, and then the Distinguished ${Quest.CONSORT} begins ${Quest.CONSORTSOUND}ing up a storm!  The ${Quest.PHYSICALMCGUFFIN} did the trick, ${Quest.PLAYER1}'s cake is immediately declared the winner! "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Yarn","Needles","Purls", "Looms", "Weaving", "Sewing", "Stitching", "Spiders"])
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.WAY_HIGH)
            ..addFeature(new PreDenizenQuestChain("Weave the Cloth", [
                new Quest("The ${Quest.PLAYER1} finds a loom, and a Wizened ${Quest.CONSORT} who spins them a tale of a magical thread that, when woven into a shawl, confers great mystical power.  The ${Quest.PLAYER1} is enchanted by the thought of this. "),
                new Quest("The ${Quest.PLAYER1} searches the land high and low. What thread could possibly be worthy of such a legend? Finally, deep in a dungeon, they find a single skein of ${Quest.PHYSICALMCGUFFIN} colored thread. Is this finally it?  "),
                new Quest("The ${Quest.PLAYER1}, slowly, methodically weaves a shawl from the skein of ${Quest.PHYSICALMCGUFFIN} colored thread. When it is over, the Wizened ${Quest.CONSORT} lets out a strained ${Quest.CONSORTSOUND} and declares it to be the shawl of Legend indeed."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}