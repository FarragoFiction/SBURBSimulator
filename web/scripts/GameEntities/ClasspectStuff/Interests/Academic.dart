import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Academic extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.FREE_WILL, -2.0, true)]);
    @override
    List<String> handles1 = <String>["serious", "researching", "machiavellian", "princeton", "pedagogical", "theoretical", "hypothetical", "meandering", "scholarly", "biological", "pants", "spectacled", "scientist", "scholastic", "scientific", "particular", "measured"];

    @override
    List<String> handles2 = <String>["Business", "Stuck", "Student", "Scholar", "Researcher", "Scientist", "Trainee", "Biologist", "Minerologist", "Lecturer", "Herbalist", "Dean", "Director", "Honcho", "Minder", "Verbalist", "Botanist"];

    @override
    List<String> levels = <String>["NERDY NOODLER", "SCAMPERING SCIENTIST"];

    @override
    List<String> interestStrings =<String>["Archaeology", "Mathematics", "Astronomy", "Knowledge", "Physics", "Biology", "Chemistry", "Geneology", "Science", "Molecular Gastronomy", "Model Trains", "Politics", "Geography", "Cartography", "Typography", "History"];



    Academic() :super(13, "Academic", "smart", "nerdy");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Books","Libraries","Tomes", "Fiction", "Pages", "Words", "Shelves"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Shelve the Books", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, with no books in it! They manage to get a local ${Quest.CONSORT} to stop ${Quest.CONSORTSOUND}ing long enough to discover that underlings stole all the books. "),
                new Quest("The ${Quest.PLAYER1} has tracked down the book thieves to a nearby dungeon. After some harrowing puzzles and frankly amazing battles, the books are recovered. "),
                new Quest("The ${Quest.CONSORT} librarian is beside himself and cannot stop ${Quest.CONSORTSOUND}ing. The  ${Quest.PLAYER1} is hailed as a local hero for returning the books!  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.LOW)
            ,  Theme.HIGH);
    }


}