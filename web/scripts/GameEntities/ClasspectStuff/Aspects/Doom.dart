import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Doom extends Aspect {

    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Doom', 'Hades', 'Achlys', 'Cassandra', 'Osiris', 'Ananke', 'Thanatos', 'Moros', 'Iapetus', 'Themis', 'Aisa', 'Oizys', 'Styx', 'Keres', 'Maat', 'Castor and Pollux', 'Anubis', 'Azrael', 'Ankou', 'Kapre', 'Moros', 'Atropos', 'Oizys', 'Korne', 'Odin']);

    Doom(int id):super(id, "Doom", isCanon:true);

    @override
    void onDeath(Player player) {
        //was in make alive, but realized that this makes doom ghosts way stronger if it's here. powered by DEATH, but being revived.
        //print("doom is powered by their own death: " + this.session.session_id) //omg, they are sayians.
        player.addStat("power", 50);
        player.addStat("hp", Math.max(100, player.getStat("hp"))); //prophecy fulfilled. but hp and luck will probably drain again.
        player.setStat("minLuck", 30); //prophecy fulfilled. you are no longer doomed.
    }
}