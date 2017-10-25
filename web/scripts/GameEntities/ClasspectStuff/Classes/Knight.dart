import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Knight extends SBURBClass {
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


//protect, defend, fight, exploit
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
            ..addFeature(new PostDenizenQuestChain("Exploit the Heat", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s could really use some basic infrastructure repairs. The ${Quest.PLAYER1} finds instructions for a thermal energy converter in a dungeon and alchemizes all the parts needed to build one. The ${Quest.CONSORT}s will have power for generations,now. "),
                new Quest("An important wall is crumbling. While the defeat of the ${Quest.DENIZEN} means the underlings are mostly under control, the ${Quest.CONSORT}s would feel a lot better with it fixed. The ${Quest.PLAYER1} figures out how to patch it up with bits of cooled lava. Everyone feels just a little bit safer."),
                new Quest("The ${Quest.PLAYER1} rigs an automatic lava dispensor to light fire moats around consort villages, automatically patch wall holes and even bake consort bread.  Who knew all this shitty heat could be good for something?  The ${Quest.CONSORT}s quality of life is at an all time high! ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}