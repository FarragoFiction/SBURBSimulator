import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Void extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#000066"
        ..aspect_light = '#0B1030'
        ..aspect_dark = '#04091A'
        ..shoe_light = '#CCC4B5'
        ..shoe_dark = '#A89F8D'
        ..cloak_light = '#00164F'
        ..cloak_mid = '#00103C'
        ..cloak_dark = '#00071A'
        ..shirt_light = '#033476'
        ..shirt_dark = '#02285B'
        ..pants_light = '#004CB2'
        ..pants_dark = '#003E91';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Silence", "Nothing", "Void", "Emptiness", "Tears", "Dust", "Night", "[REDACTED]", "???", "Blindness"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["KNOW-NOTHING ANKLEBITER", "INKY BLACK SORROWMASTER", "FISTICUFFSAFICTIONADO"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Vagrant", "Vegetarian", "Veterinarian", "Vigilante", "Virtuoso"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Undefined", "untitled.mp4", "Void", "Disappearification", "Pumpkin", "Nothing", "Emptiness", "Invisible", "Dark", "Hole", "Solo", "Silent", "Alone", "Night", "Null", "[Censored]", "[???]", "Vacuous", "Abyss", "Noir", "Blank", "Tenebrous", "Antithesis", "404"]);


    @override
    String denizenSongTitle = "Silence";

    @override
    String denizenSongDesc = " A yawning silence rings out. It is the NULL Reality sings to keep the worlds on their dance. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Void', 'Selene', 'Erebus', 'Nix', 'Artemis', 'Kuk', 'Kaos', 'Hypnos', 'Tartarus', 'Hœnir', 'Skoll', "Czernobog", 'Vermina', 'Vidar', 'Asteria', 'Nocturne', 'Tsukuyomi', 'Leviathan', 'Hecate', 'Harpocrates', 'Diova']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "destroying and/or censoring embarrassing consort records",
        "definitely doing quests, just...not where we can see them",
        "playing a hilariously fun boxing minigame"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "Wait, yes! The Void player is… nope. They’re gone.",
        "doing something about their land, but it’s difficult to make out.",
        "fixing temples from the ravages of… something? It’s a best guess. Those temples were totally ravaged a minute ago though.",
        "somehow just doing normal quests with no void interference whatsoever. Huh"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "???",
        "[redacted]",
        "[void players, am I right?]"
    ]);

    static List<String> _randomStats = Player.playerStats.toList()
        ..remove("power")
        ..add("MANGRIT");

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStatRandom(_randomStats, 3, true), //really good at one thing
        new AssociatedStatRandom(_randomStats, -1, true), //hit to another thing.
        new AssociatedStat("minLuck", -1, true), //hit to another thing.
        new AssociatedStat("sburbLore", 0.25, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Void(int id) :super(id, "Void", isCanon: true);
}