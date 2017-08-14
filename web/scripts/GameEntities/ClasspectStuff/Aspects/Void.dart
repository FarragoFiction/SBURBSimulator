import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Void extends Aspect {

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

    Void(int id):super(id, "Void", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        List<String> allStats = player.allStats()..remove("power")..add("MANGRIT");

        player.associatedStats.add(new AssociatedStat(player.rand.pickFrom(allStats), 3, true)); //really good at one thing
        player.associatedStats.add(new AssociatedStat(player.rand.pickFrom(allStats), -1, true)); //hit to another thing.
        player.associatedStats.add(new AssociatedStat("minLuck", -1, true)); //hit to another thing.
    }
}