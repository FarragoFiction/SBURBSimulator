import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Space extends Aspect {

    @override
    AspectPalette palette = new AspectPalette()
        ..accent = "#00ff00"
        ..aspect_light = '#EFEFEF'
        ..aspect_dark = '#DEDEDE'
        ..shoe_light = '#FF2106'
        ..shoe_dark = '#B01200'
        ..cloak_light = '#2F2F30'
        ..cloak_mid = '#1D1D1D'
        ..cloak_dark = '#080808'
        ..shirt_light = '#030303'
        ..shirt_dark = '#242424'
        ..pants_light = '#333333'
        ..pants_dark = '#141414';

    @override
    List<String> landNames = new List<String>.unmodifiable(<String>["Frogs"]);

    @override
    List<String> levels = new List<String>.unmodifiable(<String>["GREENTIKE", "RIBBIT RUSTLER", "FROG-WRANGLER"]);

    @override
    List<String> handles = new List<String>.unmodifiable(<String>["Stuck", "Salamander", "Salientia", "Spacer", "Scientist", "Synergy", "Spaceman"]);


    @override
    List<String> fraymotifNames = new List<String>.unmodifiable(<String>["Canon", "Space", "Frogs", "Location", "Spatial", "Universe", "Infinite", "Spiral", "Physics", "Star", "Galaxy", "Nuclear", "Atomic", "Nucleus", "Horizon", "Event", "CROAK", "Spatium", "Squiddle", "Engine", "Meteor", "Gravity", "Crush"]);

    @override
    String denizenSongTitle = "Sonata"; //a composition for a soloist.  Space players are stuck doing something different from everyone,;

    @override
    String denizenSongDesc = " An echoing note is plucked. It is the one Isolation plays to chart the depths of reality. The OWNER is strengthened and healed. The ENEMY is weakened and hurt. And that is all there is to say on the matter. ";


    @override
    List<String> denizenNames = new List<String>.unmodifiable(<String>['Space', 'Gaea', 'Nut', 'Echidna', 'Wadjet', 'Qetesh', 'Ptah', 'Geb', 'Fryja', 'Atlas', 'Hebe', 'Lork', 'Eve', 'Genesis', 'Morpheus', 'Veles ', 'Arche', 'Rekinom', 'Iago', 'Pilera', 'Tiamat', 'Gilgamesh', 'Implexel']);



    @override
    List<String> symbolicMcguffins = ["space","commitment", "creation", "room","stars", "galaxy", "black hole", "super nova"];
    @override
    List<String> physicalMcguffins = ["space","frog", "globe", "map","toad", "bass guitar", "nuclear reactor", "paint"];


    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.ALCHEMY, 2.0, true),
        new AssociatedStat(Stats.HEALTH, 1.0, true),
        new AssociatedStat(Stats.MOBILITY, -2.0, true)
    ]);

    Space(int id) :super(id, "Space", isCanon: true);

    @override
    String activateCataclysm(Session s, Player p) {
        return s.mutator.space(s, p);
    }

    //space quests have only one (FROGS) but it has a shit ton of questchains for every tier at hella high levels
    //so it overrides any other theme  (yes space players still have frog quests )
    @override
    void initializeThemes() {
        //learn about frogs
        List<String> frog1 = <String>["Wherever the ${Quest.PLAYER1} goes, they find a ${Quest.CONSORT} yammering on and on about FROGS. It only makes a little more sense than when they say nothing but ${Quest.CONSORTSOUND}.","The ${Quest.PLAYER1} has found several frogs in various states of not-usefulness. Apparently ${Quest.DENIZEN} is somehow to blame?", "The ${Quest.PLAYER1} wonders why there are so many temples covered in frog iconography in this weird land."];
        //learn about ectobiology
        List<String> frog2 = <String>["The ${Quest.PLAYER1} discovers some tiny ectobiology lab equipment. Oh! Apparently it's for breeding frogs?  They play around with it a bit with what frogs they've managed to collect. It looks like they can somehow...combine frogs? Aww, look how cute that tadpole is!  ", "The ${Quest.PLAYER1}'s server player deploys some weird equipment. After fiddling with it a bit, the ${Quest.PLAYER1} learns they can zap frogs into it and make baby frogs. How cute! ", "A wizened ${Quest.CONSORT} shows the ${Quest.PLAYER1} an ancient temple containing tiny ectobiology equipment. The pictures in the temple depect two frogs being zapped to it, and producing a cute little tadpole."];
        //learn about denizen
        List<String> frog3 = <String>["A wise old ${Quest.CONSORT} tells the ${Quest.PLAYER1} that they must negotiate with ${Quest.DENIZEN} to release the vast majority of the frogs. Apparently this is called 'lighting the forge'? ", "A temple shows a huge snake monster, probably the ${Quest.DENIZEN} locking away all the frogs.", "A ${Quest.DENIZEN} minion tells the ${Quest.PLAYER1} that if they want to find the best frogs, they are going to have to face the ${Quest.DENIZEN}."];
        //meet denizen
        List<String> frog4 = <String>["The ${Quest.PLAYER1} meets with ${Quest.DENIZEN}. They speak in a langauge no one else can understand, and prove their worth. The forge is lit. The frogs are free.", "The ${Quest.DENIZEN} offers the ${Quest.PLAYER1} an impossible Choice. After some deliberation, the ${Quest.PLAYER1} decides that it can't be done. The ${Quest.DENIZEN} sighs, and agrees to Light the Forge.", "The ${Quest.DENIZEN} is a dismissive asshole, but agrees to light the forge. Wow, the ${Quest.PLAYER1} almost wishes that they WERE supposed to fight. "];
        //can't be random here, this is beore a session exists :( :( :(
        //space player don't get boss fights
        addTheme(new Theme(<String>["Frogs"])
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CROAKINGSOUND, Feature.HIGH)
            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[0]),
                new Quest(frog2[0]),
                new Quest("${frog3[0]} ${frog4[0]}" ),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[1]),
                new Quest(frog2[1]),
                new Quest("${frog3[1]} ${frog4[1]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[2]),
                new Quest("${frog3[2]} ${frog4[2]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[0]),
                new Quest("${frog3[1]} ${frog4[0]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)

            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[2]),
                new Quest(frog2[1]),
                new Quest("${frog3[1]} ${frog4[2]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)


            ..addFeature(new DenizenQuestChain("Light the Forge", [
                new Quest (frog1[0]),
                new Quest(frog2[1]),
                new Quest("${frog3[2]} ${frog4[0]}"),
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_HIGH)


            //ALL classes should have their own frog 3rd tier quest, this one is just the default one.
            ..addFeature(new PostDenizenFrogChain("Breed the Frogs, But Be Boring About It", [
                new Quest("The ${Quest.PLAYER1} collects all sorts of frogs. Various ${Quest.CONSORT}s 'help' by ${Quest.CONSORTSOUND}ing up a storm. "),
                new Quest("The ${Quest.PLAYER1} begins combining frogs into ever cooler frogs. They begin to realize that an important feature is somehow missing from all frogs. Where could the frog with this trait be?  "),
                new Quest("The ${Quest.PLAYER1} has found the final frog.  They combine it and eventually have the Universe Tadpole all ready.   "),
            ], new FrogReward(), QuestChainFeature.defaultOption), Feature.HIGH)
            ,  Theme.SUPERHIGH);

    }

}