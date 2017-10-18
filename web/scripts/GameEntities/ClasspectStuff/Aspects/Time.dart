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
                new Quest("The ${Quest.PLAYER1} starts messing about with the beating drums of the land. The constant cacophony is kinda getting on their nerves, so, following the advice of some friendly ${Quest.CONSORT}s they try to line the beats up to a more harmonious rhythm. "),
                new Quest("The ${Quest.PLAYER1} messes with time, placing zones of slowed or sped up time by the drums of their land so the beats start landing in something resembling a good beat."),
                new DenizenFightQuest("The ${Quest.PLAYER1} has finally gotten all the drums of their land beating in an awesome rhythm. Except for one. The lair of the ${Quest.DENIZEN} is built right into the loudest drum of all, and it keeps. Beating. Off. Rhythm. Fuck it, it's time to stife!","Theeere we go. The loudest drum is finally on beat. The cacophony is finally defeated. And, you guess, the ${Quest.DENIZEN}. Whatever. ","The beat continues to be cacophonous. "),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);


        addTheme(new Theme(<String>["Progression","Age","Change","Future","Rivers","Possibility","Flow","Streams","Inevitability","Brooks"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CONTEMPLATATIVEFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.NATURESOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Move Forwards, Never Stop", [
                new Quest("There is a babbling brook. A wizened ${Quest.CONSORT} is next to it. The water, he says, moves in only one direction. So, too, must we. The ${Quest.PLAYER1} contemplates this for a while. Is it really a true thing when this game has time travel in it?"),
                new Quest("Days in the past, but not many, the ${Quest.PLAYER1} is exploring. They find the babbling brook and the wizened ${Quest.CONSORT} yet again. He again says that the water flows in only one direction. Irrationally angry, the ${Quest.PLAYER1} yells that it's not true, that this is the second time he's met the wizened ${Quest.CONSORT}. The wizened ${Quest.CONSORT} simply ${Quest.CONSORTSOUND}s mysteriously.  "),
                new Quest("Days in the future, but not enough to catch up to the present, the ${Quest.PLAYER1} is exploring. When they find the babbling brook, the wizened ${Quest.CONSORT} brightens. 'Soon.' he says, 'you will understand that we move in only one direction.'  He gestures downstream 'So too, will you soon have our last conversation. Or, looking another way. Our first.'.  Huh. The ${Quest.PLAYER1} thinks they get it. Time travel or not, they do things in a linear order.  So does the wizened ${Quest.CONSORT}...even if it isn't the same order. "),
                new DenizenFightQuest("Inexorably, the ${Quest.PLAYER1} is back in the present but also far in the future. The wizened ${Quest.CONSORT} has just been slain by the ${Quest.DENIZEN}, mere minutes after their first/last conversation. The ${Quest.PLAYER1} took the consort's advice to heart.  They have been preparing for this fight for a long time, now, going ever forward, but not on the same path in time as everyone else. It is time. ","This was always going to happen.","It's a Time Paradox. Or is it? Did the ${Quest.PLAYER1} know they would be defeated? Did they fight anyways? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}