import "../../GameEntity.dart";
import "Interest.dart";

class Writing extends InterestCategory {
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("freeWill", 2, true)]);


  Writing():super(3,"Writing", "lettered","wordy");

}