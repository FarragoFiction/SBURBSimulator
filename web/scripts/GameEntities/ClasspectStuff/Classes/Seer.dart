import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Seer extends SBURBClass {
    @override
    List<String> levels = ["SEEING iDOG", "PIPSQUEAK PROGNOSTICATOR", "SCAMPERVIEWER 5000"];
    @override
    List<String> quests = ["making the various bullshit rules of SBURB part of their personal mythos", "collaborating with the exiled future carapacians to manipulate Prospit and Derse according to how its supposed to go", "suddenly understanding everything, and casting sincere doubt at the laughable insinuation that they ever didn't"];
    @override
    List<String> postDenizenQuests = ["casting their sight around the land to find the causes of their land’s devastation", "taking a consort under their wing and teaching it the craft of magic", "predicting hundreds of thousands of variant future possibilities, only to realize that the future is too chaotic to exactly systemize", "alchemizing more and more complex seer aids, such as crystal balls or space-specs"];
    @override
    List<String> handles = ["sightly", "sanctimonious", "sarcastic", "sassy", "scintillating", "synergistic", "savant"];

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

    Seer() : super("Seer", 6, true);


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.4, false)
    ]);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
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
        return 1.0;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //seers are blind, get it?
        addTheme(new Theme(<String>["Mines","Holes", "Tunnels", "Burrows","Nests"])
            ..addFeature(FeatureFactory.MOLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLAUSTROPHOBICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.MEDIUM)
            //in the land of the blind....
            ..addFeature(new PostDenizenQuestChain("Be the King", [
                new Quest("Now that the ${Quest.DENIZEN} has been defeated, the land is really starting to open up. The ${Quest.PLAYER1} finds a tunnel filled with Blind ${Quest.CONSORT}s who could use some guidance on where to place new tunnels. The ${Quest.PLAYER1} agrees to see what they can do. "),
                new Quest("The ${Quest.PLAYER1} guides the Blind ${Quest.CONSORT}s to the best place to lay a new tunnel. You kind of wonder how they got along up until now."),
                new Quest("The Blind ${Quest.CONSORT} have finally finished the tunnel.  Not only did it not collapse, killing all the diggers, but there was grist and boondollars found during excavation.   The happy ${Quest.CONSORT}s give the ${Quest.PLAYER1} some as a reward. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }

}