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
        addTheme(new Theme(<String>["Arts","Craft","Crafting","Making", "Creating", "Building", "Creation"])
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SPIDERCONSORT, Feature.MEDIUM)

            ..addFeature(new DenizenQuestChain("Make the Thing", [
                new Quest("A ${Quest.CONSORT} child tugs on the ${Quest.PLAYER1}'s sleeves and asks if they can make them a picture of a ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} is happy to help! They discover that drawing the picture makes a ${Quest.PHYSICALMCGUFFIN} symbol on the locked ${Quest.DENIZEN}'s lair light up.  Only 99 to go!"),
                new Quest("An entire line of ${Quest.CONSORT} children are ${Quest.CONSORTSOUND}ing excitedly and expecting identical pictures of ${Quest.PHYSICALMCGUFFIN}s.  Some how each picture is harder to make and more agonizingly boring than the one before. The ${Quest.PLAYER1} is getting burnt out. A wizened ${Quest.CONSORT} approaches them. They wonder why the ${Quest.PLAYER1} looks so glum. Don't they enjoy drawing? When the ${Quest.PLAYER1} explains their situation, the wizened ${Quest.CONSORT} wonders if burning themselves out is really required like they think. "),
                new Quest("The ${Quest.PLAYER1} is happily drawing away. Sometimes they draw pictures of ${Quest.PHYSICALMCGUFFIN}s, but it's always in service of some new and interesting idea they want to test out. Often times their pictures don't even involve a ${Quest.PHYSICALMCGUFFIN}. Before they know it, the ${Quest.DENIZEN}'s lair is open. They sketch a few more things to get the ideas on paper before they lose their train of thought, then begin preparing to face the ${Quest.DENIZEN}."),
                new DenizenFightQuest("The ${Quest.DENIZEN} is a smug asshole about how they taught the ${Quest.PLAYER1} a 'lesson' on trying to force creativity.  The ${Quest.PLAYER1} thinks they were just trying to be a dick. They strife.","And THAT is why you don't piss of a creative person.","Shit. Now we're going to have to sit through this exact same strife again in the future. Lame.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Memes", "Remixes","Mashups", "Deconstruction", "Satire"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.STUPIDFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Deconstruct the Satire", [
                new Quest("There is a portrait of the ${Quest.PLAYER1} that some local jokester has vandalized to say 'bluh, bluh, huge bitch'. The ${Quest.PLAYER1} tries not to let it bother them. "),
                new Quest("More and more frequently, the ${Quest.PLAYER1} sees vandalized copies of their portraits. Teen ${Quest.CONSORT}s are even starting to snigger and ${Quest.CONSORTSOUND} when they see them! This cannot stand! They try to tear the vandalized portraits, but it only makes the teen ${Quest.CONSORT}s ${Quest.CONSORTSOUND} harder. "),
                new Quest("In a flash of inspiration, the ${Quest.PLAYER1} publishes art work that consists of 100 different remixed versions of the vandalized portraits. They explore the theme of 'bluh bluh huge bitch' so many times, in so many mediums it stops to even have meaning. In one move, the ${Quest.PLAYER1} has reclaimed the vandals hateful message as their own one of strength. "),
                new DenizenFightQuest("The ${Quest.DENIZEN} is furious that their campaign to discredit the ${Quest.PLAYER1} has failed. They attack the ${Quest.PLAYER1} directly in a blind rage.","Who's the bitch NOW, ${Quest.DENIZEN}.","Shit, that didn't go according to plan.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Clouds","Fog","Mist","Rainbows","Moons","Night","Sleep","Dreams","Haze"])
            ..addFeature(FeatureFactory.SILENCE, Feature.HIGH)
            ..addFeature(FeatureFactory.ECHOSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CONFUSINGFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREATIVEFEELING, Feature.MEDIUM)
            //trying to capture the "don't repeat yourself" of dream.
            ..addFeature(new DenizenQuestChain("Dream the Dream", [
                new Quest("The ${Quest.PLAYER1} is wandering around, as if in a dream. Everything is hazy and confusing. A ${Quest.DENIZEN} Minion wanders by in a ${Quest.MCGUFFIN} ${Quest.PLAYER1} costume and it just seems inevitable.  "),
                new Quest("You are trying to make sense of things. What is going on lately with the land? A ${Quest.CONSORT} is ${Quest.CONSORTSOUND}ing in reverse. Another is in a ${Quest.PHYSICALMCGUFFIN} wig.  "),
                new Quest("A boardroom filled with underlings glares severely at the ${Quest.PLAYER1} when they rudely barge in. Embarassed, they stammer out an apology and leave. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} rides a rubber ducky, which is itself made out of jello. It's obviously time to fight the ${Quest.DENIZEN}.","Oh. It's finally over.","The dream won't end, even if you die in it.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}