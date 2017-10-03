import '../../../SBURBSim.dart';
import 'Aspect.dart';

class Life extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#494132"
        ..aspect_light = '#76C34E'
        ..aspect_dark = '#4F8234'
        ..shoe_light = '#00164F'
        ..shoe_dark = '#00071A'
        ..cloak_light = '#605542'
        ..cloak_mid = '#494132'
        ..cloak_dark = '#2D271E'
        ..shirt_light = '#CCC4B5'
        ..shirt_dark = '#A89F8D'
        ..pants_light = '#A29989'
        ..pants_dark = '#918673';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Dew", "Spring", "Beginnings", "Vitality", "Jungles", "Swamps", "Gardens", "Summer", "Chlorophyll", "Moss", "Rot", "Mold"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BRUISE BUSTER", "LODESTAR LIFER", "BREACHES HEALER"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Leader", "Lecturer", "Liaison", "Loyalist", "Lyricist"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Life", "Pastoral", "Green", "Relief", "Healing", "Plant", "Vitality", "Growing", "Garden", "Multiplying", "Rising", "Survival", "Phoenix", "Respawn", "Mangrit", "Animato", "Gaia", "Increasing", "Overgrowth", "Jungle", "Harvest", "Lazarus"]);


    @override
    String denizenSongTitle = "Lament"; //passionate expression of grief. so much life has been lost to SBURB.;

    @override
    String denizenSongDesc = " A plucked note echos in the stillness. It is the one Desire plays to summon it's audience. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["life","health", "growth", "strength","tree", "forest"];
    @override
    List<String> physicalMcguffins = ["life","plant", "fertilizer", "food","flowers", "beast", "fruit", "baby", "puppy", "candy"];


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Life', 'Demeter', 'Pan', 'Nephthys', 'Ceres', 'Isis', 'Hemera', 'Andhrímnir', 'Agathodaemon', 'Eir', 'Baldur', 'Prometheus', 'Adonis', 'Geb', 'Panacea', 'Aborof', 'Nurgel', 'Adam']);



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.HEALTH, 2.0, true),
        new AssociatedStat(Stats.POWER, 1.0, true),
        new AssociatedStat(Stats.ALCHEMY, -2.0, true)
    ]);

    Life(int id) :super(id, "Life", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.life(s, p);
    }
}