import "../../../SBURBSim.dart";
import "SBURBClass.dart";


class Rogue extends SBURBClass {
    Rogue() : super("Rogue", 4, true);
    @override
    List<String> levels = ["KNEEHIGH ROBINHOOD", "DASHING DARTABOUT", "COMMUNIST COMMANDER"];
    @override
    List<String> quests = ["robbing various tombs and imp settlements to give to impoverished consorts", "stealing a priceless artifact in order to fund consort orphanages", "planning an elaborate heist to steal priceless grist from a boss ogre in order to alchemize shoes for orphans"];
    @override
    List<String> postDenizenQuests = ["scouring the land for targets, and then freaking out when they realize there's no bad guys left to steal from", "stealing from enemies on other players planets, acquiring enough boonbucks to lift every consort on the planet out of poverty", "doing a little dance on their pile soon-to-be distributed wealth", "literally stealing another player's planet. They put it back, but still. A planet. Wow", "loaning money to needy consorts, then surprising them by waiving every last cent of debt they owe"];
    @override
    List<String> handles = ["rouge", "radical", "retrobate", "roguish", "retroactive", "robins", "red"];

    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive() {
        return false;
    }

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 0.5;
    }

    @override
    double getAttackerModifier() {
        return 1.25;
    }

    @override
    double getDefenderModifier() {
        return 1.25;
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
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
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