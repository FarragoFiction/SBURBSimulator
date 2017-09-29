import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Breath extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#3399ff"
        ..aspect_light = '#10E0FF'
        ..aspect_dark = '#00A4BB'
        ..shoe_light = '#FEFD49'
        ..shoe_dark = '#D6D601'
        ..cloak_light = '#0052F3'
        ..cloak_mid = '#0046D1'
        ..cloak_dark = '#003396'
        ..shirt_light = '#0087EB'
        ..shirt_dark = '#0070ED'
        ..pants_light = '#006BE1'
        ..pants_dark = '#0054B0';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Wind", "Breeze", "Zephyr", "Gales", "Storms", "Planes", "Twisters", "Hurricanes", "Gusts", "Windmills", "Pipes", "Whistles"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["BOY SKYLARK", "SODAJERK'S CONFIDANTE", "MAN SKYLARK"]);


    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Business", "Biologist", "Backpacker", "Babysitter", "Baker", "Balooner", "Braid"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Gale", "Wiznado", "Feather", "Lifting", "Breathless", "Jetstream", "Hurricane", "Tornado", " Kansas", "Breat", "Breeze", "Twister", "Storm", "Wild", "Inhale", "Windy", "Skylark", "Fugue", "Pneumatic", "Wheeze", "Forward", "Vertical", "Whirlwind", "Jetstream"]);


    @override
    String denizenSongTitle = "Refrain "; //cuz canon

    @override
    String denizenSongDesc = " A haunting refrain begins to play. It is the one Desolation plays to keep its instrument in tune. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";

    @override
    List<String> symbolicMcguffins = ["breath","mobility", "freedom", "motivation", "direction", "wind"];

    @override
    List<String> physicalMcguffins = ["breath","wind", "key", "pipes", "hurricane", "horn", "bicycle", "wheels"];

    @override
    List<String> denizenNames = new List<String>.unmodifiable(['Breath', 'Ninlil', 'Ouranos', 'Typheus', 'Aether', 'Amun', 'Hermes', 'Shu', 'Sobek', 'Aura', 'Theia', 'Lelantos', 'Keenarth', 'Aeolus', 'Aurai', 'Zephyrus', 'Ventus', 'Sora', 'Htaerb', 'Worlourier', 'Quetzalcoatl']);

    @override
    List<String> preDenizenQuests = new List<String>.unmodifiable(<String>[
        "putting out fires in consort villages through serendipitous gales of wind",
        "delivering mail through a complicated series of pneumatic tubes",
        "paragliding through increasingly elaborate obstacle courses to become the champion (it is you)"
    ]);
    @override
    List<String> postDenizenQuests = new List<String>.unmodifiable(<String>[
        "riding the wind through the pneumatic system, delivering packages to the local consorts",
        "doing the windy thing to clean up all of the pneumatic system’s leavings. Wow, that’s a lot of junk",
        "soothing the local consorts with a cool summer breeze",
        "whipping up a flurry of wind, the debris of Denizen rampage are blown far into the Outer Rim"
    ]);

    @override
    List<String> denizenQuests = new List<String>.unmodifiable(<String>[
        "realizing that the Denizen has thoroughly clogged up the pneumatic system",
        "trying to manually unclog the pneumatic system",
        "using Breath powers to unclog the pneumatic system"
    ]);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MOBILITY, 2.0, true),
        new AssociatedStat(Stats.SANITY, 1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.RELATIONSHIPS, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.05, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Breath(int id) :super(id, "Breath", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.breath(s, p);
    }

    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Wind","Breeze","Pipes", "Mail", "Whistles", "Pipe Organs", "Delivery"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("The Mail Goes Through.", [
                new Quest("The land is a series of candy red lakes. A wise old ${Quest.CONSORT} stops ${Quest.CONSORTSOUND}ing enough to explain that these lakes actually used to be mighty rivers, until ${Quest.DENIZEN} plugged them up with dams. Now the ${Quest.CONSORT}s can't travel or trade with other villages at all, and the land has begun to stagnate."),
                new Quest("The ${Quest.PLAYER1} discovers the correct sequence of hydraulic pumps to activate to increase the river pressure enough to jettison away the blockage in a geyser of candy red. The first river begins to flow, and the local ${Quest.CONSORT}s begin resuming trade activities.   "),
                new Quest("As the ${Quest.PLAYER1} goes around unplugging each river in turn, they begin to notice more and more debris among the candy red flow. Is ${Quest.DENIZEN} conspiring to reclog the rivers? "),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The rivers are too vital to the ${Quest.CONSORT}s to risk having them reclog.","The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling trade based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Zephyr", "Fans", "Windmills", "Pinwheels", "Propellers"])
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Fix the Windmills", [
                new Quest("The ${Quest.PLAYER1} comes across a mighty series of towers, each with chains limply hanging from their tips. A wise old ${Quest.CONSORT}s explains that before  ${Quest.DENIZEN} arrived, the chains connected each tower to each other, and facilitated trade and communication between settlements. Now the ${Quest.CONSORT}s are isolated from each other, and grow more paranoid and distrustful of strangers each generation.  The ${Quest.PLAYER1} vows to help. "),
                new Quest("The ${Quest.PLAYER1} delves in dungeons until the right items are discovered to alchemize new connectors for the chains. The first set of towers are reconnected, and trade and communication immediately resumes. The local ${Quest.CONSORT}s discover that ${Quest.CONSORT}s from other villages aren't so different, after all.  Another victory against xenophobia! "),
                new Quest("The ${Quest.PLAYER1} has been working tirelessly to hook up tower after tower, only to discover that the first tower they repaired is already broken again. There is no getting around it, ${Quest.DENIZEN} needs to be stopped. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} has tracked down ${Quest.DENIZEN}. There can be no mercy. ","The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is finally free to restore the chains, bringing peace and understanding to the land. ","The tyranny  and xenophobia of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Twisters","Cyclones","Gales", "Storms","Hurricanes","Gusts","Tornadoes","Typhoons"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("The Winds of Change", [
                new Quest("The ${Quest.PLAYER1} learns that two prominent ${Quest.CONSORT} families have been feuding for generations, despite once having been the best of friends. The land is on the verge of a civil war as uninvolved ${Quest.CONSORT}s pick a side, and everyone is suffering."),
                new Quest("The ${Quest.PLAYER1} tries to track down the origin of the feud that leaves their land on the verge of a civil war. Nobody can point to any REASON for it to be happening. "),
                new Quest("In a dramatic reveal, the ${Quest.PLAYER1} discovers that ${Quest.DENIZEN} is responsible for the feud. The two ${Quest.CONSORT} families never wronged each other, it's a huge misunderstanding. But how can they prove this to the feuding families? "),
                new DenizenFightQuest("The ${Quest.PLAYER1} confronts ${Quest.DENIZEN}. The beast smuggly admits to its crimes, and claims that the proof needed lies within its hoarde. Will the ${Quest.PLAYER1} be able to claim it?", "The ${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} shows the proof to the two ${Quest.CONSORT} families, who reconcile in a dramatic shower of happy tears and ${Quest.CONSORTSOUND}ing. ","The deception of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}