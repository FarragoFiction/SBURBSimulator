import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Sylph extends SBURBClass {
  Sylph() : super("Sylph", 6, true);

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = 2 * p.getStat("power") / 20;
    //modify other.
    target.modifyAssociatedStat(powerBoost, stat);
  }

}