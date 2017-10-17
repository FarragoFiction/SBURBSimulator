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
            ..addFeature(new PreDenizenQuestChain("Defeat the Army", [
                new Quest("The ${Quest.PLAYER1} learns of a massive underling army approaching in just a few days time. The ${Quest.CONSORT}s are too scared to even ${Quest.CONSORTSOUND}, but the ${Quest.PLAYER1} has seen enough family holiday comedies to know how to prepare for these invaders. "),
                new Quest("The underling army arrives, lead by a single ${Quest.DENIZEN} minion. A hilarious sequence of events (carefully orchestrated by the ${Quest.PLAYER1}) results in the army slipping on banana peels, walking on glass, being set on fire, falling down a seemingly endless set of stairs, and ultimately fleeing the battlefield in confusion and shame. "),
                new Quest("The ${Quest.PLAYER1} attends a touching Christmas themed celebration hosted by the ${Quest.CONSORT}s.  It doesn't matter that it's not remotely Christmas, it's the thought that counts. And it's way better than being Home Alone. (<--this is what the refrance.)  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Clubs","Stages","Comedy", "Microphones", "Laughter", "Standup","Jokes"])
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Win the Laughs", [
                new Quest("The ${Quest.PLAYER1} learns of an Open Mic Nite at the ${Quest.MCGUFFIN} Club. Do they have what it takes to make the toughest crowd in all of Paradox Space laugh? "),
                new Quest("The ${Quest.PLAYER1} is practicing their jokes on a street corner. A few ${Quest.CONSORT}s let out a braying ${Quest.CONSORTSOUND} of laughter, but most seem unimpressed. The ${Quest.PLAYER1} sure has a long way to go. "),
                new Quest("It's finally time for the Open Mic Nite at the ${Quest.MCGUFFIN} Club.! The ${Quest.CONSORT}s seem like a tough crowd, but the ${Quest.PLAYER1} leaves them hysterical with laughter. It's a huge success! "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Pranks","Mischief","Tricks", "Deceit", "Ruses", "Distactions"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CHAMELEONCONSORT, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Trick the Villain", [
                new Quest("The ${Quest.PLAYER1}  is approached by a Crafty ${Quest.CONSORT} who offers them a magical ${Quest.PHYSICALMCGUFFIN}, guaranteed to grant them any wish. The ${Quest.PLAYER1} is shocked to discover it was a ruse, and the Crafty ${Quest.CONSORT} has already escaped to the side with their ill earned boonies. "),
                new Quest("The ${Quest.PLAYER1} finds many ${Quest.CONSORT}s, too sad to even ${Quest.CONSORTSOUND}, holding ${Quest.PHYSICALMCGUFFIN}.  The Crafty ${Quest.CONSORT} must be stopped!  "),
                new Quest("The ${Quest.PLAYER1} has finally caught up with the Crafty ${Quest.CONSORT}.  They thank the confused consort for how much the ${Quest.PHYSICALMCGUFFIN} helped them. Confused, the Crafty ${Quest.CONSORT} offers to buy the ${Quest.PHYSICALMCGUFFIN} back, and is upset when the ${Quest.PLAYER1} refuses. They begin ${Quest.CONSORTSOUND}ing and begging until the ${Quest.PLAYER1} begrudgingly claims that they could be convinced to part with it if a sufficiently valuable offer is made.  The Crafty ${Quest.CONSORT} offers them a comically large bag of boonies, which the ${Quest.PLAYER1} promptly distributes to the swindled consorts.  The ${Quest.PHYSICALMCGUFFIN} working was a ruse all along, and the Crafty ${Quest.CONSORT} is the one who is now tricked.  (That is what the parable is) "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }
}
