import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Knight extends SBURBClass {
    @override
    double difficulty = 0.7;
    @override
    List<String> levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SKULLDODGER"];
    @override
    List<String> quests = ["protecting the local consorts from a fearsome foe", "protecting the session from various ways it can go shithive maggots", "questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader"];
    @override
    List<String> postDenizenQuests = ["", "spending way too much time hustling from village to village, saving the consorts from the denizens last few minions", "breaking a siege on a consort village, saving its population and slaughtering thousands of underlings", "finishing the ‘legendary’ tests of valor dispensed by an elder consort"];
    @override
    List<String> handles = ["keen", "knightly", "kooky", "kindred", "kaos",];

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
    bool isHelpful = false;

    Knight() : super("Knight", 3, true);

    @override
    bool highHinit() {
        return true;
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
        return 1.0;
    }

    @override
    double getDefenderModifier() {
        return 2.5;
    }

    @override
    double getMurderousModifier() {
        return 0.75;
    }


//protect, defend, fight, exploit. aspect is dragon you face and weapon you wield all in one.
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Heat","Volcanos", "Flame", "Lava","Magma","Fire"])
            ..addFeature(FeatureFactory.OVERHEATED, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Breed the Frogs", [
                new Quest("The ${Quest.DENIZEN} has cooled the lava enough for water to begin pooling in places, which attracts frogs.  The land less overheated. The ${Quest.PLAYER1} collects all sorts of frogs. Various ${Quest.CONSORT}s 'help' by ${Quest.CONSORTSOUND}ing up a storm. "),
                new Quest("The ${Quest.PLAYER1} has a weird system going where the newest zapped in tadpole presses the buttont to zap in the next one. Things are going almost as quickly as if they had another player's help. "),
                new Quest("The ${Quest.PLAYER1} has found the final frog.  They combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Exploit the Heat", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s could really use some basic infrastructure repairs. The ${Quest.PLAYER1} finds instructions for a thermal energy converter in a dungeon and alchemizes all the parts needed to build one. The ${Quest.CONSORT}s will have power for generations,now. "),
                new Quest("An important wall is crumbling. While the defeat of the ${Quest.DENIZEN} means the underlings are mostly under control, the ${Quest.CONSORT}s would feel a lot better with it fixed. The ${Quest.PLAYER1} figures out how to patch it up with bits of cooled lava. Everyone feels just a little bit safer."),
                new Quest("The ${Quest.PLAYER1} rigs an automatic lava dispensor to light fire moats around consort villages, automatically patch wall holes and even bake consort bread.  Who knew all this shitty heat could be good for something?  The ${Quest.CONSORT}s quality of life is at an all time high! ")
            ], new FraymotifReward(), QuestChainFeature.spacePlayer), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Fight the Beast", [
                new Quest("A fiery ${Quest.MCGUFFIN} Dragon has risen up in the wake of the defeated ${Quest.DENIZEN}. A Learned ${Quest.CONSORT} explains that it can only be defeated by the Legendary ${Quest.PHYSICALMCGUFFIN} Blade. The ${Quest.PLAYER1} prepares to go questing for it. "),
                new Quest("The ${Quest.PLAYER1} finds the Legendary ${Quest.PHYSICALMCGUFFIN} Blade stuck in a rock. After a lot of fucking around trying to remove it, they accidentally snap it in half. Welp. Guess it can't hurt to go fight the ${Quest.MCGUFFIN} Dragon anyways. How much harder can it be than a ${Quest.DENIZEN}, anyways?"),
                new Quest("The ${Quest.PLAYER1} is engaged in an epic, yet conviniently off screen strife with the ${Quest.MCGUFFIN} Dragon. Nothing seems to have any effect untill, out of desparation, the ${Quest.PLAYER1} pulls out the broken Legendary ${Quest.PHYSICALMCGUFFIN} Blade and chucks it at the mighty dragon. A blade of ghostly ${Quest.PHYSICALMCGUFFIN} extends from it an the dragon is vanquished.  Huh. You....guess that the blade was always supposed to be like that? Huh.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PostDenizenQuestChain("Protect the Consorts", [
                new Quest("The volcanos of the land are weirdly active after the defeat of the ${Quest.DENIZEN}. Onehas begins to erupt near a ${Quest.CONSORT} village.  The resident ${Quest.CONSORT}s are filling the air with panicked ${Quest.CONSORTSOUND}s, but not really doing anything to evacuate or save anyone. The ${Quest.PLAYER1} face palms, then begins wildly captchalogging everyone in order to get them to safety.  When they let everyone free, the village is destroyed, but at least it's people are safe."),
                new Quest("Another day, another volcano is erupting. After decaptchalogging the final rescued ${Quest.CONSORT}, the ${Quest.PLAYER1} thinks that there MUST be a better way."),
                new Quest("After a lot of false starts, the ${Quest.PLAYER1} has managed to rig a system where the rising heat of the lava itself will trigger entire ${Quest.CONSORT} villages to just rise up out of harms way. Hell yes!")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}