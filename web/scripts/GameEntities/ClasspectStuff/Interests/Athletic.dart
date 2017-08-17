import "Interest.dart";
import "../../GameEntity.dart";


class Athletic extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("MANGRIT", 2, true)]);


  Athletic():super(4,"Athletic", "athletic","dumb");

}