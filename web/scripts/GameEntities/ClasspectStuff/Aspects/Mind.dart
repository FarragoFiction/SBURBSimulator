import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Mind extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#3da35a"
        ..aspect_light = '#06FFC9'
        ..aspect_dark = '#04A885'
        ..shoe_light = '#6E0E2E'
        ..shoe_dark = '#4A0818'
        ..cloak_light = '#1D572E'
        ..cloak_mid = '#164524'
        ..cloak_dark = '#11371D'
        ..shirt_light = '#3DA35A'
        ..shirt_dark = '#2E7A43'
        ..pants_light = '#3B7E4F'
        ..pants_dark = '#265133';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Thought", "Rationality", "Decisions", "Consequences", "Choices", "Paths", "Trails", "Trials"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["NIPPER-CADET", "COIN-FLIPPER CONFIDANTE", "TWO-FACED BUCKAROO"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Man","Machine", "Magician", "Magistrate", "Mechanic", "Mediator", "Messenger"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Mind", "Modulation", "Shock", "Awe", "Coin", "Judgement", "Mind", "Decision", "Spark", "Path", "Trial", "Variations", "Thunder", "Logical", "Telekinetic", "Brainiac", "Hysteria", "Deciso", "Thesis", "Imagination", "Psycho", "Control", "Execution", "Bolt"]);


    @override
    String denizenSongTitle = "Fugue"; //a musical core that is altered and changed and interwoven with itself. Also, a mental state of confusion and lo

    @override
    String denizenSongDesc = " A fractured chord is prepared. It is the one Regret plays to make insomnia reign. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Mind', 'Athena', 'Forseti', 'Janus', 'Anubis', 'Maat', 'Seshat', 'Thoth', 'Jyglag', 'Peryite', 'Nomos', 'Lugus', 'Sithus', 'Dike', 'Epimetheus', 'Metis', 'Morpheus', 'Omoikane', 'Argus', 'Hermha', 'Morha', 'Sespille', 'Selcric', 'Tzeench']);


    @override
    List<String> symbolicMcguffins = ["mind","decisions", "consequences", "free will", "path", "neurons", "causality"];
    @override
    List<String> physicalMcguffins = ["mind","coin", "plans", "mask", "map", "brain", "circuit"];



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.MIN_LUCK, 1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.MAX_LUCK, -1.0, true) //LUCK DO3SN'T M4TT3R!!!
    ]);

    Mind(int id) :super(id, "Mind", isCanon: true);
    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.mind(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Decisions","Choices", "Paths", "Passages", "Dead Ends","Trails", "Doors", "Possibilities", "Alternatives","Labrinths","Mazes"])
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Pick a Door, any Door", [
                new Quest("The ${Quest.PLAYER1} boggles vacantly at an entire labrinth of doors. Whole walls are nothing but doors and their frames, with seemingly no rhyme or reason. A nearby ${Quest.PLAYER1} explains that at the end of the Labrinth is the ${Quest.DENIZEN}. If the ${Quest.PLAYER1} wants to beat their land, they will have to figure out this Labrinth.  They are given a ball of yarn so they can easily resume their place in the Labrinth when they need to take breaks."),
                new Quest("Left. Right. Both choices look just as good as each other. A wrong choice could waste hours.  The ${Quest.PLAYER1} feels the weight on their shoulders, and then picks left.  Hours later, they encounter a brick wall. God DAMN it."),
                new Quest("Another set of two possible choices which seem to obviously have huge consequences. And yet....this time one of them just seems more....right? Like it's obvious that it's better. Huh.   Hours later, the ${Quest.PLAYER1} encounter another wall of doors, these ones with less feeling of weight. Hell yes! "),
                new DenizenFightQuest("The final door is passed. The ${Quest.DENIZEN} is revealed.  The choice here is an easy one, it is time to strife!","The bullshit labrinth is finally complete.","Oh GOD DAMN IT. Now the ${Quest.PLAYER1} has to walk all the way back here to restart the fight.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Consequences", "Results","Karma", "Justice","Responsibility", "Payback", "Vengence"])
            ..addFeature(FeatureFactory.DRAGONCONSORT, Feature.LOW)
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Face the Music", [
                new Quest("The ${Quest.DENIZEN} has commited a staggering amount of crimes against the local ${Quest.CONSORT} population. The natural result of this is that karma itself is conspiring for their downfall. The ${Quest.PLAYER1} knows that Justice is on their side."),
                new Quest("The ${Quest.DENIZEN} may FEEL safe, all sequestered away in their shitty snake lair, but they aren't. The ${Quest.PLAYER1} convinces a group of underlings lead by a ${Quest.DENIZEN} minion that the ${Quest.DENIZEN} is a huge jerk who shouldn't be in charge of them. It's easy, because it's true. That's what happens when you are a huge jerk."),
                new Quest("Huh.  I WONDER what the consequences are of the ${Quest.DENIZEN} being stuck hiding in their shitty snake lair while the ${Quest.PLAYER1} is running a propoganda campaign against them?  Suddenly the ${Quest.DENIZEN} has run out of allies entirely."),
                new DenizenFightQuest("Karma is a bitch. The ${Quest.DENIZEN} has nowhere to run when the ${Quest.PLAYER1} comes for them. It's time to strife.","Justice is served.","Has Justice truly been perverted?")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Thought","Logic","Connections","Neurons","Psychics","Subconsciousness","Intuition","Sparks", "Lightning", "Electricity"])
            ..addFeature(FeatureFactory.OZONESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Make the Connections", [
                new Quest("The ${Quest.PLAYER1} stares at the puzzle blocks in a dungeon. One of them doesn't belong. But which? The Dog? The Bull? The Feather? The Cat? The ${Quest.PLAYER1} thinks, then makes the logical selection.  The Dungeon accepts it."),
                new Quest("Another dungeon. A cat. A swan. A robot. A virus. Huh. This one is harder. The ${Quest.PLAYER1} thinks about it for a while, and then goes with their intuition.  The Dungeon accepts it.  "),
                new Quest("In the newest dungeon, there are 4 geometric shapes on the puzzle blocks. One of them doesn't belong. The ${Quest.PLAYER1} thinks they understand. Their choice is accepted."),
                new DenizenFightQuest("It's the final door before facing the ${Quest.DENIZEN}. All four puzzles blocks are simply identical images of ${Quest.PHYSICALMCGUFFIN}. The ${Quest.PLAYER1} closes their eyes. They think about the previous puzzles, and the patterns that came out of their choices. They choose.  The door opens. It is time to strife ${Quest.DENIZEN}.","Finally. The ${Quest.PLAYER1} can stop solving bullshit 'logic' puzzles that keep straying into weird intuition mind reading bullshit.","Looks like the ${Quest.PLAYER1} will have to resolve some of those bullshit puzzles.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }

}