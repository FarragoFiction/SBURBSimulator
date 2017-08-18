import "../../GameEntity.dart";
import "SBURBClass.dart";

class Heir extends SBURBClass {

    @override
    List<String> levels = ["SKAIA'S TOP IDOL", "POPSTAR BOPPER", "SONGSCUFFER"];
    @override
    List<String> quests = ["retrieving a sword from a stone", "completing increasingly unlikely challenges through serendepitious coincidences", "inheriting and running a successful, yet complex company"];
    @override
    List<String> postDenizenQuests = ["recruiting denizen villages, spreading a modest nation under their (Democratic!) control", "assuming control of yet more denizen villages. Turns out a mind bogglingly large number of consorts have the Heir named in their will", "chillaxing with their aspect and while talking to it as if it were a real person.", "wiping a dungeon off the map with their awe inspiring powers"];
    @override
    List<String> handles = ["home", "honorable", "humble", "hot", "horrific", "hardened", "havocs"];


    Heir() : super("Heir", 8, true);

    @override
    bool highHinit() {
        return false;
    }

    @override
    bool isActive() {
        return true;
    }


    @override
    num modPowerBoostByClass(num powerBoost, AssociatedStat stat) {
        return powerBoost * 1.5;
    }

    @override
    double getAttackerModifier() {
        return 0.5;
    }

    @override
    double getDefenderModifier() {
        return 2.0;
    }

    @override
    double getMurderousModifier() {
        return 1.5;
    }


}