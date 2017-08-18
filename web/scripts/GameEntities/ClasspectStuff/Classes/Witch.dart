import "SBURBClass.dart";
import "../../../SBURBSim.dart";


class Witch extends SBURBClass {
  @override
  List<String> levels =["WESTWORD WORRYBITER","BUBBLETROUBLER","EYE OF GRINCH"];
  @override
  List<String> quests =["performing elaborate punch card alchemy through the use of a novelty witch's cauldron","deciding which way to go in a series of way-too-long mazes","solving puzzles in ways that completely defy expectations"];
  @override
  List<String> postDenizenQuests =["alchemizing a mind crushingly huge number of computers in various forms","whizzing around their land like it's fucking christmas","defeating a completely out of nowhere mini boss","wondering if their sprite prototyping choice was the right one after all"];
  @override
  List<String> handles =["wondering","wonderful","wacky","withering","worldly","weighty"];
  Witch() : super("Witch", 11, true);

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
    if (stat.multiplier > 0) {
      powerBoost = powerBoost * 0.5;
    } else {
      powerBoost = powerBoost * -0.5;
    }
    return powerBoost;
  }

  @override
  bool hasInteractionEffect() {
    return true;
  }

  @override
  void processStatInteractionEffect(Player p,GameEntity target, AssociatedStat stat) {
    num powerBoost = 2 * p.getStat("power") / 20;
    powerBoost = this.modPowerBoostByClass(powerBoost, stat);
    //modify self.
    p.modifyAssociatedStat(powerBoost, stat);
  }

  @override
  double getAttackerModifier() {
    return 2.0;
  }

  @override
  double getMurderousModifier() {
    return 1.5;
  }

  @override
  double getDefenderModifier() {
    return 1.0;
  }



}