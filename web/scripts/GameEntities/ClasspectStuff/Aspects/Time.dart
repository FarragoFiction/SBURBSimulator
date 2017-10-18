import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Time extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff0000"
        ..aspect_light = '#FF2106'
        ..aspect_dark = '#AD1604'
        ..shoe_light = '#030303'
        ..shoe_dark = '#242424'
        ..cloak_light = '#510606'
        ..cloak_mid = '#3C0404'
        ..cloak_dark = '#1F0000'
        ..shirt_light = '#B70D0E'
        ..shirt_dark = '#970203'
        ..pants_light = '#8E1516'
        ..pants_dark = '#640707';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Quartz", "Clockwork", "Gears", "Melody", "Cesium", "Clocks", "Ticking", "Beats", "Mixtapes", "Songs", "Music", "Vuvuzelas", "Drums", "Pendulums"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MARQUIS MCFLY", "JUNIOR CLOCK BLOCKER", "DEAD KID COLLECTOR"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Teetotaler", "Traveler", "Tailor", "Taster", "Target", "Teacher", "Therapist", "Testicle"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Time", "Paradox", "Chrono", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift", "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"]);


    @override
    String denizenSongTitle = "Canon"; //a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops);

    @override
    String denizenSongDesc = "  A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Time', 'Ignis', 'Saturn', 'Cronos', 'Aion', 'Hephaestus', 'Vulcan', 'Perses', 'Prometheus', 'Geras', 'Acetosh', 'Styx', 'Kairos', 'Veter', 'Gegute', 'Etu', 'Postverta and Antevorta', 'Emitus', 'Moirai']);


    @override
    List<String> symbolicMcguffins = ["time","speed", "inevitability", "paradoxes", "rhythm"];
    @override
    List<String> physicalMcguffins = ["time","clock", "metronome", "beat", "turntables", "music boxes", "sheet music", "drums", "sundials", "beatbox", "trousers", "river"];


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MIN_LUCK, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.FREE_WILL, -2.0, true)
    ]);

    Time(int id) :super(id, "Time", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.time(s, p);
    }


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Ticking","Watches","Cesium","Pendulums", "Timepieces", "Clocks","Clockwork", "Gears", "Quartz"])
            ..addFeature(FeatureFactory.TICKINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.OILSMELL, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Fix the Clockwork", [
                new Quest("The ${Quest.PLAYER1} is getting sick and tired of the constant grinding of their planet’s clockwork mechanisms. After consulting some ${Quest.CONSORT}s, they set out to fix the ${Quest.PHYSICALMCGUFFIN} points that are causing the grinding."),
                new Quest("The ${Quest.PLAYER1} learns that some of the ${Quest.PHYSICALMCGUFFIN} points don’t actually exist in sync with the timeline, and so they do a whole bunch of bullshit time shenanigans that you really shouldn’t worry about. Trust them, it’s ok. Totally didn’t accidentally violate causality or anything."),
                new Quest("The ${Quest.PLAYER1} has fixed all the ${Quest.PHYSICALMCGUFFIN} points! Except- Oh goddamn it.  ${Quest.DENIZEN} has started screwing up the ${Quest.PHYSICALMCGUFFIN} points all over again! They can’t take this lying down. Or standing up! Or sitting down! Or... this metaphor got away from them."),
                new DenizenFightQuest("The ${Quest.PLAYER1} is ready to face the ${Quest.DENIZEN}. It will never have the chance to mess with the ${Quest.PHYSICALMCGUFFIN} points again!","Ah, the sweet sound of clockwork NOT being broken as fuck.","The ${Quest.PLAYER1} being defeated really grinds my gears.  Get it? Cuz the clockwork is gonna stay broken and annoying sounding until the ${Quest.DENIZEN} is defeated. ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);

        addTheme(new Theme(<String>["Drums", "Beat","Rhythm", "Percussion", "Metronomes"])
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEATSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)

            ..addFeature(new DenizenQuestChain("Synchronize the Rhythm", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Progression","Age","Change","Future","Rivers","Possibility","Flow","Streams","Inevitability","Brooks"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH) //we are laughing at you, asshole.
            ..addFeature(new DenizenQuestChain("Move Forwards, Never Stop", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}