import 'dart:math' as Math;

import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Doom extends Aspect {
    @override
    double difficulty = 1.0;

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
            ..addFeature(new DenizenQuestChain("Empty the Graves", [
                new Quest(" The ${Quest.PLAYER1} learns of a baslich that has been emptying the graves of the ${Quest.CONSORT}s, who are understandably upset at this disrespect to everything their culture holds dear."),
                new Quest("The ${Quest.PLAYER1} hunts down the baslich, only to discover that it cannot be killed without the use of a mystic ${Quest.PHYSICALMCGUFFIN}. The player begins to search for this totally USEFUL and IMPORTANT item. "),
                new Quest("The ${Quest.PLAYER1} finds the ${Quest.PHYSICALMCGUFFIN}, and slays the baslich, scattering its bones to the winds, which, according to ${Quest.CONSORT} traditions, should summon its master. Uh. Eventually."),
                new DenizenFightQuest("FINALLY, the bones of baslich has summoned it's master, ${Quest.DENIZEN}.","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s are free to bury their dead in peace once again.","The grave robbing of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
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
                new Quest("The ${Quest.PLAYER1} is sick of their stupid uninhabitable planet, and so starts to make sections of it habitable through judicious use of alchemy and ${Quest.PHYSICALMCGUFFIN}s alike. "),
                new Quest("${Quest.CONSORT}s begin to flock to the safe areas that The ${Quest.PLAYER1} constructed, and begin to make tiny villages within the safety of its zones. Precious  ${Quest.PHYSICALMCGUFFIN}s are found in some nearby mines. "),
                new Quest("The ${Quest.PLAYER1} has straight up established a new consort government in the safe zones. This is so deliriously biznasty it threatens the very existence of anything un-nasty in all possible timelines. Alas, while ${Quest.DENIZEN} remains alive, the safe zone will be temporary at best. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the safe zones. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is finally free to continue improving the land. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Prophecy","Prophets","Fate", "Destiny","Rules","Sound","Judgement","Carvings", "Murals", "Etchings"])
            ..addFeature(FeatureFactory.CALMFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISPERSOUND, Feature.WAY_HIGH)
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Learn the Prophecy", [
                new Quest("The ${Quest.PLAYER1} learns from one of their ${Quest.CONSORT}s that there is an ancient prophecy of a ${Quest.MCGUFFIN} plague that is due to kill them all any day now."),
                new Quest("The ${Quest.PLAYER1} gets deep into the nitty gritty of the apocalypse prophecy. They learn that the plague is not technically going to hit the consorts- it's going to hit the bearers of the MAGIC ${Quest.PHYSICALMCGUFFIN}, which currently happens to be the ${Quest.CONSORT}s. "),
                new Quest("The ${Quest.PLAYER1} goes on a daring series of stupid missions to deliver the MAGIC ${Quest.PHYSICALMCGUFFIN} into an underling camp, thereby redirecting the incoming ${Quest.MCGUFFIN} plague into devastating the underlings instead of the ${Quest.CONSORT}s. The underling army is all but decimated, and ${Quest.DENIZEN}’s lair is all but undefended. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} is finally ready to face the ${Quest.DENIZEN}.", "${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}