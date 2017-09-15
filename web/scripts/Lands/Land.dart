import "../SBURBSim.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
///A land is build from features.
class Land {
    bool corrupted;
    //can be more than one thing, will be all together though. smells like "rot and cinamon"
    String smellsLike;
    int smellsGood; //has an actual effect. bad feelings are a low sanity debuff, good a low sanity buff. neutral is nothing.
    String soundsLike;
    int soundsGood;//has an actual effect. bad feelings are a low sanity debuff, good a low sanity buff. neutral is nothing.
    String feelsLike;
    int feelsGood; //has an actual effect. bad feelings are a low sanity debuff, good a low sanity buff. neutral is nothing.
    //two strongest themes in this land.
    Theme mainTheme;
    Theme secondaryTheme;
    String name;

    NPC consort;

    //TODO need to have pre, during and post denizen quest chains as well. but that's second pass through shit.

    ///I expect a player to call this after picking a single theme from class, from aspect, and from each interest
    /// since the weights are copied here, i can modify them without modifying their source. i had been worried about that up unil i got this far.
    Land.fromWeightedThemes(Map<Theme, double> themes, Session session){
        /*
               Okay, so think this through and then go back to playing Hiveswap.

               What needs to happen here is that I need to sort the features  into relevant sub maps, preserving their weights (with a bit of random wiggle.

               If I find a feature that does NOT fit a sub map, then it's probably some random rendering thing and I should just save it or something? ignore for now though.
         */
        List<Theme> themeList = new List.from(themes.keys);
        Theme strongestTheme = themeList[0];  //for picking name
        Theme secondStrongestTheme = themeList[0];  //for picking name
        //IMPORTANT: when you are storing to these, make the weight already modified by the themes random modifier.
        //random modifiers are so interests arne't just flat out ignored 100% of the time.
        Map<Feature, double> corruptionFeatures;
        Map<Feature, double> smellsFeatures;
        Map<Feature, double> soundsFeatures;
        Map<Feature, double> feelsFeatures;
        Map<Feature, double> consortFeatures;

        for(Theme t in themes.keys) {
            double weight = themes[t] + session.rand.nextInt(Theme.MEDIUM.toInt()); //play around with max value of rand num
            if(weight > themes[strongestTheme]) {
                secondStrongestTheme = strongestTheme; //previous strongest is num 2 now
                strongestTheme = t; //you are the winnar.
            }
            for(Feature f in t.features.keys) {
                double w = weight * t.features[f];
                if(f is SmellFeature) {
                    if(smellsFeatures[f] == null) {
                        smellsFeatures[f] = w;
                    }else {
                        smellsFeatures[f] += w;
                    }
                }else if(f is SoundFeature){
                    if(soundsFeatures[f] == null) {
                        soundsFeatures[f] = w;
                    }else {
                        soundsFeatures[f] += w;
                    }
                }else if(f is AmbianceFeature){
                    if(feelsFeatures[f] == null) {
                        feelsFeatures[f] = w;
                    }else {
                        feelsFeatures[f] += w;
                    }
                }else if(f is CorruptionFeature){
                    if(corruptionFeatures[f] == null) {
                        corruptionFeatures[f] = w;
                    }else {
                        corruptionFeatures[f] += w;
                    }
                }else if(f is ConsortFeature){
                    if(consortFeatures[f] == null) {
                        consortFeatures[f] = w;
                    }else {
                        consortFeatures[f] += w;
                    }
                }
            }
        }//done for loop omg.

        mainTheme = strongestTheme;
        secondaryTheme = secondStrongestTheme;
        name = "Land of ${session.rand.pickFrom(mainTheme.possibleNames)} and ${session.rand.pickFrom(secondaryTheme.possibleNames)}";
        processSmells(smellsFeatures);
        processSounds(soundsFeatures);
        processConsorts(consortFeatures);
        processCorruption(corruptionFeatures);
        processFeels(feelsFeatures);



    }

    //find strongest weighted feature. if multiple are identical, do multiple with string "and separated" and smellsGood additive.
    //negative smellsGood bool is a -1, postive is +1.
    void processSmells( Map<Feature, double> features) {

    }

    void processSounds( Map<Feature, double> features) {

    }

    void processCorruption( Map<Feature, double> features) {

    }

    void processConsorts( Map<Feature, double> features) {

    }

    void processFeels( Map<Feature, double> features) {

    }

}