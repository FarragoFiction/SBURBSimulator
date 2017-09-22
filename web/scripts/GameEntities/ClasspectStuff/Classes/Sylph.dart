import "../../../SBURBSim.dart";
import "SBURBClass.dart";

class Sylph extends SBURBClass {
    @override
    List<String> levels = ["SERENE SCALLYWAG", "MYSTICAL RUGMUFFIN", "FAE FLEDGLING"];
    @override
    List<String> quests = ["restoring a consort city to its former glory", "preserving the legacy of a doomed people", "providing psychological counseling to homeless consorts"];
    @override
    List<String> postDenizenQuests = ["beginning to heal the vast psychological damage their consorts have endured from the denizen’s ravages", "setting up counseling booths around their land and staffing them with well trained consort professionals", "bugging and fussing and meddling with the consorts, but now using their NEW FOUND POWERS", "realizing that maybe their bugging and fussing and meddling isn’t always the best way to deal with things"];
    @override
    List<String> handles = ["serious", "surly", "sour", "sweet", "stylish", "soaring", "serene", "salacious"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = true;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat(Stats.SBURB_LORE, 0.1, false)
    ]);

    Sylph() : super("Sylph", 5, true);


    @override
    bool highHinit() {
        return true;
    }

    @override
    bool isActive([double multiplier = 0.0]) {
        return false;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.multiplier > 0) {
            powerBoost = powerBoost * 0.5;
        } else {
            powerBoost = powerBoost * -0.5;
        }
        return powerBoost;
    }

    @override
    double getAttackerModifier() {
        return 1.0;
    }

    @override
    double getDefenderModifier() {
        return 1.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

    @override
    bool hasInteractionEffect() {
        return true;
    }

    @override
    String interactionFlavorText(Player me, GameEntity target, Random rand) {
        return " The ${me.htmlTitle()} appears to be feeling more helpful after being around the ${target.htmlTitle()}. ";
    }

    @override
    void processStatInteractionEffect(Player p, GameEntity target, AssociatedStat stat) {
        num powerBoost = 2 * p.getPowerForEffects() / 20;
        powerBoost = this.modPowerBoostByClass(powerBoost, stat);
        if(p.session.mutator.bloodField) powerBoost = powerBoost * p.session.mutator.bloodBoost;
        //modify other.
        target.modifyAssociatedStat(powerBoost, stat);
    }

}