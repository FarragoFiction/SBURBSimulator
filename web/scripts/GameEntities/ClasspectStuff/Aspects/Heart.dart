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

        addTheme(new Theme(<String>["Spirits","Souls","Jazz", "Havoc", "Blues", "Cores", "Prohibition", "Noir"])
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Find Yourself.", [
                new Quest("The ${Quest.PLAYER1}, guided by a ${Quest.CONSORT} assembles some of the scattered pieces of their land into a sort of safe space. It’s nice, but something's just… off about it."),
                new Quest("The ${Quest.PLAYER1} grows obsessed with perfecting ‘their space’ and begins manically collecting more and more of the landscape to decorate their ‘area’. They’ve become convinced that if they can only make it perfect, everything will be all right. If they can just make themselves better..."),
                new Quest("The ${Quest.PLAYER1}realizes all the things they were adding to the space was nothing more than junk and clutter. They realize they can’t make themselves better by simply accumulating more onto themselves. They have to confront the root of the problem. For the specific problem of ‘their space,’ they have to confront ${Quest.DENIZEN}."),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. They can finally be free to just....be themselves as long as the ${Quest.DENIZEN} is gone. ","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won and finally feels free to be themselves for the first time.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Dolls", "Voodoo", "Doppelgangers", "Copies", "Puppets","Selfies","Mirrors","Poppets","Mirrors", "Crystals","Shards"])
            ..addFeature(FeatureFactory.LAUGHINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FOOTSTEPSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Confront yourself.", [
                new Quest("The ${Quest.PLAYER1} is just going through their land when they get ambushed by a  copy of themselves made of ${Quest.PHYSICALMCGUFFIN}! The player barely gets away with their life! "),
                new Quest("The ${Quest.PLAYER1} skirmishes with the ${Quest.PHYSICALMCGUFFIN} copy a few times. The ${Quest.PHYSICALMCGUFFIN} copy begins to berate the player about their moral failings and weaknesses."),
                new Quest("The ${Quest.PLAYER1} realizes that the ${Quest.PHYSICALMCGUFFIN} copy is nothing more then an expresion of their own worst feelings, manifested by  ${Quest.DENIZEN}. They confront the copy one last time, and accept it as part of themselves. The two fuse, with a single, small ${Quest.PHYSICALMCGUFFIN} the only physical remnant of the copy. Armed with their new self actualization, they realize they are ready to face ${Quest.DENIZEN}. "),
                new DenizenFightQuest("${Quest.DENIZEN} has been the cause of so much personal grief for the ${Quest.PLAYER1}.  There can be no mercy. ","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is victorious. ","The assholeness of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Shipping","Ports","Ships", "Docks", "Sails", "Matchmaking", "Cupids", "Fleets"])
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SALTSMELL, Feature.HIGH)
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