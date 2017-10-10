import "DescriptiveFeature.dart";
import "../../SBURBSim.dart";


class SmellFeature extends DescriptiveFeature {
    ///flavor text, "the smell of $smellsLike permeates the air"


    SmellFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);

    @override
    String toHTML() {
        return "<div class = 'feature'>Smell ${simpleDesc}, Quality: ${quality}</div>";
    }

    static String randomFlavorText(Random rand, String specific, int quality, Player p) {
        if(quality>0) return SmellFeature.randomGoodFlavorText(rand, specific, p);
        if(quality<0) return SmellFeature.randomBadFlavorText(rand, specific, p);
        if(quality==0) return SmellFeature.randomNeutralFlavorText(rand, specific, p);
    }

    //passed in specific can have 'ands' in the middle
    static String randomNeutralFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The smell of $specific permeates the air. ");
        possibilities.add("Is that $specific you smell? ", .5);
        possibilities.add("There is the faint hint of $specific lingering in the air. ");

        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomGoodFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The ${p.htmlTitleBasicNoTip()} breathes deeply to appreciate the  smell of $specific. ");
        possibilities.add("The smell of $specific reminds the ${p.htmlTitleBasic()} of their childhood, somehow. ");
        possibilities.add("The intriguing smell of $specific wafts gently in the air. ");
        p.addStat(Stats.SANITY, 10);
        p.flipOutReason = null; //you are soothed
        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomBadFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The ${p.htmlTitleBasicNoTip()} is almost gagging on the smell of $specific that permeates the air. ");
        possibilities.add("The smell of $specific is so thick you can almost taste it. ");
        possibilities.add("The smell of $specific is nearly unbearable. ");
        p.flipOutReason = "how terrible the smell of $specific is ";
        p.addStat(Stats.SANITY, -10);
        return rand.pickFrom(possibilities);
    }
}