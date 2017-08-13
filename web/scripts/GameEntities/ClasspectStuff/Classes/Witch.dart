import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";

class Witch extends SBURBClass {
  Witch() : super("Witch", 12, true);


  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = 2 * p.getStat("power") / 20;
    //modify self.
    p.modifyAssociatedStat(powerBoost, stat);
  }


}