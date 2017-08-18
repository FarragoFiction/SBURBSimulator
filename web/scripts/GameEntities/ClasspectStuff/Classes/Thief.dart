import "SBURBClass.dart";
import "../../../SBURBSim.dart";


class Thief extends SBURBClass {
  @override
  List<String> levels =["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
  @override
  List<String> quests =["robbing various enemy imps and ogres to obtain vast riches","planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly","torrenting vast amounts of grist from the other players"];
  @override
  List<String> postDenizenQuests =["literally stealing another player’s planet. Well, the deed to another player's planet, but still. A planet. Wow","stealing every last piece of grist in every last dungeon. Hell fucking yes","crashing the consort economy when they spend their hellaciously devious wealth","doing a dance on their pile of ill earned goods and wealth"];
  @override
  List<String> handles =["talented","terrible","talkative","tenacious","tried", "torrented"];
  Thief() : super("Thief", 7, true);

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