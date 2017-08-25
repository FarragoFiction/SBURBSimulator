import "../../GameEntity.dart";
import "SBURBClass.dart";

class Grace extends SBURBClass {
    @override
    List<String> levels = <String>["KNEEHIGH ROBINHOOD", "DASHING DARTABOUT", "COMMUNIST COMMANDER"];
    @override
    List<String> handles = <String>["graceful", "gracious", "great", "gratuitous", "greeting", "gloved", "gone"];

    Grace() : super("Grace", 17, false);

    @override
    List<AssociatedStat> stats = new List<AssociatedStat>.unmodifiable(<AssociatedStat>[
        new AssociatedStat("sburbLore", 3.0, false) //basically all Wastes have.
    ]);


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        if (stat.isFromAspect) {
            powerBoost = powerBoost * 0; //wasted aspect
        } else {
            powerBoost = powerBoost * 1;
        }
        return powerBoost;
    }

}