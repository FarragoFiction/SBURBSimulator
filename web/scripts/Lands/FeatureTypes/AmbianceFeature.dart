import "DescriptiveFeature.dart";
import "../../SBURBSim.dart";
class AmbianceFeature extends DescriptiveFeature {
    ///flavor text, "you don't get it, my land feels really $feelsLike"  creepy, unsettling, vs peaceful, calm,

    AmbianceFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);

    @override
    String toHTML() {
        return "<div class = 'feature'>Feels ${simpleDesc}, Quality: ${quality}</div>";
    }
    static String randomFlavorText(Random rand, String specific, int quality, Player p) {
        if(quality>0) return AmbianceFeature.randomGoodFlavorText(rand, specific, p);
        if(quality<0) return AmbianceFeature.randomBadFlavorText(rand, specific, p);
        if(quality==0) return AmbianceFeature.randomNeutralFlavorText(rand, specific, p);
    }

    //passed in specific can have 'ands' in the middle
    static String randomNeutralFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("");
        possibilities.add("It feels $specific.",.3);
        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomGoodFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The ${p.htmlTitleBasicNoTip()} is reassured by how $specific it feels.");
        possibilities.add("The ${p.htmlTitleBasicNoTip()} feels right at home with how $specific it feels here. ", 0.5);
        possibilities.add("It feels $specific.  It's pretty great, actually. ");
        p.addStat(Stats.SANITY, 10);
        p.flipOutReason = null; //you are soothed
        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomBadFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The ${p.htmlTitleBasicNoTip()} is getting tired of how $specific it feels.", 0.5);
        possibilities.add("It's a little unsettling how $specific it feels. ");
        possibilities.add("The ${p.htmlTitleBasicNoTip()} is unnerved with how $specific it feels here.");
        p.flipOutReason = "how tired they are of how $specific everything is ";
        p.addStat(Stats.SANITY, -10);
        return rand.pickFrom(possibilities);
    }
}