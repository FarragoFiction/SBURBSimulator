import "../../../SBURBSim.dart";
import "Interest.dart";

class Romantic extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat(Stats.RELATIONSHIPS, 2, true)]);
    @override
    List<String> handles1 = <String>["wishful", "matchmaking", "passionate", "kinky", "romantic", "serendipitous", "true", "hearts", "blushing", "precious", "warm", "serenading", "mesmerizing", "mirrored", "pairing", "perverse"];

    @override
    List<String> handles2 =<String>["Romantic", "Dreamer", "Beau", "Hearthrob", "Virtue", "Beauty", "Rainbow", "Heart", "Magnet", "Miracle", "Serendipity", "Team"];

    @override
    List<String> levels = <String>["QUESTING CUPID", "ROMANCE EXPERT"];

    @override
    List<String> interestStrings = <String>["Girls", "Boys", "Romance", "Shipping", "Relationships", "Love", "Romantic Comedies", "Fate", "Dating"];


    Romantic() :super(12, "Romantic", "romantic", "obsessive");

}