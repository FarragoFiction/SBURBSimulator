import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Time extends Aspect {

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Teetotaler","Traveler","Tailor","Taster","Target", "Teacher", "Therapist","Testicle"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String> ["Time","Paradox", "Chrono", "Moment", "Foregone", "Reset", "Endless", "Temporal", "Shenanigans", "Clock", "Tick-Tock", "Spinning", "Repeat", "Rhythm", "Redshift",  "Epoch", "Beatdown", "Slow", "Remix", "Clockwork", "Lock", "Eternal"]);


    @override
    String denizenSongTitle = "Canon" ;//a musical piece in which a section is repeated (but unchanged) at different times, layered until it's unreconizable  (stable time loops);

    @override
    String denizenSongDesc = "  A sun skips on a groove its tracing 'round the earth, the one-two beat Despair plays to turn cause and effect meaningless. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is/was/will be to say on the matter. ";




    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Time', 'Ignis', 'Saturn', 'Cronos', 'Aion', 'Hephaestus', 'Vulcan', 'Perses', 'Prometheus', 'Geras', 'Acetosh', 'Styx', 'Kairos', 'Veter', 'Gegute', 'Etu', 'Postverta and Antevorta', 'Emitus', 'Moirai']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "manipulating the local stock exchange through a series of cunningly disguised time doubles",
        "stopping a variety of disasters from happening before even the first player enters the medium",
        "cheating at obstacle course time trials to get a finishing value of exactly 0.0 seconds"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "securing the alpha timeline and keeping the corpse pile from getting any taller",
        "high fiving themself an hour from now for the amazing job they're going to have done/do with the Hephaestus situation. Time is the best aspect",
        "restoring the consort’s destroyed villages through time shenanigans. The consorts boggle at their newly restored houses",
        "building awesome things way in the past for themselves to find later"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "searching through time for an unbroken legendary piece of shit weapon",
        "realizing that the legendary piece of shit weapon was broken WAY before they got here",
        "alchemizing an unbroken version of the legendary piece of shit weapon to pawn off as the real thing to Hephaestus"
    ]);

    Time(int id):super(id, "Time", isCanon:true);

    @override
    void initAssociatedStats(Player player) {
        player.associatedStats.add(new AssociatedStat("minLuck", 2, true));
        player.associatedStats.add(new AssociatedStat("mobility", 1, true));
        player.associatedStats.add(new AssociatedStat("freeWill", -2, true));
    }
}