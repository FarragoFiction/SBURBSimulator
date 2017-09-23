import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";
import "../../SBURBSim.dart";

//TODO have a 'premade enemy' feature. useful for royalty and shit.
class EnemyFeature extends Feature {
    ///dynamic strength means enemy is scaled to the first time the enemy faces them.
    static double DYNAMIC_STRENGTH = -13.0;
    String name;
    double strength; //highest is 13
    GameEntity enemy;
    //TODO have them take in a fraymotif as well, to give out in their reward??? or should that be on teh reward and not the boss?
   EnemyFeature(this.name, this.strength, GameEntity enemy);

    GameEntity makeEnemy(Session session, Player p) {
        if(strength == DYNAMIC_STRENGTH) strength = p.getStat(Stats.EXPERIENCE)/100.round();
        enemy.setImportantShit(session, <AssociatedStat>[],name, strength, <Fraymotif> []);
        return enemy;
    }

}


class DenizenFeature extends EnemyFeature {

     DenizenFeature(String name, double strength, Denizen d):super(name, strength,d);

    Denizen makeDenizen(Session s) {
        return new Denizen(name, s);
    }

    //passed in specific can have 'ands' in the middle
     String randomNeutralFlavorText(Random rand, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("You can hear the roar of  ${name} in the distance. ");
        possibilities.add("The air is heavy with the opression of ${name}. ");
        possibilities.add("The ${p.htmlTitle()} boggles vacantly at the devestation that $name has caused.");
        return rand.pickFrom(possibilities);
    }

}