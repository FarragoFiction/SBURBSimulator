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
        Theme strongestTheme;  //for picking name
        Theme secondStrongestTheme;  //for picking name
        //IMPORTANT: when you are storing to these, make the weight already modified by the themes random modifier.
        //random modifiers are so interests arne't just flat out ignored 100% of the time.
        Map<Feature, double> corruptionFeatures;
        Map<Feature, double> smellsFeatures;
        Map<Feature, double> soundsFeatures;
        Map<Feature, double> feelsFeatures;
        Map<Feature, double> consortFeatures;

        for(Theme t in themes.keys) {
            double weight = themes[t] + session.rand.nextInt(Theme.MEDIUM.toInt()); //play around with max value of rand num
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

        //TODO: go through the new maps and pick the heaviest weighted feature. if multiple have same weight, then use all of them.
        //do bools let you add them natively or will i have to write a thing.


    }


}