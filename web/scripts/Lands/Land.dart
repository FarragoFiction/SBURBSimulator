import "../SBURBSim.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/EnemyFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/CorruptionFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "dart:html";
///A land is build from features.
class Land {
    Session session;
    bool corrupted;
    //can be more than one thing, will pick one or two things at random by weight
    WeightedList<SmellFeature> smells = new WeightedList<SmellFeature>();
    WeightedList<SoundFeature> sounds = new WeightedList<SoundFeature>();
    WeightedList<AmbianceFeature> feels = new WeightedList<AmbianceFeature>();

    QuestChainFeature currentQuestChain;
    //IMPORTANT i expect any quest chain that has the default trigger to be weighted very low, and everything else equal. TODO take care of this when creating land
    WeightedList<PreDenizenQuestChain> firstQuests = new WeightedList<PreDenizenQuestChain>();
    WeightedList<DenizenQuestChain> secondQuests = new WeightedList<DenizenQuestChain>();
    WeightedList<PostDenizenQuestChain> thirdQuests = new WeightedList<PostDenizenQuestChain>();

    bool firstCompleted = false;
    bool secondCompleted = false;
    bool thirdCompleted = false;

    String symbolicMcguffin;
    String physicalMcguffin;

    //two strongest themes in this land.
    Theme mainTheme;
    Theme secondaryTheme;
    String name;
    bool noMoreQuests = false; //no more infinite quests yo.
    //TODO  keep current questChain in a var. if there is none, go to PreDenizenChains and pick one.
    //if there is a stored questChain, see if it's beaten. if it is, pick chain from next set.  if it's not, do a quest from it.

    ConsortFeature consortFeature;
    DenizenFeature denizenFeature;

    String initQuest(List<Player> players) {
        if(symbolicMcguffin == null) decideMcGuffins(players.first);
        if(noMoreQuests) return "";
        //first, do i have a current quest chain?
        if(currentQuestChain == null) currentQuestChain = selectQuestChainFromSource(players, firstQuests);
        //ask my quest chain if it's finished. if it is, go to the next set of quest chains
        decideIfTimeForNextChain(players); //will pick next chain if this is done.
    }

    String get shortName {
        RegExp exp = new RegExp(r"""\b(\w)""", multiLine: true);
        return joinMatches(exp.allMatches(name)).toUpperCase();
    }

    String getChapter() {
        return "<h3>$shortName ${currentQuestChain.name}, Part ${currentQuestChain.chapter}: </h3>";
    }

    bool doQuest(Element div, Player p1, Player p2) {
        // the chain will handle rendering it, as well as calling it's reward so it can be rendered too.
        bool ret = currentQuestChain.doQuest(p1, p2, denizenFeature, consortFeature, symbolicMcguffin, physicalMcguffin, div, this);
        if(currentQuestChain.finished) decideIfTimeForNextChain(<Player>[p1,p2]); //need to mark appropriate bool as completed.
        print("ret is $ret from $currentQuestChain");
        return ret;
    }

    void decideMcGuffins(Player p1) {
        symbolicMcguffin = session.rand.pickFrom(p1.aspect.symbolicMcguffins);
        physicalMcguffin = session.rand.pickFrom(p1.aspect.physicalMcguffins);
    }

    void decideIfTimeForNextChain(List<Player> players) {
        if(currentQuestChain.finished) {
            if(currentQuestChain is PreDenizenQuestChain) {
                print("moving on to next set of quests");
                firstCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, secondQuests);
            }else if(currentQuestChain is DenizenQuestChain) {
                print("moving on to next set of quests");
                secondCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, thirdQuests);
            }else{
                print("no more quests for $name");
                thirdCompleted = true;
                noMoreQuests = true;
                currentQuestChain = null;
            }
        }
    }

    // select a random quest from source. it HAS to be triggered, though.
    // So go through first and check the trigger, and that are false, remove.
    // then pick randomly from remainder.
    QuestChainFeature selectQuestChainFromSource(List<Player> players, WeightedList<QuestChainFeature> source) {
        print("Selecting a quest from $source");
        if(source.isEmpty) {
            currentQuestChain = null;
            noMoreQuests = true;
        }
        //Step one, check all for condition. if your condition is met , you make it to round 2.
       // WeightedList<QuestChainFeature> valid = (source.where((QuestChainFeature c) => c.condition(p1)).toList() as WeightedList);
        WeightedList<QuestChainFeature> valid = new WeightedList<QuestChainFeature>();
        for(QuestChainFeature q in source) {
            WeightPair<QuestChainFeature> p = source.getPair(source.indexOf(q));
            //TODO make work for multiple players post DEAD Sessions
            if(q.condition(players)) valid.add(q,  p.weight);
        }
        return session.rand.pickFrom(valid);
    }

    void pickName(Map<Theme, double> themes) {
        WeightedList<Theme> themeList = new WeightedList<Theme>();
        for(Theme t in themes.keys) {
            themeList.add(t, themes[t]);
        }
        Theme main = session.rand.pickFrom(themeList);
        themeList.remove(main);
        Theme secondary = session.rand.pickFrom(themeList);
        name = "Land of ${session.rand.pickFrom(main.possibleNames)} and ${session.rand.pickFrom(secondary.possibleNames)}";
    }


    ///I expect a player to call this after picking a single theme from class, from aspect, and from each interest
    /// since the weights are copied here, i can modify them without modifying their source. i had been worried about that up unil i got this far.
    ///pass in an aspect so i can make denizens.
    Land.fromWeightedThemes(Map<Theme, double> themes, this.session, Aspect a){
       // print("making a land for session $session");
        if(themes == null) return; //just make an empty land. (nneeded for dead sessions);
        //IMPORTANT: when you are storing to these, make the weight already modified by the themes random modifier.
        //random modifiers are so interests arne't just flat out ignored 100% of the time.
        pickName(themes);
        Map<Feature, double> corruptionFeatures = new Map<Feature, double>();
        Map<Feature, double> smellsFeatures = new Map<Feature, double>();
        Map<Feature, double> soundsFeatures = new Map<Feature, double>();
        Map<Feature, double> feelsFeatures = new Map<Feature, double>();
        Map<Feature, double> consortFeatures = new Map<Feature, double>();
        Map<Feature, double> preDenFeatures = new Map<Feature, double>();
        Map<Feature, double> denFeatures = new Map<Feature, double>();
        Map<Feature, double> postDenFeatures = new Map<Feature, double>();
        Map<Feature, double> denizenFeatures = new Map<Feature, double>();
        //Instead, all you're doing here is collating them.  it's up to future JR to make sure quest chains from class are all post denizen and etc if that's a thing future JR cares about.
        for(Theme t in themes.keys) {
            //print("Theme is $t");
            double weight = themes[t] + session.rand.nextInt(Theme.MEDIUM.toInt()); //play around with max value of rand num
            //print("Weight for theme $t is $weight");
            for(Feature f in t.features.keys) {
                double w = weight * t.features[f];
                //print("weight for feature $f is $w");
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
                }else if(f is PostDenizenQuestChain){
                    if(postDenFeatures[f] == null) {
                        postDenFeatures[f] = w;
                    }else {
                        postDenFeatures[f] += w;
                    }
                }else if(f is DenizenQuestChain){
                    if(consortFeatures[f] == null) {
                        denFeatures[f] = w;
                    }else {
                        denFeatures[f] += w;
                    }
                }else if(f is PreDenizenQuestChain){
                    if(preDenFeatures[f] == null) {
                        preDenFeatures[f] = w;
                    }else {
                        preDenFeatures[f] += w;
                    }
                }else if(f is DenizenFeature){
                    if(denizenFeatures[f] == null) {
                        denizenFeatures[f] = w;
                    }else {
                        denizenFeatures[f] += w;
                    }
                }
            }
        }//done for loop omg.

        processSmells(smellsFeatures);
        processSounds(soundsFeatures);
        processConsorts(session, consortFeatures);
        processCorruption(corruptionFeatures);
        processFeels(feelsFeatures);
        processPreDenizenQuests(preDenFeatures);
        processDenizenQuests(denFeatures);
        processPostDenizenQuests(postDenFeatures);
        processDenizenFeatures(denizenFeatures,a);
        //print("Should have gotten predenizen quests");
    }

    void processDenizenFeatures( Map<Feature, double> features, Aspect a) {
        WeightedList<DenizenFeature> choices = new WeightedList<DenizenFeature>();
        for(DenizenFeature f in features.keys) {
            choices.add(f, features[f]);
        }
        denizenFeature = session.rand.pickFrom(choices);
        //pick random one from aspect.
        if(denizenFeature == null) {
            denizenFeature = new DenizenFeature("Denizen ${session.rand.pickFrom(a.denizenNames)}");
        }
    }
    //IMPORTANT clone things here or lands using the same themes will step on each other's toes in terms of quest progression.
    void processPreDenizenQuests( Map<Feature, double> features) {
        for(PreDenizenQuestChain f in features.keys) {
            print("pre denizen feature: $f with weight ${features[f]}");
            firstQuests.add(f.clone(), features[f]);
        }
    }

    void processDenizenQuests( Map<Feature, double> features) {
        for(DenizenQuestChain f in features.keys) {
            secondQuests.add(f.clone(), features[f]);
        }
    }

    void processPostDenizenQuests( Map<Feature, double> features) {
        for(PostDenizenQuestChain f in features.keys) {
            thirdQuests.add(f.clone(), features[f]);
        }
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
        consortFeature = s.rand.pickFrom(consorts);
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

    String randomFlavorText(Random rand, Player p) {
        double randomNum = rand.nextDouble();
        if(randomNum > .75) {
            return smellFlavorText(rand, p);
        }else if(randomNum > .5) {
            return soundFlavorText(rand, p);
        }else if (randomNum > .25) {
            return feelingFlavorText(rand, p);
        }else {
            return consortFlavorText(rand, p);
        }
    }

    String smellFlavorText(Random rand, Player p) {
        SpecificQualia qualia = smellsLike(rand, p);
        return SmellFeature.randomFlavorText(rand, qualia.desc, qualia.quality, p);

    }

    String soundFlavorText(Random rand, Player p) {
        SpecificQualia qualia = soundsLike(rand, p);
        return SoundFeature.randomFlavorText(rand, qualia.desc, qualia.quality, p);
    }

    String feelingFlavorText(Random rand, Player p) {
        SpecificQualia qualia = feelsLike(rand, p);
        return AmbianceFeature.randomFlavorText(rand, qualia.desc, qualia.quality, p);
    }

    String consortFlavorText(Random rand, Player p) {
        return consortFeature.randomNeutralFlavorText(rand, p);
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
            ret = "$ret and ${secondarySmell.simpleDesc}";
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
        SoundFeature main = rand.pickFrom(sounds);
        SoundFeature secondary;
        if(rand.nextDouble()>.75) secondary = rand.pickFrom(sounds);
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


}

class SpecificQualia {
    String desc;
    int quality;
    SpecificQualia(this.desc, this.quality);
}