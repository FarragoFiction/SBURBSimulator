import "../../../SBURBSim.dart";
import "SBURBClass.dart";

class Lord extends SBURBClass {
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

}