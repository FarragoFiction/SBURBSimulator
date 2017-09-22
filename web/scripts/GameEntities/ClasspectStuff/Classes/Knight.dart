import "../../GameEntity.dart";
import "SBURBClass.dart";

class Knight extends SBURBClass {
    @override
    List<String> levels = ["QUESTING QUESTANT", "LADABOUT LANCELOT", "SIR SKULLDODGER"];
    @override
    List<String> quests = ["protecting the local consorts from a fearsome foe", "protecting the session from various ways it can go shithive maggots", "questing to collect the 7 bullshit orbs of supreme bullshit and deliver them to the consort leader"];
    @override
    List<String> postDenizenQuests = ["", "spending way too much time hustling from village to village, saving the consorts from the denizens last few minions", "breaking a siege on a consort village, saving its population and slaughtering thousands of underlings", "finishing the ‘legendary’ tests of valor dispensed by an elder consort"];
    @override
    List<String> handles = ["keen", "knightly", "kooky", "kindred", "kaos",];

    @override
    bool isProtective = true;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = false;

    Knight() : super("Knight", 3, true);

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
        return 2.5;
    }

    @override
    double getMurderousModifier() {
        return 0.75;
    }

}