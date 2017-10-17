import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Light extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#ff9933"
        ..aspect_light = '#FEFD49'
        ..aspect_dark = '#FEC910'
        ..shoe_light = '#10E0FF'
        ..shoe_dark = '#00A4BB'
        ..cloak_light = '#FA4900'
        ..cloak_mid = '#E94200'
        ..cloak_dark = '#C33700'
        ..shirt_light = '#FF8800'
        ..shirt_dark = '#D66E04'
        ..pants_light = '#E76700'
        ..pants_dark = '#CA5B00';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Treasure", "Light", "Knowledge", "Radiance", "Gambling", "Casinos", "Fortune", "Sun", "Glow", "Chance"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["SHOWOFF SQUIRT", "JUNGLEGYM SWASHBUCKLER", "SUPERSTITIOUS SCURRYWART"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Laborer", "Launderer", "Layabout", "Legend", "Lawyer", "Lifeguard"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Lucky", "LIGHT", "Knowledge", "Blinding", "Brilliant", "Break", "Blazing", "Glow", "Flare", "Gamble", "Omnifold", "Apollo", "Helios", "Scintillating", "Horseshoe", "Leggiero", "Star", "Kindle", "Gambit", "Blaze"]);


    @override
    String denizenSongTitle = "Opera"; //lol, cuz light players never shut up;

    @override
    String denizenSongDesc = " A beautiful opera begins to be performed. It starts to really pick up around Act 4. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Light', 'Helios', 'Ra', 'Cetus', 'Iris', 'Heimdall', 'Apollo', 'Coeus', 'Hyperion', "Belobog", 'Phoebe', 'Metis', 'Eos', 'Dagr', 'Asura', 'Amaterasu', 'Sol', 'Tyche', 'Odin ', 'Erutuf']);


    @override
    List<String> symbolicMcguffins = ["light","fortune", "knowledge", "illumination", "relevance", "rain", "sun", "rainbows"];

    @override
    List<String> physicalMcguffins = ["light","clover", "horseshoe", "encyclopedia","sun", "dice", "8-ball", "deck of tarot cards"];



    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.MAX_LUCK, 2.0, true),
        new AssociatedStat(Stats.FREE_WILL, 1.0, true),
        new AssociatedStat(Stats.SANITY, -1.0, true),
        new AssociatedStat(Stats.HEALTH, -1.0, true),
        new AssociatedStat(Stats.SBURB_LORE, 0.2, false) //yes, technically it's from an aspect, but it's not NORMAL.
    ]);

    Light(int id) :super(id, "Light", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.light(s, p);
    }

    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Luck","Casinos", "Gambling", "Dice", "Cards", "Fortune", "Chance","Betting"])
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.CLACKINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.HIGH) //persona5 has changed the face of casinos for me for all time
            ..addFeature(new DenizenQuestChain("Go Big or Go Home", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Glow", "Light", "Rays","Sun", "Shine", "Sparkle", "Sunshine","Stars" ])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HAPPYFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Shine the Light", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Knowledge","Information","Books","Encyclopedias","Understanding","Libraries"])
            ..addFeature(FeatureFactory.MUSTSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.TURTLECONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.STUDIOUSFEELING, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Shed the Light", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme

        //light is a special snowlake and can have 4 themes
        addTheme(new Theme(<String>["Spotlights","Attention","Drama","Stars","Glamor"])
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.LUCKYFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.DISCOSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CLAPPINGSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Be the Star", [
                new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}