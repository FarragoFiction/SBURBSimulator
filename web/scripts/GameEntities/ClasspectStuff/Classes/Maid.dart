import "../../GameEntity.dart";
import "SBURBClass.dart";

class Maid extends SBURBClass {
    @override
    List<String> levels = ["SCURRYWART SERVANT", "SAUCY PILGRIM", "MADE OF SUCCESS"];
    @override
    List<String> quests = ["doing the consorts' menial errands, like delivering an item to a dude standing RIGHT FUCKING THERE", "repairing various ways the session has been broken", "protecting various consorts with game powers"];
    @override
    List<String> postDenizenQuests = ["using their powers to help clean up the debris left from their Denizen actions. Who knew the term maid would be so literal", "watching over the consorts as they begin to rebuild", "following their consorts to ever larger pieces of debris", "empowering an army of consorts to clean out the last of the debris from their Denizen"];
    @override
    List<String> handles = ["meandering", "motley", "musing", "mischievous", "macabre", "maiden", "morose"];

    @override
    bool isProtective = false;
    @override
    bool isSmart = false;
    @override
    bool isSneaky = false;
    @override
    bool isMagical = false;
    @override
    bool isDestructive = false;
    @override
    bool isHelpful = true;

    Maid() : super("Maid", 0, true);

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
        return powerBoost * 1.5;
    }

    @override
    double getAttackerModifier() {
        return 0.33;
    }

    @override
    double getDefenderModifier() {
        return 3.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }

}