import "../../GameEntity.dart";
import "Interest.dart";

class Technology extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("alchemy", 2, true)]);

  Technology():super(10,"Technology", "techy","awkward");

}