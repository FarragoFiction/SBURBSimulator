import "../../GameEntity.dart";
import "Interest.dart";


class Culture extends InterestCategory {

  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("sanity", -1, true), new AssociatedStat("hp", -1, true)]);



  Culture():super(2,"Culture", "cultured","pretentious");

}