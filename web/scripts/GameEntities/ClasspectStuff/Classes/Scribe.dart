import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Scribe extends SBURBClass {
    Scribe() : super("Scribe", 15, false);
    @override
    List<String> levels = ["MIDNIGHT BURNER", "WRITER WATCHER", "DIARY DEAREST"];
    @override
    List<String> quests = ["taking down the increasingly random and nonsensical oral history of a group of local Consorts", "playing typing themed mini games.", "saving an important piece of a riddle from a crumbling building"];
    @override
    List<String> postDenizenQuests = ["documenting the various Consorts lost to the Denizen.", "writing up a recovery plan for the Local Consorts", "figuring out the best way to explain how to recover from the ravages of Denizen"];
    @override
    List<String> handles = ["serious", "sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

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
    bool isHelpful = true;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.5, false)
    ]);

    @override
    bool highHinit() {
        return false;
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
        addTheme(new Theme(<String>["Quills","Feathers", "Pens", "Ink","Paper"])
            ..addFeature(FeatureFactory.BIRDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has caused all those fucking bird underlings to finally drop the frogs. The ${Quest.PLAYER1} thinks hard and figures out the best way to start collecting them. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  They combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Restore the Library", [
                new Quest("Now that the ${Quest.DENIZEN} has been taken care of, the ${Quest.PLAYER1} discovers a large library of ${Quest.CONSORT} documents and books in its lair. They were not taken care of to say the least, and are badly in need of repair."),
                new Quest("The ${Quest.PLAYER1} sits in a small room, repairing bindings, glueing pages, and copying and replacing pages outright where necessary.  The work is strangely soothing."),
                new Quest(" The final book has been restored.  The local ${Quest.CONSORT}s dedicate a library in the ${Quest.PLAYER1}'s honor and cherish their legacy now returned to them.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}