import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Music extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.SANITY, 1.0, true), new AssociatedStat(Stats.MAX_LUCK, 1.0, true)]);
    @override
    List<String> handles1 = <String>["musical", "pianist", "melodious", "keyboard", "rhythmic", "singing", "tuneful", "harmonious", "beating", "pitch", "waltzing", "synthesized", "piano", "serenading", "mozarts", "swelling", "staccato", "pianissimo", "monotone", "polytempo"];

    List<String> handles2 = <String>["Siren", "Singer", "Tenor", "Trumpeter", "Baritone", "Dancer", "Ballerina", "Harpsicordist", "Musician", "Lutist", "Violist", "Rapper", "Harpist", "Lyricist", "Virtuoso", "Bass"];

    @override
    List<String> levels =<String>["SINGING SCURRYWORT", "MUSICAL MOPPET"];

    @override
    List<String> interestStrings = <String>["Rap", "Music", "Song Writing", "Musicals", "Dance", "Singing", "Ballet", "Playing Guitar", "Playing Piano", "Mixtapes", "Turntables"];


    Music() :super(1, "Music", "musical", "loud");


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Pianos","Music","Harmony", "Rain", "Songs", "Violins", "Harps","Strings", "Notes", "Violas", "Guitars"])
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.DISCOSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BIRDCONSORT, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("Play the Music", [
                new Quest("The ${Quest.PLAYER1} meets a wise old ${Quest.CONSORT} who tells that the ${Quest.DENIZEN} can only be awoken by the Legendary Hero playing the ${Quest.MCGUFFIN}. Huh. Do you think that's gonna be a thing?"),
                new Quest("The ${Quest.PLAYER1} learns of a series of ${Quest.PHYSICALMCGUFFIN}s that prevent the ${Quest.MCGUFFIN} from being played. Hrmmmm...how are they gonna clear this up?   "),
                new Quest(" The ${Quest.PLAYER1} has finally fixed the ${Quest.PHYSICALMCGUFFIN}. They play the ${Quest.MCGUFFIN} and are dramatically revealed as the Legendary Hero. We are all blown away by this startling revelation. The ${Quest.PLAYER1} was the Hero all along? Wow.")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);


        addTheme(new Theme(<String>["Hymns","Choirs","Chorus", "Voices", "A Capella","Chants"])
            ..addFeature(FeatureFactory.SINGINGSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.BIRDCONSORT, Feature.WAY_HIGH)
            ..addFeature(new PreDenizenQuestChain("Sing the Song", [
                new Quest("A frantic underling run past the  ${Quest.PLAYER1}. In hot pursuit, a ${Quest.CONSORT} yells 'Stop that thief' in betwen ${Quest.CONSORTSOUND}s. Without thinking, the ${Quest.PLAYER1} grabs the underling. The ${Quest.CONSORT} is impressed, and offers the ${Quest.PLAYER1} a job as a deputy police officer. "),
                new Quest("The ${Quest.PLAYER1} is doing their rounds as a deputy police officer. So far, everything is peaceful."),
                new Quest("A missing ${Quest.PHYSICALMCGUFFIN}. Three suspects. A locked door. The ${Quest.PLAYER1} blows everyone away by cracking the case wide open and sending the perpetrator to the slammer. They are promoted from deputy to a full blown detective, which comes with a lot less frequent jobs, but far more prestige. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Beat","Rhythm","Flow", "Raps", "Rhyme", "Grove", "Funk"])
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.MEDIUM)
            ..addFeature(new PreDenizenQuestChain("And It Don't Stop", [
                new Quest("The ${Quest.PLAYER1} finds a crowd of ${Quest.CONSORTSOUND}ing ${Quest.CONSORT}s. They are holding signs with slogans like 'This isn't Fair' and 'Don't be Jerks'. Apparently they have a problem with the upper class ${Quest.CONSORT}s in charge. The ${Quest.PLAYER1} is moved by their plight and agrees to try to help."),
                new Quest("The ${Quest.PLAYER1} meets with the upper class ${Quest.CONSORT}s to try to negotiate a peaceful revolution. Unfortunately, the ${Quest.CONSORT}s refuse to listen to reason, and even call their guards to attack the ${Quest.PLAYER1}. After easily defeating the guards, the ${Quest.PLAYER1} declares war. You cannot stop the fires of Revolution!  "),
                new Quest("It has been a long struggle, but finally the corrupt high class ${Quest.CONSORT}s have been taken prisoner. The common ${Quest.CONSORT}s ${Quest.CONSORTSOUND} and rejoice and declare a national holiday. The rebellion has won!"),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);
    }

}