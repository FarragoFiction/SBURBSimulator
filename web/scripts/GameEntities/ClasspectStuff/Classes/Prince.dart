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
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
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
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be destroying ${rand.pickFrom(me.aspect.symbolicMcguffins)} in themselves. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify self.
        p.modifyAssociatedStat(powerBoost, stat);
    }

}