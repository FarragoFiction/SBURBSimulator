import "../SBURBSim.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
///A land is build from features.
class Land {
    bool corrupted;
    //can be more than one thing, will pick one or two things at random by weight
    WeightedList<SmellFeature> smells = new WeightedList<SmellFeature>();
    WeightedList<SoundFeature> sounds = new WeightedList<SoundFeature>();
    WeightedList<AmbianceFeature> feels = new WeightedList<AmbianceFeature>();
    //two strongest themes in this land.
    Theme mainTheme;
    Theme secondaryTheme;
    String name;

    NPC consort;

    //TODO need to have pre, during and post denizen quest chains as well. but that's second pass through shit.

    ///I expect a player to call this after picking a single theme from class, from aspect, and from each interest
    /// since the weights are copied here, i can modify them without modifying their source. i had been worried about that up unil i got this far.
    Land.fromWeightedThemes(Map<Theme, double> themes, Session session){
        if(themes == null) return; //just make an empty land. (nneeded for dead sessions);
        List<Theme> themeList = new List.from(themes.keys);
        print ("theme list is $themeList");
        Theme strongestTheme = themeList[0];  //for picking name
        Theme secondStrongestTheme = themeList[0];  //for picking name
        //IMPORTANT: when you are storing to these, make the weight already modified by the themes random modifier.
        //random modifiers are so interests arne't just flat out ignored 100% of the time.
        Map<Feature, double> corruptionFeatures = new Map<Feature, double>();
        Map<Feature, double> smellsFeatures = new Map<Feature, double>();
        Map<Feature, double> soundsFeatures = new Map<Feature, double>();
        Map<Feature, double> feelsFeatures = new Map<Feature, double>();
        Map<Feature, double> consortFeatures = new Map<Feature, double>();

        for(Theme t in themes.keys) {
            print("Theme is $t");
            double weight = themes[t] + session.rand.nextInt(Theme.MEDIUM.toInt()); //play around with max value of rand num
            if(weight > themes[strongestTheme]) {
                secondStrongestTheme = strongestTheme; //previous strongest is num 2 now
                strongestTheme = t; //you are the winnar.
            }
            for(Feature f in t.features.keys) {
                print("checking feature $f"); //oh look, they are all null. WHAT THE FUCK.
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
        processConsorts(session, consortFeatures);
        processCorruption(corruptionFeatures);
        processFeels(feelsFeatures);
    }


    //smells are weighted but only pick the strongest ones
    void processSmells( Map<Feature, double> features) {
        if(features.keys.isEmpty) features[FeatureFactory.NOTHINGSMELL] = 1.0;

        for(SmellFeature f in features.keys) {
            smells.add(f, features[f]);
        }
    }

    //TODO reject if weight too low.
    void processSounds( Map<Feature, double> features) {
        if(features.keys.isEmpty) features[FeatureFactory.SILENCE] = 1.0;

        for(SoundFeature f in features.keys) {
            sounds.add(f, features[f]);
        }
    }

    void processCorruption( Map<Feature, double> features) {
        if(features.keys.isNotEmpty) corrupted = true; //can not escape
    }

    void processConsorts(Session s,  Map<Feature, double> features) {
        if(features.keys.isEmpty) features[FeatureFactory.getRandomConsortFeature(s.rand)] = 1.0;
        WeightedList<ConsortFeature> consorts = new WeightedList<ConsortFeature>();
        for(ConsortFeature f in features.keys) {
            consorts.add(f, features[f]);
        }
        ConsortFeature chosen = s.rand.pickFrom(consorts);
        consort = chosen.makeConsort(s);
    }

    void processFeels(Map<Feature, double> features) {
        if(features.keys.isEmpty) features[FeatureFactory.NOTHINGFEELING] = 1.0;

        for(AmbianceFeature f in features.keys) {
            feels.add(f, features[f]);
        }
    }

    void modifySanityByQuality(Player p, int quality) {
        if(quality >0) {
            p.addStat(Stats.SANITY, 1);
        }else if(quality < 0) {
            p.addStat(Stats.SANITY, -1);
        }
    }

    String smellFlavorText(Random rand, Player p) {
        SpecificQualia qualia = smellsLike(rand, p);
        return SmellFeature.randomFlavorText(rand, qualia.desc, qualia.quality, p);

    }

    String soundFlavorText(Random rand, Player p) {


    }

    String feelingFlavorText(Random rand, Player p) {

    }

    String consortFlavorText(Random rand, Player p) {

    }

    ///if you pass me a player i will modify their sanity based on if it's a good or bad smell.
    ///pick from a random smell associated with this land, weighted by smell strength
    ///only pass a player if you want html
    SpecificQualia smellsLike(Random rand, [Player p]) {
        SmellFeature mainSmell = rand.pickFrom(smells);
        SmellFeature secondarySmell;
        if(rand.nextDouble()>.75) secondarySmell = rand.pickFrom(smells);
        if(secondarySmell == mainSmell) secondarySmell = null;
        int quality = mainSmell.quality;
        String ret = mainSmell.simpleDesc;
        if(secondarySmell != null) {
            ret = "$ret and ${secondarySmell.simpleDesc}.";
            quality += secondarySmell.quality;
        }
        if(p != null) modifySanityByQuality(p, quality);
        return new SpecificQualia(ret, quality);
    }

    SpecificQualia feelsLike(Random rand, [Player p]) {
        AmbianceFeature main = rand.pickFrom(feels);
        AmbianceFeature secondary;
        if(rand.nextDouble()>.75) secondary = rand.pickFrom(feels);
        if(secondary == main) secondary = null;
        int quality = main.quality;
        String ret = main.simpleDesc;
        if(secondary != null) {
            ret = "$ret and ${secondary.simpleDesc}";
            quality += secondary.quality;
        }else {
            ret = "$ret";
        }
        if(p != null) modifySanityByQuality(p, quality);
        return new SpecificQualia(ret, quality);
    }


    SpecificQualia soundsLike(Random rand, [Player p]) {
        SmellFeature mainSmell = rand.pickFrom(smells);
        SmellFeature secondarySmell;
        if(rand.nextDouble()>.75) secondarySmell = rand.pickFrom(smells);
        if(secondarySmell == mainSmell) secondarySmell = null;
        int quality = mainSmell.quality;
        String ret = mainSmell.simpleDesc;
        if(secondarySmell != null) {
            ret = "$ret and ${secondarySmell.simpleDesc}";
            quality += secondarySmell.quality;
        }else {
            ret = "$ret";
        }
        if(p != null) modifySanityByQuality(p, quality);
        return new SpecificQualia(ret, quality);
    }


}

class SpecificQualia {
    String desc;
    int quality;
    SpecificQualia(this.desc, this.quality);
}