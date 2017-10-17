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
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Recover the Books", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, with no books in it! They manage to get a local ${Quest.CONSORT} to stop ${Quest.CONSORTSOUND}ing long enough to discover that underlings stole all the books. "),
                new Quest("The ${Quest.PLAYER1} has tracked down the book thieves to a nearby dungeon. After some harrowing puzzles and frankly amazing battles, the books are recovered. "),
                new Quest("The ${Quest.CONSORT} librarian is beside himself and cannot stop ${Quest.CONSORTSOUND}ing. The  ${Quest.PLAYER1} is hailed as a local hero for returning the books!  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Shelve the Books", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, with no books in it! They manage to get a local ${Quest.CONSORT} to stop ${Quest.CONSORTSOUND}ing long enough to discover that the Librarian quit and none of the books have been reshelved. "),
                new Quest("The ${Quest.PLAYER1} decides to volunteer at the library, and beings shelving books. There's a book.  And another book. Oooo, that one looks interesting.... "),
                new Quest("The ${Quest.PLAYER1} has finally shelved the final book!  They are first in line to begin checking things out, too. Books!  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsProtectiveClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Research the Denizen", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, filled with books. The ${Quest.CONSORT} librarian offers to help the ${Quest.PLAYER1} search for useful books. "),
                new Quest("The ${Quest.PLAYER1} begins to learn about ${Quest.DENIZEN} and how they have persecuted the ${Quest.CONSORT}s.  "),
                new Quest("The ${Quest.PLAYER1} has read the final book about ${Quest.DENIZEN} and feels much more prepared to face them.  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Calculators","Math","Numbers", "Formulas", "Algebra", "Calculus"])
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Do the Math", [
                new Quest("The ${Quest.PLAYER1}  is approached by a ${Quest.CONSORT} who had 13 apples, but needs to give them to their 3 children proportionate to their ages.   Oh god. Math. "),
                new Quest("The ${Quest.PLAYER1} catches some thieves only to discover that robbery is illegal only on days that are prime factors of 1300. Oh god. Math. "),
                new Quest("The ${Quest.CONSORT}  finds a ${Quest.CONSORT} child ${Quest.CONSORTSOUND}ing up a storm. It turns out they got their quiz question wrong and they don't know why.  Does the ${Quest.PLAYER1} know why? (Spoiler alert, it turns out to be order of operations.) You beging to wonder if SBURB is one of those shitty 'educational' games. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Use the Calculator", [
                new Quest("The ${Quest.PLAYER1} finds a mysterious calculator in a place of prominence on their land. They poke and prod at it.  What could it be? "),
                new Quest("BZAP!  There are now two ${Quest.CONSORT}s.  BZAP!  Now there are four.  The ${Quest.PLAYER1} is getting the hang of this weird calculator that controls reality. "),
                new Quest("With a frantic ${Quest.CONSORTSOUND}, a small ${Quest.CONSORT} sprints towards the ${Quest.PLAYER1}.  A giant ogre is chasing them.  In a panic, the ${Quest.PLAYER1} hits the 'divide' key, and the Ogre is defeated. Holy shit.  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsDestructiveClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Solve the Equation", [
                new Quest("The ${Quest.PLAYER1}  finds a mysterious equation scrawled onto a wall. What could it mean? "),
                new Quest("There is a flurry of motion.  The ${Quest.PLAYER1} shouts out in triumph.  THAT's what that variable means! The equation on the wall is one step closer to being solved.  "),
                new Quest("The ${Quest.PLAYER1} has done it. Against all odds they have solved the equation.  A ${Quest.CONSORT} runs up to them and gives them a fraymotif as the prize for being so good at math.  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Flasks","Test Tubes","Chemicals", "Science", "Labs", "Beakers"])
            ..addFeature(FeatureFactory.BEEPINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Test the Hypothesis", [
                new Quest("The ${Quest.PLAYER1}  is approached by a ${Quest.CONSORT} who offers them a grant to study ${Quest.PHYSICALMCGUFFIN}, the only catch is they must present their findings at a giant symposium in just a little bit. "),
                new Quest("The ${Quest.PLAYER1} forms hypothesis after hypothesis only for each to be completely falsified in turn. This is a disastor! "),
                new Quest("The Symposium has started. The crowd of unruly ${Quest.CONSORT}s begins ${Quest.CONSORTSOUND}ing louder and louder. Finally, the ${Quest.PLAYER1} bursts in, looking disheveled. It was last minute, but they managed to find something groundbreaking about ${Quest.PHYSICALMCGUFFIN}, and they do an enthralling presentation on their findings. They are hailed as a SCIENCE HERO!"),
            ], new FraymotifReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Make the Cure", [
                new Quest("Too many local ${Quest.CONSORT} have fallen ill from a mysterious plague.  Those inflicted are too weak to even ${Quest.CONSORTSOUND}.  It is up to the ${Quest.PLAYER1} to figure out how to cure the disease.  They are provided with a state of the art lab and a team of ...not completely terrible ${Quest.CONSORT}s."),
                new Quest("The ${Quest.PLAYER1} has gotten far too little sleep. Suddenly, they realize the key, the one thing they have been missing: ${Quest.PHYSICALMCGUFFIN}. It all makes sense now! "),
                new Quest("Each ${Quest.CONSORT} lines up to receive their ${Quest.PHYSICALMCGUFFIN} injection. The sound of joyful ${Quest.CONSORTSOUND} fills the air. The plague is defeated!  The ${Quest.PLAYER1} has a statue made of them in the town center. "),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Be the Scientist", [
                new Quest("The ${Quest.PLAYER1}  finds a mysterious lab, fully stocked with equipment and chemicals. It is completely abandoned. Locked doors are on every wall of the main area. "),
                new Quest("The ${Quest.PLAYER1}  realizes that various sections of the lab open up if you pour the right kind of chemical into a slot on the door. The begin venturing deeper and deeper into the lab.  "),
                new Quest("The ${Quest.PLAYER1} has finally reached the final door. They bite their lip in concentration as they pour the final mixed chemical into the slot.  The door slides open.  A sudden ${Quest.CONSORTSOUND} nearly has them drop the dangerous fluid, but they manage to regain their composure in time.  An entire room of ${Quest.CONSORT}s are inside the final room, outfitted for a surprise party.  It is for ${Quest.PLAYER1} to celebrate how great at science they are! There is even a SCIENCE CAKE."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }


}