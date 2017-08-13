import "SBURBClass.dart";
import "../../../SBURBSim.dart";


class Bard extends SBURBClass {
  Bard() : super("Bard", 10, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * -0.5; //good things invert to bad.
    } else {
      powerBoost = powerBoost * -2.0; //bad thigns invert to good, with a boost to make up for the + to bad things
    }
    return powerBoost;
  }

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    powerBoost = this.modPowerBoostByClass(powerBoost, stat);
    //modify others
    target.modifyAssociatedStat(powerBoost, stat);

  }

  @override
  double getAttackerModifier() {
    return 2.0;
  }

  @override
  double getDefenderModifier() {
    return 0.5;
  }

  @override
  double getMurderousModifier() {
    return 3.0;
  }

}