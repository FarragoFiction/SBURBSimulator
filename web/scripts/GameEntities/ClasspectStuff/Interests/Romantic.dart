import "../../../SBURBSim.dart";
import "Interest.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Romantic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.RELATIONSHIPS, 2.0, true)]);
    @override
    List<String> handles1 = <String>["wishful", "matchmaking", "passionate", "kinky", "romantic", "serendipitous", "true", "hearts", "blushing", "precious", "warm", "serenading", "mesmerizing", "mirrored", "pairing", "perverse"];

    @override
    List<String> handles2 =<String>["Romantic", "Dreamer", "Beau", "Hearthrob", "Virtue", "Beauty", "Rainbow", "Heart", "Magnet", "Miracle", "Serendipity", "Team"];

    @override
    List<String> levels = <String>["QUESTING CUPID", "ROMANCE EXPERT"];

    @override
    List<String> interestStrings = <String>["Girls", "Boys", "Romance", "Shipping", "Relationships", "Love", "Romantic Comedies", "Fate", "Dating"];


    Romantic() :super(12, "Romantic", "romantic", "obsessive");

    @override
    void initializeThemes() {

        addTheme(new Theme(<String>["Tea","Candles","Roses", "Chocolate", "Valentines", "Candlelight", "Gifts"])
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.SPICYSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Set the Mood", [
                new Quest("The ${Quest.PLAYER1} finds what seems to be the only place on this entire planet that isn't beautifully decorated. What's even going on? A nearby ${Quest.CONSORT} explains that they ran into a bit of Artists block and just don't know how to make this area seem fancy enough.  Will the ${Quest.PLAYER1} be able to rise to meet the challenge?"),
                new Quest("The ${Quest.PLAYER1} is collecting all sort of things, especially ${Quest.PHYSICALMCGUFFIN}s, to decorate the Boring Section. "),
                new Quest(" The ${Quest.PLAYER1} tries a few different ideas out, but finally, the Boring Section is finally as beautiful as the rest of the planet. ${Quest.CONSORT}'s immediatly use it for a popular date spot. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Romance","RomComs","Meet Cutes", "True Love", "Serendipity", "Dates"])
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.GLAMOROUSFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Plan the Date", [
                new Quest("A Romantic ${Quest.CONSORT} approaches the ${Quest.PLAYER1}. They have a date coming up but have no idea what to do. Can the ${Quest.PLAYER1} help? "),
                new Quest("The ${Quest.PLAYER1} has the best montage of their life, helping the Romantic ${Quest.CONSORT} pick out an outfit for their date, plan activites and learn how to cook a romantic meal. Why is everything so wonderful?   "),
                new Quest(" The ${Quest.PLAYER1} hides in bushes to spy on the Romantic ${Quest.CONSORT}'s date. It's going so well! ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.LOW);

        addTheme(new Theme(<String>["Shipping","Ports","Ships", "Docks", "Sails", "Matchmaking", "Cupids", "Fleets"])
            ..addFeature(FeatureFactory.CUPIDCONSORT, Feature.HIGH)
            ..addFeature(FeatureFactory.SWEETSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.BAKEDBREADSMELL, Feature.MEDIUM)
            ..addFeature(FeatureFactory.SALTSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.ROMANTICFEELING, Feature.HIGH)
            ..addFeature(FeatureFactory.MUSICSOUND, Feature.MEDIUM)
            ..addFeature(FeatureFactory.JAZZSOUND, Feature.LOW)
            ..addFeature(new PreDenizenQuestChain("Ship All the Ships", [
                new Quest("The ${Quest.PLAYER1} begins constructing an intricate map of all possible relationships and all ideal relationships for a group of consorts. The ${Quest.CONSORT}s have no idea what's coming. "),
                new Quest("The ${Quest.PLAYER1} extends their “shipping grid” to include the entire ${Quest.CONSORT} population, and begins subtly pushing to make these ships a reality. Happy ${Quest.CONSORTSOUND}s ring out through the air.  "),
                new Quest("The ${Quest.PLAYER1} finds the ABSOLUTE BEST SHIP ever, and it's not even banned by the ${Quest.DENIZEN}'s stupid rules. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)

            ..addFeature(new PreDenizenQuestChain("Flushed Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be getting along well. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a heart symbol on the door. They ignore all common sense and venture inside. Chocolates and roses abound. There is a couch, and a romantic movie playing. Huh. ")
            ], new FlushedRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new PreDenizenQuestChain("Pale Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be a good complement to each other. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a diamond symbol on the door. They ignore all common sense and venture inside. Ice cream and hankies abound. There is a couch, and a sad movie playing. Huh. ")
            ], new PaleRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ..addFeature(new PreDenizenQuestChain("Pitched Shipping Dungeon", [
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} seem to be evenly matched rivals. The noodly appendages of the Horror Terrors do not fail to notice this.  "),
                new Quest("The ${Quest.PLAYER1}  and the ${Quest.PLAYER2} have come across a strange dungeon with a spades symbol on the door. They ignore all common sense and venture inside. Non lethal weapons and games abound. There is a couch, and a controversial movie playing. Huh. ")
            ], new PitchRomanceReward(), QuestChainFeature.twoPlayers), Feature.WAY_HIGH)

            ,  Theme.LOW);
    }

}