import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class PopCulture extends InterestCategory {
    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.MOBILITY, 2.0, true)]);

    @override
    List<String> handles1 = <String>["bat","worthy", "mega", "player", "mighty", "knightly", "roguish", "super", "turbo", "titanic", "heroic", "bitchin", "power", "wonder", "wonderful", "sensational", "thors", "bat"];

    @override
    List<String> handles2 = <String>["Man","Superhero", "Supervillain", "Hero", "Villain", "Liaison", "Director", "Repeat", "Blockbuster", "Movie", "Mission", "Legend", "Buddy", "Spy", "Bystander", "Talent"];

    @override
    List<String> levels = <String>["TRIVIA SMARTYPANTS", "NIGHTLY NABBER"];

    @override
    List<String> interestStrings = <String>["Irony", "Action Movies", "Superheroes", "Supervillains", "Video Games", "Movies", "Television", "Comic Books", "TV", "Heroes"];


    PopCulture() :super(9, "PopCulture", "geeky", "frivolous");


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Refrances","Memes","Reference", "In Jokes", "Viral Videos", "Dutton", "Stairs"])
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.WAY_HIGH)
            ..addFeature(new PreDenizenQuestChain("Become the Star", [
                new Quest("The ${Quest.PLAYER1} falls down a series of infinite stairs. A local ${Quest.CONSORT} manages to catch a video of it, and it goes viral on ${Quest.MCGUFFIN}tube. This is humiliating."),
                new Quest("Oh look, somebody made a dubstep remix of the ${Quest.PLAYER1} falling down all those goddamned stairs. It REALLY is catchy with all those ${Quest.CONSORTSOUND}s added in."),
                new Quest(" The ${Quest.PLAYER1} decides to own their fame and goes on a ${Quest.CONSORT} talk show to answer questions about those stairs. It turns out nobody warned them about them. There really needs to be, like, a sign or something.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Superheroes","Super Villains","Comics", "Cellshading","Villains"])
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Stop the Villain", [
                new Quest("The ${Quest.PLAYER1} runs towards an explosion in a local ${Quest.CONSORT} village. As they rush to help the injured, a Mysterious ${Quest.CONSORT} in a mask and cape flees the scene. Who was that? "),
                new Quest("The Mysterious ${Quest.CONSORT} turns out to be Professor ${Quest.MCGUFFIN}, a notorious consort Villain. They spred chaos and disastor with their ${Quest.MCGUFFIN} ray. The ${Quest.PLAYER1} vows to stop them. "),
                new Quest(" The ${Quest.PLAYER1} has a dramatic showdown witih Professor ${Quest.MCGUFFIN}, that results in the Villain being knocked unconscious, and taken away by the ${Quest.CONSORT} authorities. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Movies","Popcorn","Theaters", "Screens", "Silver Screens", "Blockbusters", "Cinemas"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Premiere the Movie", [
                new Quest("The ${Quest.PLAYER1} gets a job at the ${Quest.MCGUFFIN} Cinema. A new movie, The Lonely ${Quest.PHYSICALMCGUFFIN} is coming out soon, and ${Quest.CONSORT}s are already lining up. It's going to be busy as fuck. "),
                new Quest("Oh shit, the ${Quest.PLAYER1} learns that The Lonely ${Quest.PHYSICALMCGUFFIN} never was delivered. The ${Quest.CONSORT}s already lined up are close to rioting. The sound of ${Quest.CONSORTSOUND}s is deafening.  A little bit of sleuthing reveals that a group of underlings stole the film and absconded to a local dungeon.  The ${Quest.PLAYER1} prepares to venture inside.    "),
                new Quest(" The ${Quest.PLAYER1}  has finally bested the dungeon, and retrieved the copy of The Lonely ${Quest.PHYSICALMCGUFFIN}. The ${Quest.CONSORT}s lined up cheer and enter the theater. The Lonely ${Quest.PHYSICALMCGUFFIN} has finally begun to play. The ${Quest.PLAYER1} watches, rapt. Such a fantastic movie.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        /*
        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Movies","Popcorn","Theaters", "Screens", "Silver Screens", "Blockbusters"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Premiere the Movie", [
                new Quest("The ${Quest.PLAYER1} "),
                new Quest("The ${Quest.PLAYER1}    "),
                new Quest(" The ${Quest.PLAYER1} ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
            */
    }

}