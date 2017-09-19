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
    List<String> handles = new List<String>.unmodifiable(<String>["Dancer", "Dean", "Decorator", "Deliverer", "Director", "Delegate", "Destined"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Dark", "Broken", "Meteoric", "Diseased", "Fate", "Doomed", "Inevitable", "Doom", "End", "Final", "Dead", "Ruin", "Rot", "Coffin", "Apocalypse", "Morendo", "Smorzando", "~Ath", "Armistyx", "Grave", "Corpse", "Ashen", "Reaper", "Diseased", "Armageddon", "Cursed"]);


    @override
    String denizenSongTitle = "Dirge"; //a song for the dead;

    @override
    String denizenSongDesc = " A slow dirge begins to play. It is the one Death plays to keep in practice. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["doom","rules", "fate", "judgement"];

    @override
    List<String> physicalMcguffins = ["doom","bones", "skulls", "mural"];

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

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2, true),
        new AssociatedStat(Stats.FREE_WILL, 1, true),
        new AssociatedStat(Stats.MIN_LUCK, -1, true),
        new AssociatedStat(Stats.HEALTH, -1, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Doom(int id) :super(id, "Doom", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.doom(s, p);
    }
}