import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Mage extends SBURBClass {
    @override
    List<String> levels = ["WIZARDING TIKE", "THE SORCERER'S SCURRYWART", "FAMILIAR FRAYMOTTIFICTIONADO"];
    @override
    List<String> quests = ["performing increasingly complex alchemy for demanding, moody consorts", "learning to silence their Mage Senses long enough to not go insane", "learning to just let go and let things happen"];
    @override
    List<String> postDenizenQuests = ["finding yet another series of convoluted puzzles, buried deep in their land. These puzzles pour poison into the land, and will continue to do so until solved", "realizing the voices are gone. Not just quiet, but… gone. Without them, they can finally get down to work on their land puzzles", "solving the more of the puzzles of their land. Not that that's the end of the horseshit, but hey! Less horseshit always helps", "getting sick to death of puzzles and just utterly annihilating one with their game powers"];
    @override
    List<String> handles = ["magnificent", "managerial", "major", "majestic", "mannerly", "malignant", "morbid"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    Mage() : super("Mage", 2, true);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.4, false)
    ]);

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
            powerBoost = powerBoost * 2;
        } else {
            powerBoost = powerBoost * 2.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 0.67;
    }

    @override
    double getDefenderModifier() {
        return 0.67;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }


    //rule, control, delegate
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Cities","Skyscrapers", "Buildings", "Stoplights","Cars","Streetlights","Traffic"])
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SMOKESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.OILSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.LOW)
            ..addFeature(new PostDenizenQuestChain("Become the Mayor", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the ${Quest.CONSORT}s are ready to expand their civilization. They ask the ${Quest.PLAYER1}'s help in planning the brand new city of ${Quest.MCGUFFIN}burg."),
                new Quest("A panicking ${Quest.CONSORT} runs up to the ${Quest.PLAYER1}, ${Quest.CONSORTSOUND}ing the whole time. The ${Quest.MCGUFFIN}burg sanitation facility has been delayed, but the residential areas are already starting to fill up!  The ${Quest.PLAYER1} shuffles around work shifts to get the sanitation working before things get too...disgusting."),
                new Quest("It is finally time for the final brick to be placed for the final building in ${Quest.MCGUFFIN}burg. The ${Quest.PLAYER1} snips a ceremonial ribbon opening up the Mayor's office, to which they have been elected in a landslide. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}