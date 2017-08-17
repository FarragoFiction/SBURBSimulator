import "../../GameEntity.dart";
import "Interest.dart";



class Domestic extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 1, true), new AssociatedStat("RELATIONSHIPS", 1, true)]);


  Domestic():super(8,"Domestic", "domestic","boring");

}