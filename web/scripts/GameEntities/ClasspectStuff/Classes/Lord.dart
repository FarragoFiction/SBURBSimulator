import "../../GameEntity.dart";
import "SBURBClass.dart";
import "../../../SBURBSim.dart";

import "../../../Lands/FeatureTypes/QuestChainFeature.dart";
import "../../../Lands/Reward.dart";
import "../../../Lands/Quest.dart";


class Lord extends SBURBClass {
    @override
    double difficulty = 2.0;
    @override
    List<String> levels = ["LAUGHING STOCKINGS", "DELEGATION DELIVERER", "LORDLING"];
    @override
    List<String> quests = ["inspiring the consorts to produce great works of art", "causing events to transpire such that the consorts improve themselves", "avidly learning about consort history and art"];
    @override
    List<String> postDenizenQuests = ["inspiring the consorts to rebuild their land", "showing the consorts what strength through adversity means", "hanging back and watching the consorts rebuild", "making sure the recovery process is going as intended"];
    @override
    List<String> handles = ["lording", "leaderly", "laughing", "laughsassin","lawful", "lordly", "legendary", "legionnaires", "lacerating", "lactate", "legislacerator"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = true;
    @override
    bool isHelpful = false;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Lord() : super("Lord", 19, false);


    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        if(multiplier >= 0) { //if no stat passed, act active
           // print("Lord taking  the good of stat");
            return true; //muse applies it to self if bad.
        }
       // print("Lord dellegating the bad of stat");
        return false; //to others if good.
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost; //no change.
    }

    //you don't expect a muse to start shit
    @override
    double getAttackerModifier() {
        return 3.1;
    }

    @override
    double getDefenderModifier() {
        return 0.1; //john pounds the living daylights outta calliborn, AW points out
    }

    @override
    double getMurderousModifier() {
        return 3.1;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} hoardes the benefits of  ${me.aspect.name} while having  ${target.htmlTitle()} shoulder the burdens. ";
    }

    //TODO using the existing framework, how would i make it so that regular things matter based on target, too? i want to be lazy here. prefer caring about land update.
    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;

        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //give bad to me and good to you.
        if(powerBoost >=0) {
            p.modifyAssociatedStat(powerBoost, stat);
        }else {
            target.modifyAssociatedStat(powerBoost, stat);
        }
    }

    //rule, control, delegate
    @override
    void initializeThemes() {
        /*
        new Quest(" "),
        new Quest(""),
        new Quest(" ")

        */
        addTheme(new Theme(<String>["Castles","Keeps", "Fortresses", "Nobility","Forts","Moats","Dungeons"])
            ..addFeature(FeatureFactory.BLOODSMELL, Feature.LOW)
            ..addFeature(FeatureFactory.SCREAMSSOUND, Feature.LOW)
            ..addFeature(FeatureFactory.CREEPYFEELING, Feature.LOW)
            ..addFeature(FeatureFactory.CLANKINGSOUND, Feature.MEDIUM)

            ..addFeature(new PostDenizenFrogChain("Command Minions to Breed Frogs", [
                new Quest("The ${Quest.DENIZEN} has been subjugated, their hoard of frogs released. Across the land castles and dungeons suddenly are accessible, and filled with croaking. The ${Quest.PLAYER1} comands that the ${Quest.CONSORT}s collect the frogs. The ${Quest.CONSORT}s agree with enthusiastic ${Quest.CONSORTSOUND}s. "),
                new Quest("The ${Quest.CONSORT}s hit buttons on the ectobiology machine at random. The ${Quest.PLAYER1} sits back and enjoys a tropical drink. The frogs will be ready eventually. "),
                new Quest("A ${Quest.CONSORT} minion has finally found the final frog. The ${Quest.PLAYER1} rewards them, and punishes everyone else for failing. "),
            ], new FrogReward(), QuestChainFeature.spacePlayer), Feature.WAY_HIGH)

            ..addFeature(new PostDenizenQuestChain("Conquer Everything", [
                new Quest("As soon as the ${Quest.DENIZEN} is defeated, the ${Quest.CONSORT}s disolve into civil wars and infighting. It will take a strong leader to unite the land, and the ${Quest.PLAYER1} is up to the task.  "),
                new Quest("The ${Quest.PLAYER1} has subjugated/assimilated about half of the ${Quest.CONSORT} factions, at this point. They are surprisingly good at following commands, and everything is running with clock work efficiencey."),
                new Quest("The final ${Quest.CONSORT} commander surrenders. the ${Quest.PLAYER1} controls everything now. They are the Lord of all they survey. ")
            ], new FraymotifReward(), QuestChainFeature.defaultOption), Feature.WAY_LOW)


            ,  Theme.MEDIUM);
    }

}