import "SBURBClass.dart";
import "../../../SBURBSim.dart";


class Prince extends SBURBClass {
  Prince() : super("Prince", 11, true);

  @override
  bool highHinit() {
    return true;
  }

  @override
  bool isActive() {
    return true;
  }


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
    //modify self.
    p.modifyAssociatedStat(powerBoost, stat);
  }

}