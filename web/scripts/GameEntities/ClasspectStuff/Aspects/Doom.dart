import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Doom extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#003300"
        ..aspect_light = '#0F0F0F'
        ..aspect_dark = '#010101'
        ..shoe_light = '#E8C15E'
        ..shoe_dark = '#C7A140'
        ..cloak_light = '#1E211E'
        ..cloak_mid = '#141614'
        ..cloak_dark = '#0B0D0B'
        ..shirt_light = '#204020'
        ..shirt_dark = '#11200F'
        ..pants_light = '#192C16'
        ..pants_dark = '#121F10';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Fire", "Death", "Prophecy", "Blight", "Rules", "Prophets", "Poison", "Funerals", "Graveyards", "Ash", "Disaster", "Fate", "Destiny", "Bones"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["APOCALYPSE HOW", "REVELATION RUMBLER", "PESSIMISM PILGRIM"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Dancer", "Dean", "Decorator", "Deliverer", "Director", "Delegate"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Dark", "Broken", "Meteoric", "Diseased", "Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    bool deadpan = true; // Ain't havin' none 'o' that trickster shit
    @override
    bool ultimateDeadpan = true; // now what did I *just* say?!
    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Doom', 'Hades', 'Achlys', 'Cassandra', 'Osiris', 'Ananke', 'Thanatos', 'Moros', 'Iapetus', 'Themis', 'Aisa', 'Oizys', 'Styx', 'Keres', 'Maat', 'Castor and Pollux', 'Anubis', 'Azrael', 'Ankou', 'Kapre', 'Moros', 'Atropos', 'Oizys', 'Korne', 'Odin']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "calculating the exact moment a planet quake will destroy a consort village with enough time remaining to perform evacuation",
        "setting up increasingly complex Rube Goldberg machines to defeat all enemies in a dungeon at once",
        "obnoxiously memorizing the rules of a minigame, and then blatantly  abusing them to achieve an otherwise impossible victory"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "assuring the local consorts that with Denizen's defeat, the prophecy has been avoided",
        "establishing an increasingly esoteric rubric of potential post-Denizen problems and relating them in detail to the consorts. Doom players sure are cheery",
        "inferring the new possibilities of defeat should the local consorts lack vigilance",
        "finding a worryingly complete list of their own future deaths, both potential and definite"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "listening to consorts relate a doomsday prophecy that will take place soon",
        "realizing technicalities in the doomsday prophecy that would allow it to take place but NOT doom everyone",
        "narrowly averting the doomsday prophecy through technicalities, seeming coincidence, and a plan so convoluted that at the end of it no one can be sure the plan actually DID anything"
    ]);

    Doom(int id) :super(id, "Doom", isCanon: true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("alchemy", 2, true));
        player.associatedStats.add(new AssociatedStat("freeWill", 1, true));
        player.associatedStats.add(new AssociatedStat("minLuck", -1, true));
        player.associatedStats.add(new AssociatedStat("hp", -1, true));
    }

    @override
    void onDeath(Player player) {
        //was in make alive, but realized that this makes doom ghosts way stronger if it's here. powered by DEATH, but being revived.
        //print("doom is powered by their own death: " + this.session.session_id) //omg, they are sayians.
        player.addStat("power", 50);
        player.addStat("hp", Math.max(100, player.getStat("hp"))); //prophecy fulfilled. but hp and luck will probably drain again.
        player.setStat("minLuck", 30); //prophecy fulfilled. you are no longer doomed.
    }
}