import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";
import "../../SBURBSim.dart";


class DenizenFeature extends Feature {
    String name;
    int strength; //highest is 13
     DenizenFeature(this.name, this.strength);

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