import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Heart extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff3399"
        ..aspect_light = '#BD1864'
        ..aspect_dark = '#780F3F'
        ..shoe_light = '#1D572E'
        ..shoe_dark = '#11371D'
        ..cloak_light = '#4C1026'
        ..cloak_mid = '#3C0D1F'
        ..cloak_dark = '#260914'
        ..shirt_light = '#6B0829'
        ..shirt_dark = '#4A0818'
        ..pants_light = '#55142A'
        ..pants_dark = '#3D0E1E';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Little Cubes", "Hats", "Dolls", "Selfies", "Mirrors", "Spirits", "Souls", "Jazz", "Shards", "Splinters"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHARKBAIT HEARTHROB", "FEDORA FLEDGLING", "PENCILWART PHYLACTERY"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Heart", "Hacker", "Harbinger", "Handler", "Helper", "Historian", "Hobbyist"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Heart", "Soul", "Jazz", "Blues", "Spirit", "Splintering", "Clone", "Self", "Havoc", "Noble", "Animus", "Astral", "Shatter", "Breakdown", "Ethereal", "Beat", "Pulchritude"]);


    @override
    String denizenSongTitle = "Leitmotif"; //a musical theme representing a particular character;

    @override
    String denizenSongDesc = " A chord begins to echo. It is the one Damnation will play at their birth. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["heart","identity", "emotions", "core", "beat", "shadow"];

    @override
    List<String> physicalMcguffins = ["heart","doll", "locket", "mirror", "mask", "shades", "sculpture"];

    @override
    bool deadpan = true; // heart cares not for your trickster bullshit

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Heart', 'Aphrodite', 'Baldur', 'Eros', 'Hathor', 'Philotes', 'Anubis', 'Psyche', 'Mora', 'Isis', 'Jupiter', 'Narcissus', 'Hecate', 'Izanagi', 'Izanami', 'Ishtar', 'Anteros', 'Agape', 'Peitho', 'Mahara', 'Naidraug', 'Snoitome', 'Walthidian', 'Slanesh', 'Benu']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.RELATIONSHIPS, 1.0, true),
        new AssociatedStatInterests(true)
    ]);

    Heart(int id) :super(id, "Heart", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.heart(s, p);
    }

    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Shipping","Ports","Ships", "Docks", "Sails", "Matchmaking", "Cupids", "Fleets"])
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Ship All the Ships", [
                new Quest("The ${Quest.PLAYER1} begins constructing an intricate map of all possible relationships and all ideal relationships for a group of consorts. The ${Quest.CONSORT}s have no idea what's coming. "),
                new Quest("The ${Quest.PLAYER1} extends their “shipping grid” to include the entire ${Quest.CONSORT} population, and begins subtly pushing to make these ships a reality. Happy ${Quest.CONSORTSOUND}s ring out through the air.  "),
                new Quest("The ${Quest.PLAYER1} finds the ABSOLUTE BEST SHIP ever, but then realizes that because of some stupid ${Quest.MCGUFFIN} laws put in place by ${Quest.DENIZEN}, the ship will be unable to sail. The player flips their shit and begins preparing for the final battle. THE SHIP WILL SAIL. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new DenizenQuestChain("Flushed Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be getting along well. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a heart symbol on the door. They ignore all common sense and venture inside. Chocolates and roses abound. There is a couch, and a romantic movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!?","Slaying the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new FlushedRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Pitched Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be evenly matched rivals. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new DenizenFightQuest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a spades symbol on the door. They ignore all common sense and venture inside. Non lethal weapons and games abound. There is a couch, and a controversial movie playing. Huh. Oh shit, what is ${Quest.DENIZEN} doing here!? ","Competing to slay the ${Quest.DENIZEN} proves to be the thing that finally pushes the ${Quest.PLAYER1} and ${Quest.PLAYER2} together.","The ${Quest.PLAYER1} and ${Quest.PLAYER2} are stubbornly refusing this ship by getting their asses handed to them by the ${Denizen}.")
            ], new PitchRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ,  Theme.LOW);
    }
}