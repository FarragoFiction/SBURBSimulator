import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";

class Thief extends SBURBClass {
  Thief() : super("Thief", 8, true);

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
    target.modifyAssociatedStat((-1 * powerBoost), stat);
    p.modifyAssociatedStat(powerBoost, stat);
  }

}