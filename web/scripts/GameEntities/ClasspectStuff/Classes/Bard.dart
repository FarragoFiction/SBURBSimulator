import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";

class Bard extends SBURBClass {
  Bard() : super("Bard", 10, true);

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    //modify others
    target.modifyAssociatedStat(powerBoost, stat);

  }

}