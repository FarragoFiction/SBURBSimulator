import '../../../SBURBSim.dart';
import 'Aspect.dart';

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
}