import "Interest.dart";
import "../../GameEntity.dart";


class Academic extends InterestCategory {
  @override
  List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[new AssociatedStat("freeWill", -2, true)]);

  Academic():super(13,"Academic", "smart","nerdy");

}