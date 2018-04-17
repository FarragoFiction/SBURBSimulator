import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Smith extends SBURBClass {

    @override
    String sauceTitle = "Sculpter";

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.51;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.01;


    @override
    List<String> levels = ["HAMMER HONCHO", "BICEP BEEFCAKE", "ACCOMPLISHED ARTIST"];
     @override
    List<String> handles = ["silver","silver","skillful","standard","symbolic", "snarky", "scheming", "shifty", "stylish", "serendipitous", "shallow", "saucy","stimulating"];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, -0.1, false),
        new AssociatedStat(Stats.ALCHEMY, 1.0, false)

    ]);

    Smith() : super("Smith", 20, false);


    @override
    bool highHinit() {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Meddler's Guide",<ItemTrait>[ItemTraitFactory.BOOK, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.PAPER, ItemTraitFactory.ENRAGING,ItemTraitFactory.LEGENDARY,ItemTraitFactory.HEALING],abDesc:"Meddling meddlers gotta meddle. "))
            ..add(new Item("First Aid Kit",<ItemTrait>[ItemTraitFactory.GLASS, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.HEALING],shogunDesc: "Anti-Pain Box",abDesc:"Heals here."))
            ..add(new Item("Cloud in a Bottle",<ItemTrait>[ItemTraitFactory.CLASSRELATED, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.CALMING],shogunDesc: "Fart In a Jar",abDesc:"Fucking sylphs man. How do they work?"))
            ..add(new Item("Fairy Wings",<ItemTrait>[ItemTraitFactory.MAGICAL, ItemTraitFactory.CLASSRELATED,ItemTraitFactory.GLOWING, ItemTraitFactory.PRETTY, ItemTraitFactory.PAPER],shogunDesc: "Wings Cut Straight From a God Tier Troll", abDesc: "I GUESS Sylphs in myths are kinda fairy shit, right?"));
    }


    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 0.5;
        } else {
            powerBoost = powerBoost * -0.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 0.5;
    }

    @override
    double getDefenderModifier() {
        return 1.5;
    }

    @override
    double getMurderousModifier() {
        return 1.0;
    }

    @override
    bool hasInteractionEffect() {
        return false;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")


        */

        //smiths are about extending plots and literally forging things.
        addTheme(new Theme(<String>["Villages","Forges", "Smiths", "Anvils","Hammers","Horseshoes","Nails","Jewelers"])
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)

            ..addFeature(new PostDenizenFrogChain("Forge the Frogs", [
                new Quest("The defeat of the ${Quest.DENIZEN} has somehow caused the Forge to go quiescent again? What the hell? The ${Quest.PLAYER1} has to start stoking it all over again. "),
                new Quest("The ${Quest.PLAYER1} breeds one frog only for it to somehow cause half their work to be undone. They have the feeling they will be here for awhile."),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  Wait. No. False alarm. Looks like there's one more step.    "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  They wait several moments to see if SBURB is going to throw yet another bullshit set back their way to draw the plot out, but nope. It looks like they are actually, finally, done.     "),

            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Supply the Consorts", [
                new Quest("Now that the ${Quest.DENIZEN} has been taken care of, the ${Quest.PLAYER1} finds a long line of ${Quest.CONSORT}s who lack the things they need to live their lives. The ${Quest.PLAYER1} gets to work alchemizing them."),
                new Quest("The ${Quest.PLAYER1} sits in a small room, creating tablewear, blankets, clothes, bookshelves, anything the demanding ${Quest.CONSORT} might need.  The work is strangely soothing."),
                new Quest(" The ${Quest.CONSORT} finally have the basic necessities taken care of.  The local ${Quest.CONSORT}s dedicate a new Blacksmith Forger in the  ${Quest.PLAYER1}'s honor and vow to make their own goods from now on.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}