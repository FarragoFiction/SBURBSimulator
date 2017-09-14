import 'Feature.dart';
/// a set of themes is meant to be used to generate a land.
/// possible have a sub class of DeadTheme intended to be for dead sessions, with higher weighting and sports/game motifs.
class Theme {
    ///extremely related name, like 'vaults/banks/safes/hoardes'.  or 'wind/gales/gusts/breeze'
    List<String> possibleNames = new List<String>();
    ///expect there to be different types of features in here. the double is the weight of the feature
    ///highly weighted features are more likely to make it into the final land
    ///lower weighted features will only make it in if there are other themes that support it.
    Map<Feature, double> features = new Map<Feature, double>();

    /*TODO have a thingy meant to help with picking this theme in a quiz
        Like, you pick your class, aspect, and interests.
        and then within each of those 4 things, you answer quiz questions to pick a single theme out of it
        (or a couple if the quiz is going on too long)
        and then generate a land from it with picture, and description and
        a SHAREABLE URL so ppl can show off their lands. have the whole thing be canvas so they can save as png, too.
     */
}