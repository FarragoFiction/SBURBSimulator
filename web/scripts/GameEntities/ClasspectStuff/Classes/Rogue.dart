import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";

class Rogue extends SBURBClass {
  Rogue() : super("Rogue", 5, true);

  @override
  num  modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
    return powerBoost * 0.5;
  }

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    //modify others.
    powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
    powerBoost = this.modPowerBoostByClass(powerBoost, stat);
    target.modifyAssociatedStat((-1 * powerBoost), stat);
    for (num i = 0; i < p.session.players.length; i++) {
      p.session.players[i].modifyAssociatedStat(powerBoost / p.session.players.length, stat);
    }
  }

}