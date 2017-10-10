import "DescriptiveFeature.dart";
import "../../SBURBSim.dart";

class SoundFeature extends DescriptiveFeature {
    ///flavor text, "is getting really tired of the sound of $soundsLike"
    /// a single string, not a list since sound is very specific
    /// p self explanatory.


    //most sounds are p annoying, lets face it
    SoundFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);

    @override
    String toHTML() {
        return "<div class = 'feature'>Sounds Like ${simpleDesc}, Quality: ${quality}</div>";
    }

    static String randomFlavorText(Random rand, String specific, int quality, Player p) {
        if(quality>0) return SoundFeature.randomGoodFlavorText(rand, specific, p);
        if(quality<0) return SoundFeature.randomBadFlavorText(rand, specific, p);
        if(quality==0) return SoundFeature.randomNeutralFlavorText(rand, specific, p);
    }

    //passed in specific can have 'ands' in the middle
    static String randomNeutralFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("In the distance, you can hear $specific.");
        possibilities.add("If you focus, you can hear faint $specific.");
        possibilities.add("The air is filled with the sound of $specific. ", 0.5);

        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomGoodFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("The ${p.htmlTitleBasicNoTip()}, is soothed by the sound of $specific.");
        possibilities.add("The joyful sound of $specific fills the air.");
        possibilities.add("In the distance, you can hear the relaxing sound of $specific.");
        p.addStat(Stats.SANITY, 10);
        p.flipOutReason = null; //you are soothed
        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomBadFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("Oh god. Where is that  $specific coming from?");
        possibilities.add("The ${p.htmlTitleBasicNoTip()} is on the verge of snapping from all that fucking $specific.",0.5);
        possibilities.add("You can ALMOST ignore all the $specific that fills the air.");
        p.flipOutReason = "how terrible the sound of $specific is ";
        p.addStat(Stats.SANITY, -10);
        return rand.pickFrom(possibilities);
    }
}