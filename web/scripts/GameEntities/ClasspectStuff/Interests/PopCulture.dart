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
        addTheme(new Theme(<String>["Refrances","Memes","Reference", "In Jokes", "Viral Videos", "Dutton"])
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Become the Star", [
                new Quest("The ${Quest.PLAYER1} meets a wise old ${Quest.CONSORT} who tells that the ${Quest.DENIZEN} can only be awoken by the Legendary Hero playing the ${Quest.MCGUFFIN}. Huh. Do you think that's gonna be a thing?"),
                new Quest("The ${Quest.PLAYER1} learns of a series of ${Quest.PHYSICALMCGUFFIN}s that prevent the ${Quest.MCGUFFIN} from being played. Hrmmmm...how are they gonna clear this up?   "),
                new Quest(" The ${Quest.PLAYER1} has finally fixed the ${Quest.PHYSICALMCGUFFIN}. They play the ${Quest.MCGUFFIN} and are dramatically revealed as the Legendary Hero. We are all blown away by this startling revelation. The ${Quest.PLAYER1} was the Hero all along? Wow.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Superheroes","Super Villains","Comics", "Cellshading","Villains"])
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.HIGH)
            ..addFeature(new PreDenizenQuestChain("Stop the Villain", [
                new Quest("The ${Quest.PLAYER1} learns of a lost song, said to contain the power of ${Quest.MCGUFFIN}. Any who can sing it are destined to be strong enough to face the ${Quest.DENIZEN}. "),
                new Quest("The ${Quest.PLAYER1} has been searching high and low, in dungeons, ruins, and villages. Finally, they find a sheet of music that seems the very essence of ${Quest.MCGUFFIN}. They open their mouth to sing it, and realize they can't make a sound. What IS this fresh fuckery?  What kind of song can't be sung?"),
                new Quest("A ${Quest.PHYSICALMCGUFFIN}! That's the key! The ${Quest.PLAYER1} equips it and instantly finds themselves able to sing the ${Quest.MCGUFFIN} song. The burst of music in their chest makes them feel ready to take on anything, but especially the ${Quest.DENIZEN}."),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Movies","Popcorn","Theaters", "Screens", "Silver Screens", "Blockbusters"])
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Premiere the Movie", [
                new Quest("The ${Quest.PLAYER1} is suddenly challenged to a rap off by a particularly Fresh ${Quest.CONSORT}. It's a close one, but the ${Quest.PLAYER1} emerges victorious. It helps that the Fresh ${Quest.CONSORT} kept rhyming ${Quest.CONSORTSOUND} with ${Quest.CONSORTSOUND}."),
                new Quest("The ${Quest.PLAYER1} has apparently gotten a reputation as a rap master. A series of ${Quest.CONSORT}s challenge them to rap offs and get utterly destroyed by the ${Quest.PLAYER1}'s fresh flows. "),
                new Quest("The final challenger, a Sick-Nasty ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. And aura of ${Quest.MCGUFFIN} and fresh beats smothers the area and the raps get hotter and sicker. Finally the Sick-Nasty ${Quest.CONSORT} falters, and misses a beat. The ${Quest.PLAYER1} wins! They are the best rapper in all of Paradox Space! "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}