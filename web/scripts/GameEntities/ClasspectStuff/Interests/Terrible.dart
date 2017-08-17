import "../../GameEntity.dart";
import "Interest.dart";

class Terrible extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("RELATIONSHIPS", -1, true), new AssociatedStat("sanity", -1, true)]);


  Terrible():super(5,"Terrible", "honest","terrible");

}