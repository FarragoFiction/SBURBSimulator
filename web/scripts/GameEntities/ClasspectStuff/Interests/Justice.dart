import "../../GameEntity.dart";

import "Interest.dart";

class Justice extends InterestCategory {
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("MANGRIT", 1, true), new AssociatedStat("hp", 1, true)]);


  Justice():super(6,"Justice", "fair-minded","harsh");

}