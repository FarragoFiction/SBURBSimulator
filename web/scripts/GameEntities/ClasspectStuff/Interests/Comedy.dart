import "Interest.dart";
import "../../../SBURBSim.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Comedy extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MIN_LUCK, -1.0, true),
        new AssociatedStat(Stats.MAX_LUCK, 1.0, true)
    ]);

    @override
    List<String> handles1 = <String>["mischievous", "knavish", "mercurial", "beagle", "sarcastic", "satirical", "mime", "pantomime", "practicing", "pranking", "wokka", "kooky", "haha", "humor", "talkative", "harlequins", "hoho"];

    @override
    List<String> handles2 =<String>["Laugher", "Humorist", "Trickster", "Sellout", "Dummy", "Silly", "Bum", "Huckster", "Raconteur", "Mime", "Leaper", "Vaudevillian", "Baboon", "Boor"];

    @override
    List<String> levels =  <String>["PRATFALL PRIEST", "BEAGLE PUSS DARTABOUT"];

    @override
    List<String> interestStrings = <String>["Puppets", "Pranks", "Comedy", "Jokes", "Puns", "Stand-up Comedy", "Humor", "Comics", "Satire", "Knock Knock Jokes"];


    Comedy() : super(0, "Comedy", "funny", "dorky");

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Pies","Pratfalls","Bananas", "Yucks", "Slapstick"])
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Outrun the Imps", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, with no books in it! They manage to get a local ${Quest.CONSORT} to stop ${Quest.CONSORTSOUND}ing long enough to discover that underlings stole all the books. "),
                new Quest("The ${Quest.PLAYER1} has tracked down the book thieves to a nearby dungeon. After some harrowing puzzles and frankly amazing battles, the books are recovered. "),
                new Quest("The ${Quest.CONSORT} librarian is beside himself and cannot stop ${Quest.CONSORTSOUND}ing. The  ${Quest.PLAYER1} is hailed as a local hero for returning the books!  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsSneakyClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Deliever the Message", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, with no books in it! They manage to get a local ${Quest.CONSORT} to stop ${Quest.CONSORTSOUND}ing long enough to discover that the Librarian quit and none of the books have been reshelved. "),
                new Quest("The ${Quest.PLAYER1} decides to volunteer at the library, and beings shelving books. There's a book.  And another book. Oooo, that one looks interesting.... "),
                new Quest("The ${Quest.PLAYER1} has finally shelved the final book!  They are first in line to begin checking things out, too. Books!  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Win the Race", [
                new Quest("The ${Quest.PLAYER1} finds a massive library, filled with books. The ${Quest.CONSORT} librarian offers to help the ${Quest.PLAYER1} search for useful books. "),
                new Quest("The ${Quest.PLAYER1} begins to learn about ${Quest.DENIZEN} and how they have persecuted the ${Quest.CONSORT}s.  "),
                new Quest("The ${Quest.PLAYER1} has read the final book about ${Quest.DENIZEN} and feels much more prepared to face them.  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Clubs","Stages","Comedy", "Microphones", "Laughter", "Standup"])
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Enter the Dungeon", [
                new Quest("The ${Quest.PLAYER1} approaches a dungeon blocked off by a huge boulder. They push and pull at it, but just can't budge it.  A ${Quest.CONSORT} walks by talking about how wimpy and low level the ${Quest.PLAYER1} is. They vow to get STRONGER!. "),
                new Quest("The ${Quest.PLAYER1} has the most bitching training montage of all time, complete with various ${Quest.CONSORT} providing a motivational soundtrack of ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT} dramatically heaves the boulder out of the way. They are now STRONG!  The actual dungeon proves to be a disappointing afterthought.  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Clear the Road", [
                new Quest("The ${Quest.PLAYER1} finds a road blocked by a giant tree. Where did it even come from? There is a pile up of ${Quest.CONSORT} merchants waiting for it to be cleared. "),
                new Quest("The ${Quest.PLAYER1} is tired of waiting. They organize the ${Quest.CONSORT}s into groups, and tries to explain the concept of team work to the. Huh. This is going to take a while. "),
                new Quest("With a triumpant ${Quest.CONSORTSOUND}, the organized ${Quest.CONSORT} pull the fallen tree away from the road with the ${Quest.PLAYER1}'s help.  Everyone can finally get on with their day now!  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Be the Strongest", [
                new Quest("The ${Quest.PLAYER1}  wanders into a bunch of ${Quest.CONSORT} arguing over who the strongest being in the Land is. Wow, they all seem so STRONG! Apparently there is a STRENGTH competition soon? The ${Quest.PLAYER1} enters it, and tries to ignore the snickers of the ${Quest.CONSORT}s. They can get strong, just you wait and see!"),
                new Quest("The ${Quest.PLAYER1} has the most bitching training montage of all time.  They are getting STRONG! "),
                new Quest("It is the day of the STRENGTH competition. The ${Quest.PLAYER1} is the star, it is them.  A ${Quest.CONSORT} puts a gold medal around their neck. Everyone agrees that the ${Quest.PLAYER1} is the strongest."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.HIGH)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Pranks","Mischief","Tricks", "Deceit", "Ruses", "Distactions"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Trick the Villian", [
                new Quest("The ${Quest.PLAYER1}  is approached by a Crafty ${Quest.CONSORT} who offers them a magical ${Quest.PHYSICALMCGUFFIN}, guaranteed to grant them any wish. The ${Quest.PLAYER1} is shocked to discover it was a ruse, and the Crafty ${Quest.CONSORT} has already escaped to the side with their ill earned boonies. "),
                new Quest("The ${Quest.PLAYER1} find many ${Quest.CONSORT}s, too sad to even ${Quest.CONSORTSOUND}, holding ${Quest.PHYSICALMCGUFFIN}.  The Crafty ${Quest.CONSORT} must be stopped!  "),
                new Quest("The has finally caught up with the Crafty ${Quest.CONSORT}.  They thank the confused consort for how much the ${Quest.PHYSICALMCGUFFIN} helped them. Confused, the Crafty ${Quest.CONSORT} offers to buy the ${Quest.PHYSICALMCGUFFIN} back, and is upset when the ${Quest.PLAYER1} refuses. They begin ${Quest.CONSORTSOUND}ing and begging until the ${Quest.PLAYER1} begrudgingly claims that they could be convinced to part with it if a sufficiently valuable offer is made.  The Crafty ${Quest.CONSORT} offers them a comically large bag of boonies, which the ${Quest.PLAYER1} promptly distributes to the swindled consorts.  The ${Quest.PHYSICALMCGUFFIN} working was a ruse all along, and the Crafty ${Quest.CONSORT} is the one who is now tricked.  (That is what the parable is) "),
            ], new FraymotifReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Expose the Ruse", [
                new Quest("A group of ${Quest.CONSORT}s approach the ${Quest.PLAYER1}. Apparently their sports team lost their coach to the ${Quest.DENIZEN} recently, and they need help training for THE BIG GAME. "),
                new Quest("The ${Quest.PLAYER1}  has the worst training montage in all of paradox space as they get their team of shitty ${Quest.CONSORT}s into fighting shape. "),
                new Quest("The ${Quest.CONSORT}s fall over ${Quest.CONSORTSOUND}ing and just...generally being the worst at sports.  Luckily, the opposing team is somehow WORSE at it. The ${Quest.PLAYER1} is pretty nonplussed to win the trophecy, even with all the ${Quest.CONSORT}s cheering and ${Quest.CONSORTSOUND}ing."),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Play the Prank", [
                new Quest("A group of ${Quest.CONSORT}s approach the ${Quest.PLAYER1}. Apparently their sports team lost a member to the ${Quest.DENIZEN} recently, and if they can't replace him in time they can't compete in the TOURNAMENT. The ${Quest.PLAYER1} agrees to join their team before they can even suggest it. Sports!"),
                new Quest("The ${Quest.PLAYER1}  has the best training montage in all of paradox space as they get their team into fighting shape. "),
                new Quest("The ${Quest.PLAYER1} ganks the ${Quest.PHYSICALMCGUFFIN} and steals the big man's thunder. They win all the sports points. They are the star. It is them. Their team of trusty ${Quest.CONSORT}s lifts the ${Quest.PLAYER1} up onto their shoulders. This is the best day of their life."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }
}
