import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Blood extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#993300"
        ..aspect_light = '#BA1016'
        ..aspect_dark = '#820B0F'
        ..shoe_light = '#381B76'
        ..shoe_dark = '#1E0C47'
        ..cloak_light = '#290704'
        ..cloak_mid = '#230200'
        ..cloak_dark = '#110000'
        ..shirt_light = '#3D190A'
        ..shirt_dark = '#2C1207'
        ..pants_light = '#5C2913'
        ..pants_dark = '#4C1F0D';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Pulse", "Bonds", "Clots", "Bloodlines", "Ichor", "Veins", "Chambers", "Arteries", "Unions"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["FRIEND HOARDER YOUTH", "HEMOGOBLIN", "SOCIALIST BUTTERFLY"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business", "Buyer", "Butler", "Butcher", "Barber", "Bowler", "Belligerent"]);

    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Blood", "Trigger", "Chain", "Flow", "Charge", "Awakening", "Ichorial", "Friendship", "Trusting", "Clotting", "Union", "Bleeding", "Team", "Transfusion", "Pulse", "Sanguine", "Positive", "Negative", "Cruor", "Vim", "Chorus", "Iron", "Ichorial", "Fever", "Heat"]);

    @override
    String denizenSongTitle = "Ballad "; //a song passed over generations in an oral history;

    @override
    String denizenSongDesc = " A sour note is produced. It's the one Agitation plays to make its audience squirm. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Blood', 'Hera', 'Hestia', 'Bastet', 'Bes', 'Vesta', 'Eleos', 'Sanguine', 'Medusa', 'Frigg', 'Debella', 'Juno', 'Moloch', 'Baal', 'Eusebeia', 'Horkos', 'Homonia', 'Harmonia', 'Philotes']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "uniting warring consort nations against a common enemy",
        "organizing 5 bickering consorts long enough to transverse a dungeon with any degree of competence",
        "learning the true meaning of player human disease called friendship"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "undoing the last remnants of Denizen-inflicted emotional damage in the consorts",
        "putting together a crack team of emotionally bonded consorts to help the recovery of their land",
        "weeping tears of joy as their consorts manage to help each other instead of running to a player anytime the smallest thing goes wrong",
        "preaching a resounding message of ‘don't be a total dick all the time’ to a clamoring crowd of consorts"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "convincing the local consorts to rise up against the Denizen",
        "give unending speeches about the power of friendship and how they are all fighting for loved ones back home to confused and impressionable consorts",
        "completely overthrowing the Denizen's underlings in a massive battle"
    ]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.RELATIONSHIPS, 2, true),
        new AssociatedStat(Stats.SANITY, 1, true),
        new AssociatedStat(Stats.MAX_LUCK, -2, true)
    ]);

    Blood(int id) :super(id, "Blood", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.blood(s, p);
    }
}