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
                new Quest(" The ${Quest.PLAYER1} has almost fallen asleep during their latest ${Quest.PHYSICALMCGUFFIN} Museum stakeout, when the thief arrives! It looks to be a ${Quest.DENIZEN} minion! After a brief scuffle, it is defeated. They drop various pieces of art along with the standard amount of grist. The museum is saved! "),
                new Quest("The ${Quest.PLAYER1} attends a fancy gala in their honor, hosted in the ${Quest.PHYSICALMCGUFFIN} Museum itself.  ${Quest.CONSORT}s quietly ${Quest.CONSORTSOUND} and exchange pleasantries. It sure is nice to be recognized by high society!  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Baking","Cakes","Cupcakes", "Cookies", "Birthdays", "Sweets"])
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Bake the Cake", [
                new Quest("The ${Quest.PLAYER1} finds a troupe of dejected looking ${Quest.CONSORT}s. Apparently they want to put on a famous ${Quest.CONSORT} play called 'The ${Quest.MCGUFFIN} ${Quest.PHYSICALMCGUFFIN}', but have no one to play the titular role!  Does the ${Quest.PLAYER1} have what it takes to bring the iconic role to life? "),
                new Quest("The ${Quest.PLAYER1} is practicing their lines for the upcoming performance of 'The ${Quest.MCGUFFIN.toUpperCase()} ${Quest.PHYSICALMCGUFFIN.toUpperCase()}'. Man, who would have thought a ${Quest.PHYSICALMCGUFFIN} would have so many different emotions! "),
                new Quest("It's finally time for performance of the 'The ${Quest.MCGUFFIN.toUpperCase()} ${Quest.PHYSICALMCGUFFIN.toUpperCase()}'. The audience is moved to tears and ${Quest.CONSORTSOUND}ing at the ${Quest.PLAYER1} stirring performance as the ${Quest.PHYSICALMCGUFFIN}. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Yarn","Needles","Purls", "Looms", "Weaving", "Sewing", "Stitching"])
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Weave the Cloth", [
                new Quest("The ${Quest.PLAYER1}  is cordially invited to the dinner party of Miss ${Quest.CONSORTSOUND}ingworth, ${Quest.CONSORT} heiress to the ${Quest.PHYSICALMCGUFFIN} fortune. "),
                new Quest("The ${Quest.PLAYER1} is coached on etiquette by  Miss ${Quest.CONSORTSOUND}ingworth's butler. It would not do to embarass the young Miss.  "),
                new Quest("It is finally time for Miss ${Quest.CONSORTSOUND}ingworth's party. Anyone who is anyone is attending, and it is clear that the ${Quest.PLAYER1} is the guest of honor. They successfully charm all of the ${Quest.CONSORT}s with a captivating story of dining customs from their home world. "),
            ], new FraymotifReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)
            ,  Theme.LOW);
    }

}