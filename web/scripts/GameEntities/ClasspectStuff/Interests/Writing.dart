import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Writing extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.FREE_WILL, 2.0, true)]);
    @override
    List<String> handles1 = <String>["wordy", "scribbling", "meandering", "pageturning", "mysterious", "knowledgeable", "reporting", "scribing", "tricky", "hardcover", "bookish", "page", "writing", "scribbler", "wordsmiths"];

    @override
    List<String> handles2 = <String>["Shakespeare", "Host", "Bard", "Drifter", "Reader", "Booker", "Missive", "Labret", "Lacuna", "Varvel", "Hagiomaniac", "Traveler", "Thesis"];

    @override
    List<String> levels = <String>["SHAKY SHAKESPEARE", "QUILL RUINER"];

    @override
    List<String> interestStrings =  <String>["Writing", "Fan Fiction", "Script Writing", "Character Creation", "Dungeon Mastering", "Authoring"];



    Writing() :super(3, "Writing", "lettered", "wordy");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Books","Shelves","Libraries","Tomes", "Fiction", "Pages", "Words"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Stop the Vandals", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, and all the books are in disarray! Who could have done this? As they begin trying to help straighten up, the Librarian ${Quest.CONSORT} explains that a gang of unruly underlings have been vandalizing local libraries.  The ${Quest.PLAYER1} vows to stop their reign of terror. "),
                new Quest("The ${Quest.PLAYER1} finds yet another vandalized Library. This time, the trail is still warm. They track the unruly underlings to a nearby Dungeon. Now they just have to plan their attack.   "),
                new Quest(" The ${Quest.PLAYER1} lies in wait at the Dungeon entrance. Before long, the unruly underlings emerge, no doubt in preparation to vandalize yet another Library.  Instead, they get a serving of Justice.  The local libraries are safe!")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Fan Fiction","Fics","Fandom", "Mary Sues","Tumblers"])
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Read the Fan Fiction", [
                new Quest("An Excited ${Quest.CONSORT} rushes up to the ${Quest.PLAYER1}. They have been writing fan fiction about the Players for their whole life and want to get feedback on it. Is it accurate?  The ${Quest.PLAYER1} does their best to keep a straight face, but the fic is...wow.  Why do they have the players ${Quest.CONSORTSOUND}ing so much? "),
                new Quest("Okay.  The Excited ${Quest.CONSORT} has a new version for the ${Quest.PLAYER1} to review. This time they at least aren't obviously ${Quest.CONSORT}s, but the characterization is completely off. You can't even imagine THOSE two getting together.  Feedback round two. "),
                new Quest(" The ${Quest.PLAYER1} reads the final version of the Excited ${Quest.CONSORT}s fan fiction.  Huh. This is....wow! It's even better than reality!  The Excited Consort ends up making crazy amount of boonies from selling the series, and gives the ${Quest.PLAYER1} a gift as thanks! ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Dungeons","Dragons","Authors","Control", "Storytelling", "Scripts"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Be the DM", [
                new Quest("The ${Quest.PLAYER1} finds a strange minature dungeon, filled with four small ragdolls of Adventurer ${Quest.CONSORT}s. A placard proclaims 'Be the DM, it is You.'. Huh. The ${Quest.PLAYER1} is interested, and weaves an elaborate tale full of intrigue and danger, before dramatically injuring one of the Adventurer ${Quest.CONSORT}s right before the end. As they finish their story, a nearby dungeon opens up and three ${Quest.CONSORT}s stumble out, dragging a fourth.  Oh. Shit. The dungeon flashes 'You did this.'"),
                new Quest("The ${Quest.PLAYER1} finds another minature dungeon. Oh HELL no, they are not going to repeat this shit. They have no interest in playing god, thank you very much.  The nearby regular size dungeon flashes 'Are you Sure? Y/N', and the ${Quest.PLAYER1} quickly selects 'Y'.  The dungeon immediately collapses, presumably killing any Adventurer ${Quest.CONSORT}s who were trapped inside. Holy fuck. What is WRONG with this game?  "),
                new Quest(" The ${Quest.PLAYER1} finds yet another minature dungeon. Fuck. Okay. They can't opt out, or the Adventurer's have rocks fall on them and die. But they aren't going to make it tragic again. No way. They tell a....serviceable story in which the Adventuring ${Quest.CONSORT}s walk through a dungeon with insultingly easy puzzles and then are allowed to leave. The nearby dungeon opens up and four confused Adventurer ${Quest.CONSORT}s wander out. 'Wow, that was really unsatisfying!' one remarks. The dungeon flashes 'Boring. Try Again Later.' "),
                new Quest("The ${Quest.PLAYER1} finds what is hopefully the last minature dungeon. They resign themselves to making the most interesting story possible WITHOUT fucking over the characters in it. They weave an elaborate story with twists and turns and close calls. At the end of it, the 4 Adventuring ${Quest.CONSORT}s walk out of the dungeon laughing and talking about their adventure. The dungeon flashes 'Good Job!', and deploys positive reinforcment. Quest chain: complete! ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}