import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


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
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = true;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    bool highHinit() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be taking ${rand.pickFrom(me.aspect.symbolicMcguffins)} from the ${target.htmlTitle()} and distributing it to everyone. ";
    }

    @override
    bool isActive([double multiplier = 0.0]) {
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
        num powerBoost = p.getPowerForEffects() / 20;
        //modify others.
        powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        target.modifyAssociatedStat((-1 * powerBoost), stat);
        for (num i = 0; i < p.session.players.length; i++) {
            p.session.players[i].modifyAssociatedStat(powerBoost / p.session.players.length, stat);
        }
    }


    @override
    void initializeThemes() {

        //the sock ruse was a distaction
        addTheme(new Theme(<String>["Classism","Struggle","Apathy", "Revolution", "Rebellion","Rogues"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.FRANTICFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.HEROICFEELING, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Steal the Frogs", [
                new Quest("The ${Quest.DENIZEN} cannot release the frogs since the corrupt Noble ${Quest.CONSORT}s have hoarded them. The ${Quest.PLAYER1} organizes various common ${Quest.CONSORT}s to help raid the frog stockpiles. "),
                new Quest("The ${Quest.PLAYER1} performs frog breeding as fast as the ${Quest.CONSORT}s can deliver stolen frogs to them.  "),
                new Quest("The ${Quest.PLAYER1} has finally stolen the final frog.  They combine it and eventually have the    "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)


            ..addFeature(new PostDenizenQuestChain("Lead a Rebellion", [
                new Quest("The ${Quest.PLAYER1} learns of the extreme injustices of the ${Quest.CONSORT}s who rose to power during the tyranny of ${Quest.DENIZEN}. This cannot stand!"),
                new Quest("The ${Quest.PLAYER1} forms a small band of merry ${Quest.CONSORT}s to run raids on the ${Quest.CONSORT}s in power.  All proceeds are given to hungry ${Quest.CONSORT}s in need. "),
                new Quest("The ${Quest.CONSORT}s who profiteered on the tyranny of the ${Quest.DENIZEN} have finally been brought to justice. Their mansions are torn down. Their wealth is given to the poor.  The ${Quest.PLAYER1} is hailed as a hero. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);
    }


}