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
    String denizenSongDesc = " A chord begins to echo. It is the one Damnation will play at their brith. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    bool deadpan = true; // heart cares not for your trickster bullshit

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Heart', 'Aphrodite', 'Baldur', 'Eros', 'Hathor', 'Philotes', 'Anubis', 'Psyche', 'Mora', 'Isis', 'Jupiter', 'Narcissus', 'Hecate', 'Izanagi', 'Izanami', 'Ishtar', 'Anteros', 'Agape', 'Peitho', 'Mahara', 'Naidraug', 'Snoitome', 'Walthidian', 'Slanesh', 'Benu']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "providing a matchmaking service for the local consorts (ships guaranteed)",
        "doing battle with shadow clones that are eventually defeated when you accept them as a part of you",
        "correctly picking out which item represents them out of a vault of a thousand bullshit shitty stuffed animals"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "rescuing a copy of themselves from extreme peril",
        "creating clones of themselves to complete a variety of bullshit puzzles and fights",
        "swapping around the souls of underlings, causing mass mayhem",
        "removing the urge to kill from the identity of underlings, rendering them harmless pacifists"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "starting an underground rebel group to free the consorts from the oppressive underling government",
        "having a huge public protest against the underling government, displaying several banned fashion items",
        "convincing the local consorts that the only thing that can stifle their identity is their own fear"
    ]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("RELATIONSHIPS", 1, true),
        new AssociatedStatInterests()
    ]);

    Heart(int id) :super(id, "Heart", isCanon: true);
}