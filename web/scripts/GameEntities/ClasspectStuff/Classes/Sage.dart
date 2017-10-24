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
        addTheme(new Theme(<String>["Books","Libraries", "Tomes", "Pages","Advice","Scholarship"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new PostDenizenQuestChain("Provide the Advice", [
                new Quest("Now that the ${Quest.DENIZEN} is finally out of the way, some of the previously sealed tombs have opened up. It is time for the ${Quest.PLAYER1} to desecrate the fuck out of some tombs."),
                new Quest("In a twist that is shocking only to the ${Quest.PLAYER1}, they are now inflicted with a Mummy's Curse. There is a REASON you don't desecrate random tombs. A local ${Quest.CONSORT} explains that they will have to find a ${Quest.PLAYER1} champion to face the Mummy, for anyone cursed by it will surely perish should they face it in a strife."),
                new Quest("The ${Quest.PLAYER1} finds a competent enough Warrior ${Quest.CONSORT} to help them fight the Mummy. While they can't fight directly, the ${Quest.PLAYER1} can at least give them some ${Quest.MCGUFFIN} buffs. With a deafening ${Quest.CONSORTSOUND}, the Warrior ${Quest.CONSORT} wins the day! The curse is lifted! ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}