import "../../GameEntity.dart";
import "Interest.dart";


class Culture extends InterestCategory {

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", -1, true), new AssociatedStat("hp", -1, true)]);
    @override
    List<String> handles1 = <String>["monochrome", "poetic", "majestic", "keen", "realistic", "serious", "theatrical", "haute", "beautiful", "priceless", "watercolor", "sensational", "highbrow", "refined", "precise", "melodramatic"];

    @override
    List<String> handles2 =  <String>["Dramatist", "Repository", "Museum", "Librarian", "Hegemony", "Hierarchy", "Davinci", "Renaissance", "Viniculture", "Treaty", "Balmoral", "Beauty", "Business"];



    Culture() :super(2, "Culture", "cultured", "pretentious");

}