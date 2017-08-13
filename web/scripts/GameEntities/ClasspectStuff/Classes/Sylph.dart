import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";
class Sylph extends SBURBClass {
  Sylph() : super("Sylph", 6, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.5;
    } else {
      powerBoost = powerBoost * -0.5;
    }
    return powerBoost;
  }

  @override
  double getAttackerModifier() {
    return 1.0;
  }

  @override
  double getDefenderModifier() {
    return 1.0;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = 2 * p.getStat("power") / 20;
    powerBoost = this.modPowerBoostByClass(powerBoost, stat);
    //modify other.
    target.modifyAssociatedStat(powerBoost, stat);
  }

}