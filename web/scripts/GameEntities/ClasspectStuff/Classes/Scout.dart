import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Scout extends SBURBClass {

    @override
    String sauceTitle = "Scorned";
    //what sort of quests rewards do I get?
    @override
    double itemWeight = 1.01;
    @override
    double fraymotifWeight = 0.01;
    @override
    double companionWeight = 0.01;

    Scout() : super("Scout", 13, false);
    //i am thinking guides will give other players their own aspects (and not the guides) while scouts will gain whoever they are with's aspect.
    @override
    List<String> levels = ["BOSTON SCREAMPIE", "COOKIE OFFERER", "FIRE FRIEND"];
    @override
    List<String> quests = ["exploring areas no Consort has dared to trespass in", "getting lost in ridiculously convoluted mazes", "playing map-creating mini games"];
    @override
    List<String> postDenizenQuests = ["finding Consorts that still need help even after the Denizen has been defeated", "scouting out areas that have opened up following the Denizen's defeat", "looking for rare treasures that are no longer being guarded by the Denizen"];
    @override
    List<String> handles = ["surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = true;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return false;
    }

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Walking Stick",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.STICK],shogunDesc: "Support Stick of Old And Injured",abDesc:"I guess it helps scouts walk for long periods of time? And not let anybody catch up."))
            ..add(new Item("Adorable Girlscout Beret",<ItemTrait>[ItemTraitFactory.CLOTH, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.FASHIONABLE, ItemTraitFactory.SMART, ItemTraitFactory.LEGENDARY],shogunDesc: "ABJs Hat",abDesc:"Okay, legit, ABJ's hat is amazing."))
            ..add(new Item("Map",<ItemTrait>[ItemTraitFactory.PAPER, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SMART],shogunDesc: "Kyoto Overcoats Spacemap",abDesc:"I guess Scouts update this on their own? Untread ground and all."))
            ..add(new Item("Compass",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.CLASSRELATED, ItemTraitFactory.SMART, ItemTraitFactory.MAGICAL],shogunDesc: "Shoguns Navigation Box",abDesc:"Magnets man, how do they work."));
    }


    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }


    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Maps","Trails", "Compasses", "Wilderness","Trails"])
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Blaze a Trail", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the planet has really opened up. The ${Quest.PLAYER1} eagerly begins to explore uncharted territory. "),
                new Quest("The ${Quest.PLAYER1} takes in the sight of a glorious waterfall. They might be the only thing in living memory to see it. It's amazing. They continue exploring their land."),
                new Quest("Deep in a forgotten forest, in a temple covered in golden ${Quest.CONSORT}s, the ${Quest.PLAYER1} finds a treasure chest with a fraymotif inside. Travel is its own reward, but it's nice to have more tangible ones, too.")
            ], new RandomReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

        //space player near guaranteed to do this.
            ..addFeature(new PostDenizenFrogChain("Find the Frogs", [
                new Quest("The ${Quest.DENIZEN} has released the frogs from their vine tangled prisons. The land gets just a little bit less wild. The ${Quest.PLAYER1} is given a map to where all the frogs are and is told to get going. "),
                new Quest("The ${Quest.PLAYER1} is following a detailed guide on which frogs to combine with which other frogs. It's a little boring, but at least the ${Quest.PLAYER1} knows they won't make a mistake."),
                new Quest("Following the last step in the guide booke, the ${Quest.PLAYER1} finds the Final Frog. Luckily, a ${Quest.CONSORT} ${Quest.CONSORTSOUND}s in time to stop them.   "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ,  Theme.MEDIUM);
    }



}