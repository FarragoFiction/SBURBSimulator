import "../Feature.dart";
import "../../SBURBSim.dart";
class AmbianceFeature extends Feature {
    ///flavor text, "you don't get it, my land feels really $feelsLike"  creepy, unsettling, vs peaceful, calm,

    AmbianceFeature(String simpleDesc, [int quality = 0]):super(simpleDesc, quality);

    //TODO when this is called "normally" each player can react to a different feature of the land. so only one player at a time

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