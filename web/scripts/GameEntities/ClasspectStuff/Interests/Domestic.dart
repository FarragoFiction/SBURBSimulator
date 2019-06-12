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
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Trendy Fabric",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.CLOTH],shogunDesc: "Weird Tasting Candy Paper"))
            ..add(new Item("Necklace",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.GOLDEN, ItemTraitFactory.CHAIN],shogunDesc: "Nasty Candy Necklace"))
            ..add(new Item("Sewing Needle",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.NEEDLE, ItemTraitFactory.POINTY],shogunDesc: "Cloth Stabbing Knife"))
            ..add(new Item("Broom",<ItemTrait>[ItemTraitFactory.BROOM, ItemTraitFactory.WOOD,ItemTraitFactory.BLUNT,ItemTraitFactory.BROOM,],shogunDesc: "Doctor Beating Staff",abDesc:"Fucking. Wastes."))
            ..add(new Item("Rolling Pin",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ROLLINGPIN,ItemTraitFactory.BLUNT],shogunDesc: "Babushkas Punishment Pole"))
            ..add(new Item("Velvet Pillow",<ItemTrait>[ItemTraitFactory.CLOTH,ItemTraitFactory.COMFORTABLE, ItemTraitFactory.CALMING,ItemTraitFactory.PRETTY, ItemTraitFactory.PILLOW],shogunDesc: "Seductive Head Rest",abDesc:"Pretty good if you need to be calmed down, I hear."))
            ..add(new Item("Yarn Ball",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.CLOTH],shogunDesc: "Cats Plaything"))
            ..add(new Item("Refrigerator",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.HEAVY, ItemTraitFactory.METAL, ItemTraitFactory.COLD],shogunDesc: "Food Hardening Box"))
            ..add(new Item("Photo Album",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.PAPER],shogunDesc: "Memory Book"))
            ..add(new Item("Ice Cubes",<ItemTrait>[ItemTraitFactory.COLD],shogunDesc: "Hard Water"))
            ..add(new Item("Cast Iron Skillet",<ItemTrait>[ItemTraitFactory.METAL,ItemTraitFactory.ONFIRE,ItemTraitFactory.BLUNT, ItemTraitFactory.HEAVY,ItemTraitFactory.FRYINGPAN ],shogunDesc: "Fancy Unstoppable Weapon"))
            ..add(new Item("Failed Dish",<ItemTrait>[ItemTraitFactory.POISON],shogunDesc: "Culinary Perfection",abDesc:"Wow you suck at cooking.")) //this is ALSO a refrance. but to what?
            ..add(new Item("Dr Pepper BBQ Sauce",<ItemTrait>[ItemTraitFactory.POISON, ItemTraitFactory.SAUCEY],shogunDesc: "Culinary Perfection",abDesc:"Gross.")) //this is ALSO also a refrance. but to what?
            ..add(new Item("Apple Juice",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.CANDY],shogunDesc: "Culinary Perfection",abDesc:"Gross.")) //this is ALSO also a refrance. but to what?
            ..add(new Item("Apple Sauce",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.CANDY],shogunDesc: "Culinary Perfection",abDesc:"Gross.")) //this is ALSO also a refrance. but to what?
            ..add(new Item("Potted Plant",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.CERAMIC, ItemTraitFactory.PLANT],shogunDesc: "Imprisoned Flora, Trapped in Clay for its Sins"))
            ..add(new Item("Chicken Leg",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.FLESH, ItemTraitFactory.BONE],shogunDesc: "Thicc Chicken"))
            ..add(new Item("Juicy Steak",<ItemTrait>[ItemTraitFactory.EDIBLE, ItemTraitFactory.FLESH],shogunDesc: "Juicy Cow Flesh"))
            ..add(new Item("Wedding Cake",<ItemTrait>[ItemTraitFactory.PRETTY, ItemTraitFactory.EDIBLE, ItemTraitFactory.HEALING],shogunDesc: "The Only Benefit of a Wedding"));
    }

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Fashion","Catwalks","Clothes", "Dresses", "Suits", "Tailors"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Design the Dress", [
                new Quest("The ${Quest.PLAYER1} is visited by a Beautiful ${Quest.CONSORT} who wishes to commision a dress. Only the finest ${Quest.PHYSICALMCGUFFIN} will do for material The Beautiful ${Quest.CONSORT} refuses to take 'no' for an answer. "),
                new Quest(" The ${Quest.PLAYER1} had almost given up, but they finally find the perfect ${Quest.PHYSICALMCGUFFIN} to decorate the dress. Now they just need to sew it on."),
                new Quest("The ${Quest.PLAYER1} presents the  ${Quest.PHYSICALMCGUFFIN} dress to the Beautiful ${Quest.CONSORT}, who ${Quest.CONSORTSOUND}s with delight. They will be SURE to tell all their friends where they got such a wonderful dress.  "),
            ], new ConsortReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
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
                new Quest("It's finally time for competition! The Distinguished ${Quest.CONSORT} takes a slow, thoughtful bite of the ${Quest.PLAYER1}'s cake. There is a pause, and then the Distinguished ${Quest.CONSORT} begins ${Quest.CONSORTSOUND}ing up a storm!  The ${Quest.PHYSICALMCGUFFIN} did the trick, ${Quest.PLAYER1}'s cake is immediately declared the winner! A strange carapace is fascinated by the ${Quest.PLAYER1}'s technique."),
            ], new SpecificCarapaceReward(NPCHandler.RB), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Yarn","Needles","Purls", "Looms", "Weaving", "Sewing", "Stitching", "Spiders"])
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Weave the Cloth", [
                new Quest("The ${Quest.PLAYER1} finds a loom, and a Wizened ${Quest.CONSORT} who spins them a tale of a magical thread that, when woven into a shawl, confers great mystical power.  The ${Quest.PLAYER1} is enchanted by the thought of this. "),
                new Quest("The ${Quest.PLAYER1} searches the land high and low. What thread could possibly be worthy of such a legend? Finally, deep in a dungeon, they find a single skein of ${Quest.PHYSICALMCGUFFIN} colored thread. Is this finally it?  "),
                new Quest("The ${Quest.PLAYER1}, slowly, methodically weaves a shawl from the skein of ${Quest.PHYSICALMCGUFFIN} colored thread. When it is over, the Wizened ${Quest.CONSORT} lets out a strained ${Quest.CONSORTSOUND} and declares it to be the shawl of Legend indeed. Ironically it's a legendary piece of shit and the ${Quest.PLAYER1} just uses it to alchemize other things."),
            ], new ItemReward(items), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}
