import "Interest.dart";
import "../../../SBURBSim.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Athletic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.POWER, 2.0, true)]);
    @override
    List<String> handles1 = <String>["kinetic", "muscley", "preening", "mighty", "running", "sporty", "tennis", "hard", "ball", "winning", "trophy", "sports", "physical", "sturdy", "strapping", "hardy", "brawny", "burly", "robust", "strong", "muscular", "phenomenal"];

    @override
    List<String> handles2 =<String>["Swimmer", "Trainer", "Baller", "Handler", "Runner", "Leaper", "Racer", "Vaulter", "Major", "Tracker", "Heavy", "Brawn", "Darter", "Brawler"];

    @override
    List<String> levels = <String>["MUSCLES HOARDER", "BODY BOOSTER"];

    @override
    List<String> interestStrings = <String>["Yoga", "Fitness", "Sports", "Boxing", "Track and Field", "Swimming", "Baseball", "Hockey", "Football", "Basketball", "Weight Lifting"];


    Athletic() :super(4, "Athletic", "athletic", "dumb");


    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Weights","Strength","Barbells", "Muscles", "Dumbbells", "Bodybuilding"])
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Enter the Dungeon", [
                new Quest("The ${Quest.PLAYER1} approaches a dungeon blocked off by a huge boulder. They push and pull at it, but just can't budge it.  A ${Quest.CONSORT} walks by talking about how wimpy and low level the ${Quest.PLAYER1} is. They vow to get STRONGER!. "),
                new Quest("The ${Quest.PLAYER1} has the most bitching training montage of all time, complete with various ${Quest.CONSORT} providing a motivational soundtrack of ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.PLAYER1} dramatically heaves the boulder out of the way. They are now STRONG!  The actual dungeon proves to be a disappointing afterthought.  "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ..addFeature(new PreDenizenQuestChain("Clear the Road", [
                new Quest("The ${Quest.PLAYER1} finds a road blocked by a giant tree. Where did it even come from? There is a pile up of ${Quest.CONSORT} merchants waiting for it to be cleared. "),
                new Quest("The ${Quest.PLAYER1} is tired of waiting. They organize the ${Quest.CONSORT}s into groups, and tries to explain the concept of team work to the. Huh. This is going to take a while. "),
                new Quest("With a triumphant ${Quest.CONSORTSOUND}, the organized ${Quest.CONSORT} pull the fallen tree away from the road with the ${Quest.PLAYER1}'s help.  Everyone can finally get on with their day now!  "),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Be the Strongest", [
                new Quest("The ${Quest.PLAYER1}  wanders into a bunch of ${Quest.CONSORT} arguing over who the strongest being in the Land is. Wow, they all seem so STRONG! Apparently there is a STRENGTH competition soon? The ${Quest.PLAYER1} enters it, and tries to ignore the snickers of the ${Quest.CONSORT}s. They can get strong, just you wait and see!"),
                new Quest("The ${Quest.PLAYER1} has the most bitching training montage of all time.  They are getting STRONG! "),
                new Quest("It is the day of the STRENGTH competition. The ${Quest.PLAYER1} is the star, it is them.  A ${Quest.CONSORT} puts a gold medal around their neck. Everyone agrees that the ${Quest.PLAYER1} is the strongest."),
            ], new FraymotifReward(), QuestChainFeature.playerIsMagicalClass), Feature.HIGH)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Teams","Sports","Balls", "Competition", "Athletics", "Olympians"])
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Save the Sports", [
                new Quest("The ${Quest.PLAYER1} finds a team of underdog ${Quest.CONSORT}s that need to win a SPORTSBALL tournament against underlings in order to save their village. The ${Quest.PLAYER1} agrees to help their noble cause.  "),
                new Quest("The ${Quest.PLAYER1} sees a shady underling offering a comically large sack of boonies to the SPORTS AUTHORITY! Oh no, sports corruption! How will they ever save the village now?  "),
                new Quest("The ${Quest.PLAYER1} exposes the underlings' SPORTSBALL cheating at the most hilarious possible moment. Through the power of true friendship, justice and a heaping helping of montages, the underdog ${Quest.CONSORT} have won the SPORTSBALL tournament."),
            ], new FraymotifReward(), QuestChainFeature.playerIsProtectiveClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Coach the Sports", [
                new Quest("A group of ${Quest.CONSORT}s approach the ${Quest.PLAYER1}. Apparently their sports team lost their coach to the ${Quest.DENIZEN} recently, and they need help training for THE BIG GAME. "),
                new Quest("The ${Quest.PLAYER1}  has the worst training montage in all of paradox space as they get their team of shitty ${Quest.CONSORT}s into fighting shape. "),
                new Quest("The ${Quest.CONSORT}s fall over ${Quest.CONSORTSOUND}ing and just...generally being the worst at sports.  Luckily, the opposing team is somehow WORSE at it. The ${Quest.PLAYER1} is pretty nonplussed to win the trophecy, even with all the ${Quest.CONSORT}s cheering and ${Quest.CONSORTSOUND}ing."),
            ], new FraymotifReward(), QuestChainFeature.playerIsHelpfulClass), Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Win at Sports", [
                new Quest("A group of ${Quest.CONSORT}s approach the ${Quest.PLAYER1}. Apparently their sports team lost a member to the ${Quest.DENIZEN} recently, and if they can't replace him in time they can't compete in the TOURNAMENT. The ${Quest.PLAYER1} agrees to join their team before they can even suggest it. Sports!"),
                new Quest("The ${Quest.PLAYER1}  has the best training montage in all of paradox space as they get their team into fighting shape. "),
                new Quest("The ${Quest.PLAYER1} ganks the ${Quest.PHYSICALMCGUFFIN} and steals the big man's thunder. They win all the sports points. They are the star. It is them. Their team of trusty ${Quest.CONSORT}s lifts the ${Quest.PLAYER1} up onto their shoulders. This is the best day of their life."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}