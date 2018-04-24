import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Mind extends Aspect {

    //what sort of quests rewards do I get?
    @override
    double itemWeight = 0.3;
    @override
    double fraymotifWeight = 0.3;
    @override
    double companionWeight = 1.00; //manipulate others

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
    List<String> physicalMcguffins = ["mind","coin", "plan", "mask", "map", "brain", "circuit"];

    @override
    void initializeItems() {
        items = new WeightedList<Item>()
            ..add(new Item("Puzzle Box",<ItemTrait>[ItemTraitFactory.WOOD, ItemTraitFactory.ASPECTAL, ItemTraitFactory.MAGICAL],shogunDesc: "13x13 Rubix Cube", abDesc: "Don't let Mind players fool you. It's not about smarts."))
            ..add(new Item("Tesla Coil",<ItemTrait>[ItemTraitFactory.ZAP, ItemTraitFactory.ASPECTAL,ItemTraitFactory.METAL],shogunDesc: "Lightning Weiner",abDesc:  "Mind is electric shit. I guess."))
            ..add(new Item("Coin",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL],shogunDesc: "Official Minted Shogun Coin Circa. 1764",abDesc:  "Luck doesn't even matter, so neither does this coin. Mind players are such hams."))
            ..add(new Item("Electronic Door",<ItemTrait>[ItemTraitFactory.METAL, ItemTraitFactory.ASPECTAL,ItemTraitFactory.ZAP, ItemTraitFactory.SMART],shogunDesc: "Star Wars Force Activated Door",abDesc:"I guess it has buttons and shit? I bet it leads somewhere weird."))
            ..add(new Item("Janus Bust",<ItemTrait>[ItemTraitFactory.UNCOMFORTABLE,ItemTraitFactory.BUST, ItemTraitFactory.STONE,ItemTraitFactory.CLASSY,ItemTraitFactory.ASPECTAL,ItemTraitFactory.LEGENDARY, ItemTraitFactory.ZAP],shogunDesc: "Bust of A Giant Phallic Asshole",abDesc:"So is the joke that Mind Players are two faced?"));
    }

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.FREE_WILL, 2.0, true),
        new AssociatedStat(Stats.MIN_LUCK, 1.0, true),
        new AssociatedStat(Stats.ALCHEMY, -2.0, true) //too many choices, freeze up
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

            ..addFeature(new DenizenQuestChain("Change the View", [
                new Quest("The ${Quest.PLAYER1} finds themselves trapped in a dark labyrinth. After travelling through for some time they have come to realize the walls change position when they leave an area. Although ${Quest.CONSORT}s are wandering around the maze they give riddle-like responses on how to escape. The ${Quest.PLAYER1} will need to find a way to solve the many hidden logic problems to escape the ever-changing paths. It's easy enough to leave when they want, but they want to WIN."),
                new Quest("The ${Quest.PLAYER1} returns to the labrinth to get help from one ${Quest.CONSORT} to try to understand the puzzle.It gave a slightly less confusing answer to look another way. The ${Quest.PLAYER1} decides to listen to all of the ${Quest.CONSORT}s answers however confusing that they are."),
                new Quest("With each answer written down, the ${Quest.PLAYER1} begins to piece together the parts of the answer. They will need all the mental prowess to crack this one, and finally reach the end of the Labrinth."),
                new DenizenFightQuest("After hours of putting different spins on each sentence, the ${Quest.PLAYER1} finally solves the riddle. But they aren’t quite done yet. A considerate ${Quest.CONSORT} directs the ${Quest.PLAYER1} to a small gap between two or the walls that leads to a puzzle room. The ${Quest.PLAYER1} spots a mirror on the far wall and presses the side of it. The mirror reflects light which the ${Quest.PLAYER1} uses to hit the right targets in the right order. After putting the pattern in, the mirror slid away and opened a view to the outside fields which let the ${Quest.PLAYER1} escape. Or that WOULD be what happens if the shitty ${Quest.DENIZEN} wasn't blocking their path.", "Okay. With the defeat of the ${Quest.DENIZEN}, NOW they finally escape from that labrinth.","Oh my fucking god, they better not have to redo that entire labrinth if they are ever back here.")
            ], new DenizenReward(), QuestChainFeature.playerIsSmartClass), Feature.HIGH)


            ..addFeature(new DenizenQuestChain("Pick a Door, any Door", [
                new Quest("The ${Quest.PLAYER1} boggles vacantly at an entire labrinth of doors. Whole walls are nothing but doors and their frames, with seemingly no rhyme or reason. A nearby ${Quest.CONSORT} explains that at the end of the Labrinth is the ${Quest.DENIZEN}. If the ${Quest.PLAYER1} wants to beat their land, they will have to figure out this Labrinth.  They are given a ball of yarn so they can easily resume their place in the Labrinth when they need to take breaks."),
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