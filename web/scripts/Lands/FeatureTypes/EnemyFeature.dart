import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";
import "../../SBURBSim.dart";



class DenizenFeature extends Feature {
    static double DYNAMIC_STRENGTH = -13.0;
    String name;
    double strength; //highest is 13
     DenizenFeature(this.name, this.strength, GameEntity enemy);

    Denizen makeDenizen(Player p) {
        Denizen ret =  new Denizen(name, p.session);
        List<Fraymotif> f = new List<Fraymotif>();
        f.add(p.session.fraymotifCreator.makeDenizenFraymotif(p, name));
        ret.setImportantShit(p.session, new List<AssociatedStat>.from(p.associatedStatsFromAspect),name, strength,f);
        return ret;

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