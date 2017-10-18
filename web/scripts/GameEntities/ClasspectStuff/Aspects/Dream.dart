import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Dream extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9630BF"
        ..aspect_light = '#cc87e8'
        ..aspect_dark = '#9545b7'
        ..shoe_light = '#ae769b'
        ..shoe_dark = '#8f577c'
        ..cloak_light = '#9630bf'
        ..cloak_mid = '#693773'
        ..cloak_dark = '#4c2154'
        ..shirt_light = '#fcf9bd'
        ..shirt_dark = '#e0d29e'
        ..pants_light = '#bdb968'
        ..pants_dark = '#ab9b55';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Dreams", "Nightmares", "Clouds", "Obsession", "Glass", "Memes", "Chess", "Creation", "Singularity", "Perfection", "Sleep", "Pillows","Clouds", "Clay", "Putty", "Art", "Design", "Dreams", "Repetition", "Creativity", "Imagination", "Plagerism"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["ADHDLED YOUTH", "LUCID DREAMER", "LUCID DREAMER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dreamer", "Dilettante", "Designer", "Delusion", "Dancer", "Doormat", "Decorator", "Delirium", "Disaster", "Disorder"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lunar", "Lucid",  "Prospit", "Derse", "Dream", "Creative", "Imagination"]);

    @override
    List<String> symbolicMcGuffins = ["dreams","creativity", "obsession", "art"];
    @override
    List<String> physicalMcguffins = ["dreams","dream catcher", "sculpture", "painting", "sketch"];


    @override
    String denizenSongTitle = "Fantasia"; //a musical theme representing a particular character;

    @override
    String denizenSongDesc = " An orchestra begins to tune up. It is the one Obsession will play to celebrate. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    bool deadpan = false;

    @override  //muse names
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Dream', 'Dreamer','Calliope', 'Clio', 'Euterpe', 'Thalia', 'Melpomene', 'Terpsichore', 'Erato', 'Polyhmnia', 'Urania', 'Melete', 'Mneme', 'Aoide','Hypnos', 'Morpheus','Oneiros','Phobetor','Icelus', 'Somnus','Metztli','Yohualticetl','Khonsu','Chandra', 'Mėnuo','Nyx']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.SANITY, -2.0, true)
    ]);

    Dream(int id) :super(id, "Dream", isCanon: false);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.dream(s, p);
    }

    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Nothing","Void","Emptiness","Dust", "Shadows", "Nowhere", "Absence"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Go to Nowhere", [
                new Quest("The ${Quest.PLAYER1} has wandered around for hours and has found nothing new to do. There is NO way this is the end of the land. What is going on?"),
                new Quest("Huh....what....what is this area of a wall that looks....a little different? Like the shadows aren't falling right on it? The ${Quest.PLAYER1} leans against it and stumbles into a ...weirdly hard to see area. Huh. The ${Quest.PLAYER1} wonders if maybe the rest of their quests are in places like this?"),
                new Quest("Holy FUCK that was the BEST dungeon of ALL TIME!!!  The ${Quest.PLAYER1} sure feels bad for anybody who missed it.  Just, that TWIST at the end, man. So great."),
                new DenizenFightQuest("You're....really having trouble following what's going on. The ${Quest.PLAYER1} emerges from one of those glitchy areas you can't see into, obviously fighting the ${Quest.DENIZEN}. What the fuck is even happening!? ","The ${Quest.PLAYER1} won!  That's....GOOD, you think. The ${Quest.DENIZEN} was probably an asshole.","The ${Quest.PLAYER1} lost.  That's....BAD, you think. The ${Quest.DENIZEN} is probably an asshole.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["???", "[REDACTED]","[CENSORED]", "Censorship", "Conspiracies"])
            ..addFeature(FeatureFactory.SILENCE, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("[REDACTED]", [
                new Quest("Apparently the denizen [REDACTED] has been [REDACTED]ing all the [REDACTED] and everyone is starting to get a little pissed at them. Can the ${Quest.PLAYER1} help? "),
                new Quest("The ${Quest.PLAYER1} [REDACTED]s and it actually works! Everyone ${Quest.CONSORTSOUND} in surprise. This might just be crazy enough to work."),
                new Quest("Wait, who would have thought that the [REDACTED] would be weak to [REDACTED]??? This is officially the dumbest fight in all of Paradox Space."),
                new DenizenFightQuest("It's time to fight the [REDACTED] for real this time. Their reign of [REDACTED] will finally be at an end.","The ${Quest.DENIZEN} is defeated. FINALLY they can stop censoring everything on this stupid planet, especially ${Quest.CONSORT}s.","[REDACTED]")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Silence","Blindness","Deafness","Blindfolds","Earplugs","Sensory Deprivation"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NOTHINGSMELL, Feature.HIGH)
        //could make the default quest a knight/page quest in second pass. fighting with nothingness as an enemy and fighting with nothingness as a weapon and all
            ..addFeature(new DenizenQuestChain("Walk of Faith", [
                new Quest("Suddenly the ${Quest.PLAYER1} can't see or hear. Oh god, what is going on?  They feel around in close to a panic, until they find a button. After a moments deliberation, they press it. Suddenly they can see and hear again. Huh."),
                new Quest("The ${Quest.PLAYER1} sees a red button at the other end of a cluttered hallway, inside a dungeon. Their bad feeling is confirmed when they suddenly can't see or hear again. After many stubbed toes and bruised shins, they finally make it to the button and press it to regain their senses."),
                new Quest("The newest button is in the middle of a single large room with pitfall traps scattered throughout and underlings to boot. Are you fucking kdiding me!? When the ${Quest.PLAYER1} loses their senses, they seriously consider just sitting down and seeing if it wears off, but those underlings would probably attack in the mean time. The ${Quest.PLAYER1} begins slowly making their way towards the button. Half way through, they realize with a start that the Underlings haven't tried to attack them. Huh.   When they finally press the button, the Underlings suddenly whirl to face them. Were they...INVISIBLE while they were blind? It's short work to defeat the underlings."),
                new Quest("Faced with a huge underling that is probably too high a level to fight, the ${Quest.PLAYER1} is struck with sudden inspiration. They blindfold themselves and do their best to block out their ability to hear, as well. They make their way to where the giant Underling was and begin to strife them. When they stop being aware of flailing, they remove their blindfold and find the giant Underling has become a giant pile of grist. HELL YES, VOID POWERS RULE!!!  "),
                new DenizenFightQuest("The ${Quest.PLAYER1} attempts to sneak up on the ${Quest.DENIZEN} while blindfolded. It dodges. Oh well, guess you can't out-void a Void boss.  Time for a regular strife!","The ${Quest.PLAYER1} has defeated the major challenge of their land.","The ${Quest.PLAYER1} is going to have to try again.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}