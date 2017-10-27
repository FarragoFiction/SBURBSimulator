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

            ..addFeature(new PreDenizenQuestChain("Be Spooked By a Wolf", [
                new Quest("The ${Quest.PLAYER1} is trapped in an attic. Bullies chased them here. AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH!  Oh god, that Wolf Head is terrifying!"),
                new Quest("QUITE FRANKLY, your majesty, I don't think you realize what kind of hell the ${Quest.PLAYER1} been through. Do you have even the SLIGHTEST CLUE how many times that wolf head over there has SCARED THE SHIT OUT OF THEM???"),
                new Quest("Fuck. The ${Quest.PLAYER1} is so upset that you don't understand how scary that Spooky Wolf is that they've started babbling about different forms of fictional romance. Welp. Nothing to see here. We better just skip this. ")
            ], new Reward(), QuestChainFeature.defaultOption), Feature.WAY_LOW) //not guaranteed like other quests are
            ..addFeature(new DenizenQuestChain("Be The Illegitimate Player", [
                new Quest("A wizened ${Quest.CONSORT} explains the rules of some convoluted, boring-ass puzzle to the ${Quest.PLAYER1}. Wait wait wait, did they just say something about 'no legitimate way to meet ${Quest.DENIZEN}'?  Hell FUCKING yes, that means there's some ILLEGITIMATE way. "),
                new Quest("After way too much obsessive focus, the ${Quest.PLAYER1} thinks they are onto something. This shitty game is just code, right?  There must be some glitch or exploit or out-right fucking HACK to get to the secret content.  They are gonna meet the FUCK out of ${Quest.DENIZEN}."),
                new Quest("Hell FUCKING yes!!! The ${Quest.PLAYER1} has bugged and fussed and meddled with the code until they are standing in front of ${Quest.DENIZEN}. After solving some bullshit extra bonus Riddle, they gain access to The Hoarde. ")]
                , new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Wear the Merch, Be the Rider", [
                new Quest("The ${Quest.PLAYER1} is sick and tired of being bullied!  If only there was some way they could finally defeat those mean old bullies.   A wizened ${Quest.CONSORT} tells of a legendary artifact that could-- Wait. No. That's so boring.   The ${Quest.PLAYER1} decides to update their highly-indulgent meta work instead."),
                new Quest("Holy shit, did you know you could alchemize MERCHANDISE of your highly indulgent meta work? The ${Quest.PLAYER1} is just covered in merch now. It's great."),
                new Quest("Holy fuck! It turns out that the ${Quest.DENIZEN} is a fan of the ${Quest.PLAYER1}'s highly indulgent meta work!  They also agreed to be called 'Falcor', because, come ON that was a great movie!  The ${Quest.PLAYER1} hops up onto Falcor's back and this is the single coolest thing that has ever happened in all of Paradox Space."),
                new Quest("With a dramatic 'BORF' the bullies are defeated by Falcor! And so came to an end the most heroic thing that ever happened in the history of metafiction. <br><br>Let's move on.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ..addFeature(new PostDenizenQuestChain("Die Ironically, In The Proximity Of Some Horses", [
                new Quest("A wizened ${Quest.CONSORT} tells the ${Quest.PLAYER1} that they are going to die. Ironically.   In the proximity of some horses.  The ${Quest.PLAYER1} shrugs and keeps updating their highly indulgent meta work. "),
                new Quest("Glowing letters, three stories tall,  lit by flame, heavy with the weight of prophecy proclaim 'You Are Going To Die. Ironically.   In the Proximity Of Some Horses'. The ${Quest.PLAYER1} wonders if it's like, a metaphor or something?"),
                new Quest("In a scene predicted by no one, the ${Quest.PLAYER1} dies. In the proximity some horses. How ironic, that their very demise would be in the proximity of some horses. What? You didn't follow that? Just think it over. Think it over...  Luckily being dead doesn't seem to affect the ${Quest.PLAYER1}'s narrative importance at all.   Hell, are you sure they weren't dead all along? ")//hussie has white ghost eyes the whole session, after all.
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)
            ..addFeature(new PostDenizenQuestChain("Run The Simulations", [
                new Quest("Huh. The ${Quest.PLAYER1} has figured out how to run simulations of SBURB? What is even the point? Man, it's a fucking Waste. Maybe there IS no point??? "),
                new Quest("Okay, revised statement: maybe the point of running simulations is to map out all of Paradox Space? Makes way more sense than just having a big black sheet of paper, right? The ${Quest.PLAYER1} makes a robot doppelganger to go explore areas of Paradox Space that are predicted to have useful features. Huh, looks like it's working!"),
                new Quest("Welp. Whatever original reason the ${Quest.PLAYER1} had for finding other sessions has fallen by the wayside. They've gotten completely distracted helping out sessions with no alpha and accidentally dooming the fuck out of everyone when they make a typo in some code.   I thought these were just simulations? Fuck Paradox Space. ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenFrogChain("Waste the Frogs", [
                new Quest("The ${Quest.DENIZEN} explains um. What? Where did the ${Quest.PLAYER1} go?"),
                new Quest("The ${Quest.PLAYER1} is sick and tired of being bullied!  If only there was some way they could finally defeat those mean old bullies.   A wizened ${Quest.CONSORT} tells of a legendary artifact that could-- Wait. No. That's so boring.   The ${Quest.PLAYER1} decides to update their highly-indulgent meta work instead."),
                new Quest("Holy shit, did you know you could alchemize MERCHANDISE of your highly indulgent meta work? The ${Quest.PLAYER1} is just covered in merch now. It's great."),
                new Quest("Holy fuck! It turns out that the ${Quest.DENIZEN} is a fan of the ${Quest.PLAYER1}'s highly indulgent meta work!  They also agreed to be called 'Falcor', because, come ON that was a great movie!  The ${Quest.PLAYER1} hops up onto Falcor's back and this is the single coolest thing that has ever happened in all of Paradox Space."),
                new Quest("With a dramatic 'BORF' the bullies are defeated by Falcor! And so came to an end the most heroic thing that ever happened in the history of metafiction. <br><br>Let's move on.  Wait. What? How did THAT somehow breed the Ultimate Frog???")
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ,  Theme.HIGH);
    }


}