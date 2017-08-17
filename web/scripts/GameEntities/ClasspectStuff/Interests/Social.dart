import "../../GameEntity.dart";

import "Interest.dart";

class Social extends InterestCategory {
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", 2, true)]);


  Social():super(11,"Social", "extroverted","shallow");

}