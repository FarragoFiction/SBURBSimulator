import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Breath extends Aspect {

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business","Biologist","Backpacker","Babysitter","Baker","Balooner","Braid"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String> ["Gale", "Wiznado", "Feather", "Lifting", "Breathless","Jetstream", "Hurricane", "Tornado"," Kansas", "Breat", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"]);


    @override
    String denizenSongTitle = "Refrain ";//cuz canon

    @override
    String denizenSongDesc = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";



    @override
    List<String> denizenNames = new List<String>.unmodifiable(['Breath', 'Ninlil', 'Ouranos', 'Typheus', 'Aether', 'Amun', 'Hermes', 'Shu', 'Sobek', 'Aura', 'Theia', 'Lelantos', 'Keenarth', 'Aeolus', 'Aurai', 'Zephyrus', 'Ventus', 'Sora', 'Htaerb', 'Worlourier', 'Quetzalcoatl']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "putting out fires in consort villages through serendipitous gales of wind",
        "delivering mail through a complicated series of pneumatic tubes",
        "paragliding through increasingly elaborate obstacle courses to become the champion (it is you)"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "riding the wind through the pneumatic system, delivering packages to the local consorts",
        "doing the windy thing to clean up all of the pneumatic system’s leavings. Wow, that’s a lot of junk",
        "soothing the local consorts with a cool summer breeze",
        "whipping up a flurry of wind, the debris of Denizen rampage are blown far into the Outer Rim"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "realizing that the Denizen has thoroughly clogged up the pneumatic system",
        "trying to manually unclog the pneumatic system",
        "using Breath powers to unclog the pneumatic system"
    ]);

    Breath(int id):super(id, "Breath", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("mobility", 2, true));
        player.associatedStats.add(new AssociatedStat("sanity", 1, true));
        player.associatedStats.add(new AssociatedStat("hp", -1, true));
        player.associatedStats.add(new AssociatedStat("RELATIONSHIPS", -1, true)); //somebody pointed out breath seems to destroy connections, sure, i'll roll with it.
    }
}