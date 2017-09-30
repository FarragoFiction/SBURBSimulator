import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

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
    List<String> symbolicMcguffins = ["doom","rules", "fate", "judgement", "fog", "gas"];

    @override
    List<String> physicalMcguffins = ["doom","bones", "skulls", "mural", "gravestones", "tomes", "tombs"];

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
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.MIN_LUCK, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Doom(int id) :super(id, "Doom", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.doom(s, p);
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Death", "Endings","Mortality", "Graveyards", "Bones", "Funerals","Skulls", "Skeletons","Cemeteries", "Graves", "Tombstones"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Empty the Graves.", [
                new Quest("The ${Quest.PLAYER1} tries posting a letter through the ${Quest.PHYSICALMCGUFFIN} mail system only to find the letter caught in a plug of oil!  ${Quest.DENIZEN} has screwed with the mail system, crippling the ${Quest.CONSORT} economy!"),
                new Quest("The ${Quest.PLAYER1} cleans out oil from the nearby ${Quest.PHYSICALMCGUFFIN}’s, opening up a few more channels between villages. "),
                new Quest("The ${Quest.PLAYER1} gets sick of all the fucking oil in the ${Quest.PHYSICALMCGUFFIN} mail system, and realizes the only way to truly deal with it and to allow information to flow free is to confront ${Quest.DENIZEN}."),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The mail is too vital to the ${Quest.CONSORT}s to risk having them reclog.","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling mail based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Disaster", "Fire", "Ash", "Armageddon", "Apocalypse", "Radiation", "Blight", "Gas", "Poison", "Chlorine"])
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.GUNPOWDERSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CHLORINESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Make This Stupid Planet Habitable", [
                new Quest("The ${Quest.PLAYER1} constructs a little windmill system for a joke, and suddenly an entire village of consorts has grown up around it! The ${Quest.PLAYER1} decides that they should use the winds of their land for more projects. "),
                new Quest("The ${Quest.PLAYER1} starts learning the uses of their lands ${Quest.PHYSICALMCGUFFIN} in manipulation of wind. Their future constructions are going to be amazing. "),
                new Quest("The ${Quest.PLAYER1} uses ${Quest.PHYSICALMCGUFFIN}s to build a massive farming system that harnesses the wind to distribute seeds across the ${Quest.CONSORT} fields. The ${Quest.CONSORT}’s ${Quest.CONSORTSOUND}ing is so joyful it's literally deafening. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the happy wind based farming community. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is finally free to continue improving the land with wind. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Prophecy","Prophets","Fate", "Destiny","Rules","Sound","Judgement","Carvings", "Murals", "Etchings"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISPERSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} is chilling in a ${Quest.CONSORT} village when a FUCK OFF HUGE STORM blows through, destroying the consorts housing. The player learns that ${Quest.DENIZEN} has screwed with the wind system, sending these giant storms at random."),
                new Quest("The ${Quest.PLAYER1} learns of a ${Quest.PHYSICALMCGUFFIN} system that controls the storms of their land. The begin adventuring and solving puzzles to alter the layout of the ${Quest.PHYSICALMCGUFFIN} system so the storms are redirected from consort villages. "),
                new Quest("The ${Quest.PLAYER1} finishes the dungeon that holdS the  ${Quest.PHYSICALMCGUFFIN} system’s control panel, only to find the control room totally empty. They learn that they only needed their own ${Quest.MCGUFFIN} to do control the storms in the first place, and it was inside them all along.  "),
                new DenizenFightQuest(" ${Quest.DENIZEN} arrives to challenge the ${Quest.PLAYER1} storm supremacy. Will the ${Quest.PLAYER1} be able to prove their worth?", "${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has become the storm master. It is them. ","The storm supremacy of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}