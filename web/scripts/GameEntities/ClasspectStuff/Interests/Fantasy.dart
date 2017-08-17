import "../../GameEntity.dart";
import "Interest.dart";

class Fantasy extends InterestCategory {


  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("maxLuck", 1, true), new AssociatedStat("alchemy", 1, true)]);



  Fantasy():super(7,"Fantasy", "imaginative","whimpy");

}