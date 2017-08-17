import "../../GameEntity.dart";
import "Interest.dart";

class Music extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 1, true), new AssociatedStat("maxLuck", 1, true)]);


  Music():super(1,"Music", "musical","loud");

}