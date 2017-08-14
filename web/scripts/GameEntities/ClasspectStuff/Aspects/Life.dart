import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Life extends Aspect {

    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Life', 'Demeter', 'Pan', 'Nephthys', 'Ceres', 'Isis', 'Hemera', 'Andhrímnir', 'Agathodaemon', 'Eir', 'Baldur', 'Prometheus', 'Adonis', 'Geb', 'Panacea', 'Aborof', 'Nurgel', 'Adam']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "coaxing the fallow farms of the local consorts into becoming fertile",
        "healing a seemingly endless parade of stricken consorts",
        "finding and rescuing consort children trapped in a burning building"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "using the Denizen's lair to breed thousands of pollinating insects",
        "breeding a strain of plant that spreads across the planet in seconds",
        "terraforming their land to be more suited to their desires",
        "resurrecting an ancient civilization of consorts, complete with buildings and culture"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "defeating an endless array of locust underlings",
        "realizing that Hemera is somehow spawning the endless hoard of locust underlings ",
        "preventing the next generation of locust underlings, thus ending the consort famine"
    ]);

    Life(int id):super(id, "Life", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("hp", 2, true));
        player.associatedStats.add(new AssociatedStat("MANGRIT", 1, true));
        player.associatedStats.add(new AssociatedStat("alchemy", -2, true));
    }
}