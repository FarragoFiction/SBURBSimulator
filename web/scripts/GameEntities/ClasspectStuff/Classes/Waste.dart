import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../GameEntity.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";
class Waste extends SBURBClass {
    @override
    List<String> levels = <String>["4TH WALL AFICIONADO", "CATACLYSM COMMANDER", "AUTHOR"];
    @override
    List<String> quests = <String>["being a useless piece of shit and reading FAQs to skip the hard shit in levels", "causing ridiculous amounts of destruction trying to skip quest lines", "learning that sometimes you have to do things right, and can't just skip ahead"];
    @override
    List<String> postDenizenQuests = <String>["figuring out the least-disruptive way to help the local Consorts recover from the Denizen's rule", "being a useless piece of shit and not joining cleanup efforts.", "accidentally causing MORE destruction in an attempt to help clean up after their epic as fuck fight agains their Denizen"];
    @override
    List<String> handles = <String>["wasteful", "worrying", "wacky", "withering", "worldly", "weighty"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = true;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    Waste() : super("Waste", 12, false);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 3.0, false), //basically all Wastes have.
        new AssociatedStat(Stats.EXPERIENCE, -2.0, false)
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
        if (stat.isFromAspect || stat.stat != Stats.SBURB_LORE) {
            powerBoost = powerBoost * 0; //wasted aspect
        } else {
            powerBoost = powerBoost * 1;
        }
        return powerBoost;
    }

    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        //wastes will basically never have aspect themed quests. They are WASTES after all.
        //Hussies denizen was OBVIOIUSLY falcor, the luck dragon. His denizen quest was to beat up his bullies.
        addTheme(new Theme(<String>["Horses","Fields", "Meadows", "Majesty","Ponies","Screens","Fourth Walls","Self Inserts", "Meta","Indulgence"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.HIGH) //sound of keys being pressed
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)

            ..addFeature(new DenizenQuestChain("Wear the Merch, Be the Rider", [
                new Quest("The ${Quest.PLAYER1} is sick and tired of being bullied!  If only there was some way they could finally defeat those mean old bullies.   A wizened ${Quest.CONSORT} tells of a legendary artifact that could-- Wait. No. That's so boring.   The ${Quest.PLAYER1} decides to update their highly-indulgent meta work instead."),
                new Quest("Holy shit, did you know you could alchemize MERCHANDISE of your highly indulgent meta work? The ${Quest.PLAYER1} is just covered in merch now. It's great."),
                new Quest("Holy fuck! It turns out that the ${Quest.DENIZEN} is a fan of the ${Quest.PLAYER1}'s highly indulgent meta work!  They also agreed to be called 'Falcor', because, come ON that was a great movie!  The ${Quest.PLAYER1} hops up onto Falcor's back and this is the single coolest thing that has ever happened in all of Paradox Space."),
                new Quest("With a dramatic 'BORF' the bullies are defeated by Falcor! And so came to an end the most heroic thing that ever happened in the history of metafiction. <br><br>Let's move on.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ..addFeature(new PostDenizenQuestChain("Purify the Water", [
                new Quest("The defeat of the ${Quest.DENIZEN} has some unforseen consequences, including the tainting of the water for the majority of the land. The ${Quest.CONSORT}s seem to have figured out a solution in the short term, but the ${Quest.PLAYER1} resolves to bug and fuss and meddle until things are fixed the right way. "),
                new Quest("So far, the ${Quest.PLAYER1} hasn't had much luck getting ${Quest.CONSORT}s to build a water purifying facility.  They are content just boiling their water. 'It's not hard', they say. It's so frustrating that the ${Quest.PLAYER1} knows they can help them but the ${Quest.CONSORT}s just will NOT cooperate. "),
                new Quest("The ${Quest.PLAYER1} has finally accepted that some people just don't want to be helped. As they make peace with this, a mysterious glow emerges from their chest.  The water of the land matches this glow, and the water is purified through the power of ${Quest.MCGUFFIN}. Huh. Okay then.")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}