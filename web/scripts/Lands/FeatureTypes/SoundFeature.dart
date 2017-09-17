import "../Feature.dart";
import "../../SBURBSim.dart";

class SoundFeature extends Feature {
    ///flavor text, "is getting really tired of the sound of $soundsLike"
    /// a single string, not a list since sound is very specific
    /// p self explanatory.


    //most sounds are p annoying, lets face it
    SoundFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);

    //passed in specific can have 'ands' in the middle
    static String randomNeutralFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();
        possibilities.add("");

        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomGoodFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();

        return rand.pickFrom(possibilities);
    }

    //passed in specific can have 'ands' in the middle
    static String randomBadFlavorText(Random rand, String specific, Player p) {
        WeightedList<String> possibilities = new WeightedList<String>();

        return rand.pickFrom(possibilities);
    }
}