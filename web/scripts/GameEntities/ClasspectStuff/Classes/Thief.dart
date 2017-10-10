import "../../../SBURBSim.dart";
import "SBURBClass.dart";
import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";

class Thief extends SBURBClass {
    @override
    List<String> levels = ["RUMPUS RUINER", "HAMBURGLER YOUTH", "PRISONBAIT"];
    @override
    List<String> quests = ["robbing various enemy imps and ogres to obtain vast riches", "planning an elaborate heist that relies on several hard-to-predict factors going absolutely perfectly", "torrenting vast amounts of grist from the other players"];
    @override
    List<String> postDenizenQuests = ["literally stealing another player’s planet. Well, the deed to another player's planet, but still. A planet. Wow", "stealing every last piece of grist in every last dungeon. Hell fucking yes", "crashing the consort economy when they spend their hellaciously devious wealth", "doing a dance on their pile of ill earned goods and wealth"];
    @override
    List<String> handles = ["talented", "terrible", "talkative", "tenacious", "tried", "torrented"];

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

    Thief() : super("Thief", 7, true);

    @override
    bool highHinit() {
        return false;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be taking ${rand.pickFrom(me.aspect.symbolicMcguffins)}  from the ${target.htmlTitle()} and keeping it for themself. ";
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return true;
    }

    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
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
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = p.getPowerForEffects() / 20;
        powerBoost = 3 * powerBoost; //make up for how shitty your boost is for increasePower, THIS is how you are supposed to level.
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        target.modifyAssociatedStat((-1 * powerBoost), stat);
        p.modifyAssociatedStat(powerBoost, stat);
    }


    @override
    void initializeThemes() {
        addTheme(new Theme(<String>["Police","Law","Jails", "Slammers", "Officers","Cops","Prisons", "Detectives","Crime"])
            ..addFeature(FeatureFactory.DECEITSMELL, Feature.HIGH)
            ..addFeature(FeatureFactory.DANGEROUSFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.ENERGIZINGFEELING, Feature.MEDIUM)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)
            ..addFeature(new PostDenizenQuestChain("Escape the Law", [
                new Quest("The ${Quest.PLAYER1} is just minding their own business, when they see a huge stack of boonies. Unable to resist, they pilfer just a bit. A nearby ${Quest.CONSORTSOUND} sounds the alarm, shit, the ${Quest.PLAYER1} didn't know anybody was looking!  They flee with as many boonies as they can carry."),
                new Quest("The ${Quest.PLAYER1} is keeping a low profile. Shit's still too hot to spend their ill gotten boonies, but it'll be worth it, they just know it."),
                new Quest("Fuck, the ${Quest.PLAYER1} has been spotted. They lead the police ${Quest.CONSORT}s on a wild chase that ends with the ${Quest.PLAYER1} faking their own death and assuming a new identity. They can FINALLY spend those boonies. "),
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)
            ,  Theme.MEDIUM);


    }


}