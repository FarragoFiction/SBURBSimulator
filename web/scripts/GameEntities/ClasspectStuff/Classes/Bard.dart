import "../../../SBURBSim.dart";
import "SBURBClass.dart";


class Bard extends SBURBClass {

    @override
    List<String> levels = ["SKAIA'S TOP IDOL", "POPSTAR BOPPER", "SONGSCUFFER"];
    @override
    List<String> quests = ["allowing events to transpire such that various quests complete themselves", "baiting various enemies into traps for an easy victory", "watching as their manipulations result in consorts rising up to defeat imps"];
    @override
    List<String> postDenizenQuests = ["musing on the nature of death as they wander from desolate consort graveyard to desolate consort graveyard", "staring vacantly into the middle distance as every challenge that rises before them falls away before it even has a chance to do anything", "putting on a performance for a huge crowd of awestruck consorts and underlings", "playing pranks and generally messing around with the most powerful enemies left in the game"];
    @override
    List<String> handles = ["benign", "blissful", "boisterous", "bonkers", "broken", "bizarre", "barking"];

    Bard() : super("Bard", 9, true);

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
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
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
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