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
                new Quest("The ${Quest.PLAYER1} tries posting a letter through the ${Quest.PHYSICALMCGUFFIN} mail system only to find the letter caught in a plug of oil!  ${Quest.DENIZEN} has screwed with the mail system, crippling the ${Quest.CONSORT} economy!"),
                new Quest("The ${Quest.PLAYER1} cleans out oil from the nearby ${Quest.PHYSICALMCGUFFIN}’s, opening up a few more channels between villages. "),
                new Quest("The ${Quest.PLAYER1} gets sick of all the fucking oil in the ${Quest.PHYSICALMCGUFFIN} mail system, and realizes the only way to truly deal with it and to allow information to flow free is to confront ${Quest.DENIZEN}."),
                new DenizenFightQuest("It is time for the ${Quest.PLAYER1}  to finally face the ${Quest.DENIZEN}. The mail is too vital to the ${Quest.CONSORT}s to risk having them reclog.","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has won! The ${Quest.CONSORT}s have a bustling mail based economy once again.","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Zephyr", "Fans", "Windmills", "Pinwheels", "Propellers"])
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Thinking With Wind Power", [
                new Quest("The ${Quest.PLAYER1} constructs a little windmill system for a joke, and suddenly an entire village of consorts has grown up around it! The ${Quest.PLAYER1} decides that they should use the winds of their land for more projects. "),
                new Quest("The ${Quest.PLAYER1} starts learning the uses of their lands ${Quest.PHYSICALMCGUFFIN} in manipulation of wind. Their future constructions are going to be amazing. "),
                new Quest("The ${Quest.PLAYER1} uses ${Quest.PHYSICALMCGUFFIN}s to build a massive farming system that harnesses the wind to distribute seeds across the ${Quest.CONSORT} fields. The ${Quest.CONSORT}’s ${Quest.CONSORTSOUND}ing is so joyful it's literally deafening. "),
                new DenizenFightQuest("${Quest.DENIZEN} is attacking the happy wind based farming community. The ${Quest.PLAYER1} has worked too hard for it all to be lost now. There can be no mercy. ","${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} is finally free to continue improving the land with wind. ","The tyranny of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH);

        addTheme(new Theme(<String>["Twisters","Cyclones","Gales", "Storms","Hurricanes","Gusts","Tornadoes","Typhoons"])
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROARINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.WHISTLINGGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.NATURESMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("The Winds of Change", [
                new Quest("The ${Quest.PLAYER1} is chilling in a ${Quest.CONSORT} village when a FUCK OFF HUGE STORM blows through, destroying the consorts housing. The player learns that ${Quest.DENIZEN} has screwed with the wind system, sending these giant storms at random."),
                new Quest("The ${Quest.PLAYER1} learns of a ${Quest.PHYSICALMCGUFFIN} system that controls the storms of their land. The begin adventuring and solving puzzles to alter the layout of the ${Quest.PHYSICALMCGUFFIN} system so the storms are redirected from consort villages. "),
                new Quest("The ${Quest.PLAYER1} finishes the dungeon that holdS the  ${Quest.PHYSICALMCGUFFIN} system’s control panel, only to find the control room totally empty. They learn that they only needed their own ${Quest.MCGUFFIN} to do control the storms in the first place, and it was inside them all along.  "),
                new DenizenFightQuest(" ${Quest.DENIZEN} arrives to challenge the ${Quest.PLAYER1} storm supremacy. Will the ${Quest.PLAYER1} be able to prove their worth?", "${Quest.DENIZEN} lies slain. The ${Quest.PLAYER1} has become the storm master. It is them. ","The storm supremacy of ${Quest.DENIZEN} continues with the defeat of the ${Quest.PLAYER1}.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}