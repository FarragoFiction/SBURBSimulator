import "SBURBClass.dart";
import "../../Player.dart";
import "../../GameEntity.dart";

class Prince extends SBURBClass {
  Prince() : super("Prince", 11, true);

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = p.getStat("power") / 20;
    //modify self.
    p.modifyAssociatedStat(powerBoost, stat);
  }

}