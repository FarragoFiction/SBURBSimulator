import "Interest.dart";
import "../../GameEntity.dart";

class Comedy extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("minLuck", -1, true), new AssociatedStat("maxLuck", 1, true)]);


  Comedy():super(0,"Comedy", "funny","dorky");

}