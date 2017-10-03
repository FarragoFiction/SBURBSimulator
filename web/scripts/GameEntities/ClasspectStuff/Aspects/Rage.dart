import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Rage extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#9900cc"
        ..aspect_light = '#974AA7'
        ..aspect_dark = '#6B347D'
        ..shoe_light = '#3D190A'
        ..shoe_dark = '#2C1207'
        ..cloak_light = '#7C3FBA'
        ..cloak_mid = '#6D34A6'
        ..cloak_dark = '#592D86'
        ..shirt_light = '#381B76'
        ..shirt_dark = '#1E0C47'
        ..pants_light = '#281D36'
        ..pants_dark = '#1D1526';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Mirth", "Whimsy", "Madness", "Impossibility", "Chaos", "Hate", "Violence", "Joy", "Murder", "Noise", "Screams", "Denial"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["MOPPET OF MADNESS", "FLEDGLING HATTER", "RAGAMUFFIN REVELER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Raconteur", "Reveler", "Reader", "Reporter", "Racketeer"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Rage", "Barbaric", "Impossible", "Tantrum", "Juggalo", "Horrorcore", "Madness", "Carnival", "Mirthful", "Screaming", "Berserk", "MoThErFuCkInG", "War", "Haze", "Murder", "Furioso", "Aggressive", "ATBasher", "Violent", "Unbound", "Purple", "Unholy", "Hateful", "Fearful", "Inconceivable", "Impossible"]);


    @override
    String denizenSongTitle = " Aria"; // a musical piece full of emotion;

    @override
    String denizenSongDesc = " A hsirvprmt xslri begins to tryyvi. It is the one Madness plays gl pvvk rgh rmhgifnvmg rm gfmv. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And yes, The OWNER know you're watching them. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Rage', 'Ares', 'Dyonisus', 'Bacchus', 'Abbadon', 'Mammon', 'Mania', 'Asmodeus', 'Belphegor', 'Set', 'Apophis', 'Nemesis', 'Menoetius', 'Shogorath', 'Loki', 'Alastor', 'Mol Bal', 'Deimos', 'Achos', 'Pallas', 'Deimos', 'Ania', 'Lupe', 'Lyssa', 'Ytilibatsni', 'Discord']);

    @override
    List<String> symbolicMcguffins = ["rage","sanity", "power", "whimsy", "impossible", "screams", "laughter", "madness"];
    @override
    List<String> physicalMcguffins = ["rage","face paint", "script", "bike horn", "war mask", "murder weapon", "loud speaker", "bullhorn", "broken machine"];


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.POWER, 2.0, true),
        new AssociatedStat(Stats.MOBILITY, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.01, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Rage(int id) :super(id, "Rage", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.rage(s, p);
    }
}