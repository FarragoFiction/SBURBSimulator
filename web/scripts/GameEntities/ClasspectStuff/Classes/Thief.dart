import "SBURBClass.dart";
import "../../../SBURBSim.dart";


class Thief extends SBURBClass {
  Thief() : super("Thief", 8, true);

  @override
  bool highHinit() {
    return false;
  }

  @override
  bool isActive() {
    return true;
  }

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 0.5;
  }

  @override
  double getAttackerModifier() {
    return 1.5;
  }

  @override
  double getDefenderModifier() {
    return 0.8;
  }

  @override
  double getMurderousModifier() {
    return 1.0;
  }

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
    powerBoost = this.modPowerBoostByClass(powerBoost, stat);
    target.modifyAssociatedStat((-1 * powerBoost), stat);
    p.modifyAssociatedStat(powerBoost, stat);
  }

}