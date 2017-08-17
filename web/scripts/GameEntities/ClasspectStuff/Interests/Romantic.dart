import "../../GameEntity.dart";
import "Interest.dart";

class Romantic extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("RELATIONSHIPS", 2, true)]);



  Romantic():super(12,"Romantic", "romantic","obsessive");

}