import "../Feature.dart";
import "../../GameEntities/NPCS.dart";
import "../../SessionEngine/session.dart";
import "../../SBURBSim.dart";



class DenizenFeature extends Feature {
    String name;
    Denizen denizen;
     DenizenFeature(this.name);

    @override
    String toHTML() {
        return "<div class = 'feature'>${name}</div>";
    }

    Denizen makeDenizen(Player p) {
        if(denizen != null) return denizen;

        //print("making denizen with strength $strength");
        Denizen ret =  new Denizen(name, p.session);
        List<Fraymotif> f = new List<Fraymotif>();
        f.add(p.session.fraymotifCreator.makeDenizenFraymotif(p, name));
        ret.fraymotifs = f;
        ret.name = name;
        ret.stats.copyFrom(p.stats); //mirror image, but won't improve any.
        Iterable<Stat> allStats = Stats.all;
        for (Stat stat in allStats) {
            if(stat != Stats.EXPERIENCE && stat != Stats.POWER) ret.addStat(stat, -1*ret.getStat(stat)/3); //weaker
        }
        denizen = ret;
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

class HardDenizenFeature extends DenizenFeature
{
    HardDenizenFeature(String name): super(name);

    Denizen makeDenizen(Player p) {
        if(denizen != null) return denizen;

        //print("making denizen with strength $strength");
        HardDenizen ret =  new HardDenizen(name, p.session);
        List<Fraymotif> f = new List<Fraymotif>();
        f.add(p.session.fraymotifCreator.makeDenizenFraymotif(p, name));
        ret.fraymotifs = f;
        ret.name = name;
        ret.stats.copyFrom(p.stats); //mirror image,no detriments.
        denizen = ret;
        return ret;

    }
}