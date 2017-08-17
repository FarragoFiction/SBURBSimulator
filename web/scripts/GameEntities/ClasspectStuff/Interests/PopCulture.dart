import "../../GameEntity.dart";
import "Interest.dart";

class PopCulture extends InterestCategory {
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("mobility", 2, true)]);



  PopCulture():super(9,"PopCulture", "geeky","frivolous");

}