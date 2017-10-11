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
                new Quest("An Excited ${Quest.CONSORT} rushes up to the ${Quest.PLAYER1}. They have been writing fan fiction about the Players for their whole life and want to get feedback on it. Is it accuracate?  The ${Quest.PLAYER1} does their best to keep a straight face, but the fic is...wow.  Why do they have the players ${Quest.CONSORTSOUND}ing so much? "),
                new Quest("Okay.  The Excited ${Quest.CONSORT} has a new version for the ${Quest.PLAYER1} to review. This time they at least aren't obviously ${Quest.CONSORT}s, but the characterization is completely off. You can't even imagine THOSE two getting together.  Feedback round two. "),
                new Quest(" The ${Quest.PLAYER1} reads the final version of the Excited ${Quest.CONSORT}s fan fiction.  Huh. This is....wow! It's even better than reality!  The Excited Consort ends up making crazy amount of boonies from selling the series, and gives the ${Quest.PLAYER1} a gift as thanks! ")
            ], new BoonieFraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Dungeons","Dragons","Authors","Control", "Storytelling", "Scripts"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Be the DM", [
                new Quest("The ${Quest.PLAYER1} "),
                new Quest("The ${Quest.PLAYER1}    "),
                new Quest(" The ${Quest.PLAYER1} ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}