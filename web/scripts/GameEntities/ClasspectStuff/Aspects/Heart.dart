import '../../../SBURBSim.dart';
import 'Aspect.dart';

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
}