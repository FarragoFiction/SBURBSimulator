import "../../../SBURBSim.dart";
import "SBURBClass.dart";


class Prince extends SBURBClass {
    Prince() : super("Prince", 10, true);
    @override
    List<String> levels = ["PRINCE HARMING", "ROYAL RUMBLER", "DIGIT PRINCE"];
    @override
    List<String> quests = ["destroying enemies thoroughly", "riding in at the last minute to defeat the local consorts hated enemies", "learning to grow as a person, despite the holes in their personality"];
    @override
    List<String> postDenizenQuests = ["thinking on endings. The end of their planet. The end of their denizen problems. The end of that very, very stupid imp that just tried to jump them", "defeating every single mini boss, including a few on other players planets", "burning down libraries of horror terror grimoires, shedding a few tears for the valuable knowledge lost along side the accursed texts", "hunting down and killing the last of a particularly annoying underling class"];
    @override
    List<String> handles = ["precocious","priceless","proficient","prominent","proper", "perfect", "pantheon"];

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive() {
        return true;
    }


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
    String interactionFlavorText(GameEntity me, GameEntity target) {
        return " The ${me.htmlTitle()} appears to be destroying something in themselves. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getStat("power") / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify self.
        p.modifyAssociatedStat(powerBoost, stat);
    }

}