import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Life extends Aspect {

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BRUISE BUSTER","LODESTAR LIFER","BREACHES HEALER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Leader","Lecturer","Liaison","Loyalist","Lyricist"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String> ["Life" ,"Pastoral", "Green", "Relief", "Healing", "Plant", "Vitality", "Growing", "Garden", "Multiplying", "Rising", "Survival", "Phoenix", "Respawn", "Mangrit", "Animato", "Gaia", "Increasing", "Overgrowth", "Jungle", "Harvest", "Lazarus"]);


    @override
    String denizenSongTitle = "Lament" ;//passionate expression of grief. so much life has been lost to SBURB.;

    @override
    String denizenSongDesc =  " A plucked note echos in the stillness. It is the one Desire plays to summon it's audience. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";




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