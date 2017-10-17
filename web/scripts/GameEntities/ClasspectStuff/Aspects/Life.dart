import '../../../SBURBSim.dart';
import 'Aspect.dart';
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

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


    @override
    void initializeThemes() {

        /*
        new Quest(""),
                new Quest(""),
                new Quest(""),
                new DenizenFightQuest("","","")
         */
        addTheme(new Theme(<String>["Forests","Chlorophyll", "Moss", "Trees", "Jungles", "Wood", "Tribes", "Timber", "Wilds", "Thickets", "Coppices", "Copses"])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.HIGH)
            ..addFeature(FeatureFactory.DRUMSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.WOLFCONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(new DenizenQuestChain("Restore the Forest", [
                new Quest("The ${Quest.PLAYER1} finds a village of compliant ${Quest.CONSORT}s frantically destroying trees. If they stop, even for a moment, they know their village will be destroyed, along with any nearby trees. When the ${Quest.PLAYER1} tries to offer help they begin ${Quest.CONSORTSOUND}ing in panic. Don't upset ${Quest.DENIZEN}, they beg. It is only by complying that they are safe, and you will bring wrath upon everyone. "),
                new Quest("The ${Quest.PLAYER1} revisits the village compliant ${Quest.CONSORT}s, only to discover it's freshly destroyed. A weeping ${Quest.CONSORT} explains that they couldn't keep up their pace and had to rest, and that is when ${Quest.DENIZEN} attacked. Please. HELP them, he begs. The ${Quest.PLAYER1} agrees to go face ${Quest.DENIZEN}."),
                new DenizenFightQuest("In a nest built of thousands of splintered trees, the ${Quest.DENIZEN} waits. It is time to fight. ","The ${Quest.PLAYER1}'s power is greater. The survive, and help the ${Quest.CONSORT}s to survive as well.","The ${Quest.DENIZEN} is stronger. The strong survive. The weak perish.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.HIGH);
        addTheme(new Theme(<String>["Gardens", "Summer", "Growth","Dew", "Spring", "Beginnings", "Vitality","Strength","Fields","Farms" ])
            ..addFeature(FeatureFactory.NATURESMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ZOOSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.CALMFEELING, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Distribute the Food", [
                new Quest("The ${Quest.PLAYER1} finds a lush garden, dutifully tended to by ${Quest.CONSORT}s. Unfortunately, the food is left to rot in piles, as Underling brigands block the road and prevent the produce from being distributed. The ${Quest.PLAYER1} agrees to help."),
                new Quest("The ${Quest.PLAYER1} sneaks along the main road and finds the Underling Brigands lying in wait. They are dispatched in short order, and the ${Quest.PLAYER1} heroically informs the ${Quest.CONSORT}s that they can once again begin shipping their food."),
                new Quest("The ${Quest.PLAYER1} follows the road to find a new village, fileld with hungry ${Quest.CONSORT}s. Apparently the food has been stolen by a ${Quest.DENIZEN} minion! Enraged, the ${Quest.PLAYER1} tracks down the minion and defeats it. They now know this will not be the end of it. They need to nip this in the bud. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} approaches the ${Quest.DENIZEN}. It ends here.","The ${Quest.PLAYER1} was strong enough to win! The consorts will never have to worry about their food being destroyed senselessly again.","The tyranny of ${Quest.DENIZEN} continues.")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            , Theme.HIGH);

        addTheme(new Theme(<String>["Decay","Locusts","Bogs","Blight","Fens","Rot","Death","Mold","Swamps","Thorns","Swarms","Famine", "Hunger", "Disease"])
            ..addFeature(FeatureFactory.ROTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.RUSTLINGSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.SKELETONCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CROCODILECONSORT, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ALLIGATORCONSORT, Feature.MEDIUM)
            ..addFeature(new DenizenQuestChain("Protect the Farms", [
                new Quest("Drawn by wailing and ${Quest.CONSORTSOUND}ing, the ${Quest.PLAYER1} enters a rotting ${Quest.CONSORT} village. They are in the throes of a famine they explain. Locusts damage their fields and blight destroys the weakened remainder. They cannot feed everyone once winter comes if this continues.   The ${Quest.PLAYER1} vows to help."),
                new Quest("The ${Quest.PLAYER1} strifes countless swarms of locusts, but there seems to be no end to them. They finally track down a hive, guarded by several ${Quest.DENIZEN} minions. It is as easy as thinking to destroy everything, but the ${Quest.PLAYER1} is left uneasy. Why were the minions causing this on purpose?  "),
                new Quest("Although the locusts have thinned in numbers, the blight is as strong as ever. Even the most potent of alchemized fungicides seem to only keep back the blight for a day. At their wits end, the ${Quest.PLAYER1} stays in the fields overnight to discover that ${Quest.DENIZEN} minions are spreading a strange powder on the fields. Defeating them is a start, but clearly ${Quest.DENIZEN} is dedicated to causing famine. They must be dealt with. "),
                new DenizenFightQuest("The ${Quest.PLAYER1} faces the ${Quest.DENIZEN}. It will end here.","The ${Quest.PLAYER1} is strong enough to impose their will on the world. Famine will not trouble the ${Quest.CONSORT}s any longer.","The ${Quest.PLAYER1} was not strong enough. Can anything save the ${Quest.CONSORT}s before winter? ")
            ], new DenizenReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            , Theme.HIGH); // end theme
    }
}