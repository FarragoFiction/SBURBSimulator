import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Sage extends SBURBClass {
    Sage() : super("Sage", 14, false);
    @override
    List<String> levels = ["HERBAL ESSENCE", "CHICKEN SEASONER", "TOMEMASTER"];
    @override
    List<String> quests = ["making the lore of SBURB part of their personal mythos", "learning to nod wisely and remain silent when Consorts start yammering on about the Ultimate Riddle", "participating in riddle contests to prove their intelligence to local Consorts"];
    @override
    List<String> postDenizenQuests = ["learning everything there is learn about the Denizen, now that it is safely defeated", "learning what Consort civilization was like before the Denizen, to better help them return to 'normal'", "demonstrating to the local Consorts the best way to move on from the tyranny of the Denizen"];
    @override
    List<String> handles = ["serious", "sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.5, false)
    ]);

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Books","Libraries", "Tomes", "Pages","Advice","Scholarship","Expertise"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)

            ..addFeature(new PostDenizenFrogChain("Understand the Frogs", [
                new Quest("The ${Quest.DENIZEN} has blocked access to the books for the duration. The ${Quest.PLAYER1} has no choice but to go get some fresh air for a change and start collecting frogs. The ${Quest.PLAYER1} thinks hard and figures out the best way to organize the ${Quest.CONSORT}s to start collecting frogs. "),
                new Quest("The ${Quest.PLAYER1} is getting a headache trying to keep track of which frogs have been bred with which other frogs. The constant croaking isn't helping, either. "),
                new Quest("The ${Quest.PLAYER1} has finally figured out how to breed the final frog.  They combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Be the Sage", [
                new Quest("Now that the ${Quest.DENIZEN} is defeated, it is time to begin recovery efforts. The ${Quest.CONSORT}s ask the ${Quest.PLAYER1} what they should do first.  When they hesitate, the ${Quest.CONSORT}s begin ${Quest.CONSORTSOUND}ing in distress. Desparate, the ${Quest.PLAYER1} confidently advises them to begin cleaning up rubble. The ${Quest.CONSORT}s seem satisfied.  The ${Quest.PLAYER1} absconds into a nearby library to read up on how in Paradox Space they can figure out what ACTUALLY needs done. "),
                new Quest("The ${Quest.PLAYER1} has read up on disaster recovery and helps the ${Quest.CONSORT}s plan the next season's crops, build infrastructure and even set up psychological counseling center for those in need. Every moment they aren't in public they are devouring tomes in an effort to stay one step ahead of everything."),
                new Quest("Finally, recovery efforts are complete. The ${Quest.PLAYER1} has developed quite the reputation as the person to go to for advice and knowledge. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}