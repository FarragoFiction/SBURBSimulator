import "../SBURBSim.dart";
import "FeatureHolder.dart";
import "FeatureTypes/ConsortFeature.dart";
import "FeatureTypes/EnemyFeature.dart";
import "FeatureTypes/SmellFeature.dart";
import "FeatureTypes/AmbianceFeature.dart";
import "FeatureTypes/SoundFeature.dart";
import "FeatureTypes/QuestChainFeature.dart";
import "dart:html";
///A land is build from features.
class Land extends Object with FeatureHolder {
    //Session session; // inherited from FeatureHolder
    bool corrupted = false;
    //can be more than one thing, will pick one or two things at random by weight
    WeightedIterable<SmellFeature> smells;
    WeightedIterable<SoundFeature> sounds;
    WeightedIterable<AmbianceFeature> feels;

    //WeightedList<Feature> features = new WeightedList<Feature>(); // inherited from FeatureHolder

    QuestChainFeature currentQuestChain;
    //IMPORTANT i expect any quest chain that has the default trigger to be weighted very low, and everything else equal. TODO take care of this when creating land
    WeightedList<PreDenizenQuestChain> firstQuests;
    WeightedList<DenizenQuestChain> secondQuests;
    WeightedList<PostDenizenQuestChain> thirdQuests;
    WeightedList<QuestChainFeature> allQuestChains;

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

    ConsortFeature get consortFeature => featureSets["consort"].first;
    DenizenFeature denizenFeature;

    @override
    FeatureTemplate featureTemplate = FeatureTemplates.LAND;

    ///mid way though making this i realized i wouldn't need it. oh well.
    Land clone() {
        Land l = new Land();
        l.corrupted = corrupted;
        l.session = session;
        l.features = new WeightedList<Feature>.from(features);
        l.setFeatureSubLists();
        l.firstCompleted = firstCompleted;
        l.secondCompleted = secondCompleted;
        l.thirdCompleted = thirdCompleted;
        l.symbolicMcguffin = symbolicMcguffin;
        l.physicalMcguffin = physicalMcguffin;
        l.noMoreQuests = noMoreQuests;
        l.name = name;
        l.mainTheme = mainTheme;
        l.secondaryTheme = secondaryTheme;
        l.currentQuestChain = currentQuestChain;
        return l;
    }

    String initQuest(List<Player> players) {
        if(symbolicMcguffin == null) decideMcGuffins(players.first);
        if(noMoreQuests) return "";
        //first, do i have a current quest chain?
        if(currentQuestChain == null) currentQuestChain = selectQuestChainFromSource(players, firstQuests);
        //ask my quest chain if it's finished. if it is, go to the next set of quest chains
        decideIfTimeForNextChain(players); //will pick next chain if this is done.
    }

    @override
    String toString() {
        return name;
    }

    String get shortName {
        RegExp exp = new RegExp(r"""\b(\w)""", multiLine: true);
        return joinMatches(exp.allMatches(name)).toUpperCase();
    }

    String getChapter() {
        return "<h3>$shortName ${currentQuestChain.name}, Part ${currentQuestChain.chapter}: </h3>";
    }

    bool doQuest(Element div, Player p1, GameEntity p2) {
        //print("current quest chain is: ${currentQuestChain.name} and helper is: $p2");
        bool ret = currentQuestChain.doQuest(p1, p2, denizenFeature, consortFeature, symbolicMcguffin, physicalMcguffin, div, this);
        if(currentQuestChain.finished) {
           // session.logger.info("deciding what to do next.");
            decideHowToProcede(); //if i just finished the last quest, then i am done.
        }
        //print("ret is $ret from $currentQuestChain");
        return ret;
    }

    void decideMcGuffins(Player p1) {
        symbolicMcguffin = session.rand.pickFrom(p1.aspect.symbolicMcguffins);
        physicalMcguffin = session.rand.pickFrom(p1.aspect.physicalMcguffins);
    }

    void decideHowToProcede() {
        if(currentQuestChain.finished) {
            if(currentQuestChain is PreDenizenQuestChain) {
                //print("moving on to next set of quests");
                firstCompleted = true;
            }else if(currentQuestChain is DenizenQuestChain) {
                //print("moving on to next set of quests");
                secondCompleted = true;
            }else{
                //print("no more quests for $name");
                thirdCompleted = true;
                noMoreQuests = true;

            }
        }
    }

    void decideIfTimeForNextChain(List<GameEntity> players) {
        if(currentQuestChain.finished) {
            if(currentQuestChain is PreDenizenQuestChain) {
                //print("moving on to next set of quests");
                firstCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, secondQuests);
            }else if(currentQuestChain is DenizenQuestChain) {
                //print("moving on to next set of quests");
                secondCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, thirdQuests);
            }else{
                //print("no more quests for $name");
                thirdCompleted = true;
                noMoreQuests = true;
                currentQuestChain = null;
            }
        }
    }

    // select a random quest from source. it HAS to be triggered, though.
    // So go through first and check the trigger, and that are false, remove.
    // then pick randomly from remainder.
    QuestChainFeature selectQuestChainFromSource(List<GameEntity> players, WeightedIterable<QuestChainFeature> source) {
        //print("Selecting a quest from $source");
        if(source.isEmpty) {
            currentQuestChain = null;
            noMoreQuests = true;
        }
        //Step one, check all for condition. if your condition is met , you make it to round 2.
       // WeightedList<QuestChainFeature> valid = (source.where((QuestChainFeature c) => c.condition(p1)).toList() as WeightedList);
        WeightedList<QuestChainFeature> valid = new WeightedList<QuestChainFeature>();
        for(WeightPair<QuestChainFeature> p in source.pairs) {
            //TODO make work for multiple players post DEAD Sessions
            if(p.item.condition(players)) valid.addPair(p);
        }
        return session.rand.pickFrom(valid);
    }

    void pickName(Map<Theme, double> themes) {
        WeightedList<Theme> themeList = new WeightedList<Theme>();
        for(Theme t in themes.keys) {
            themeList.add(t, themes[t]);
        }
        Theme main = session.rand.pickFrom(themeList);
        this.mainTheme = main;
        themeList.remove(main);
        Theme secondary = session.rand.pickFrom(themeList);
        if(secondary != null) {
            name = "Land of ${session.rand.pickFrom(main.possibleNames)} and ${session.rand.pickFrom(secondary.possibleNames)}";
            this.secondaryTheme = secondary;
        }else {
            name = "Land of ${session.rand.pickFrom(main.possibleNames)} and ${session.rand.pickFrom(main.possibleNames)}";
            this.secondaryTheme = main;
        }

        if(session.rand.nextDouble() >.99) {
            corrupted = true;
            List<String> corruptWords = <String>[Zalgo.generate("Google"), Zalgo.generate("Horrorterrors"), Zalgo.generate("Glitches"), Zalgo.generate("Grimoires"), Zalgo.generate("Fluthlu"), Zalgo.generate("The Zoologically Dubious")];
            session.logger.info("Corrupt land.");
            if(session.rand.nextBool()) {
                name = "Land of ${session.rand.pickFrom(corruptWords)} and ${session.rand.pickFrom(this.secondaryTheme.possibleNames)}";
            }else {
                name = "Land of ${session.rand.pickFrom(this.mainTheme.possibleNames)} and ${session.rand.pickFrom(corruptWords)}";
            }
        }
    }

    Land() {

    }

    ///I expect a player to call this after picking a single theme from class, from aspect, and from each interest
    /// since the weights are copied here, i can modify them without modifying their source. i had been worried about that up unil i got this far.
    ///pass in an aspect so i can make denizens.
    Land.fromWeightedThemes(Map<Theme, double> themes, Session session, Aspect a, SBURBClass c){
        this.session = session;
       // print("making a land for session $session");
        if(themes == null) return; //just make an empty land. (nneeded for dead sessions);

        pickName(themes);

        this.setThemes(themes);
        this.processThemes(session.rand);
        this.setFeatureSubLists();

        this.processDenizen(a,c);
    }

    void setFeatures(WeightedList<Feature> list) {
        this.features = list;
        this.setFeatureSubLists();
    }

    void setFeatureSubLists() {
        this.smells = this.getTypedSubList(FeatureCategories.SMELL);
        this.sounds = this.getTypedSubList(FeatureCategories.SOUND);
        this.feels = this.getTypedSubList(FeatureCategories.AMBIANCE);

        this.firstQuests = this.getTypedSubList<PreDenizenQuestChain>(FeatureCategories.PRE_DENIZEN_QUEST_CHAIN).map((PreDenizenQuestChain f) => f.clone()).toList();
        this.secondQuests = this.getTypedSubList<DenizenQuestChain>(FeatureCategories.DENIZEN_QUEST_CHAIN).map((DenizenQuestChain f) => f.clone()).toList();
        this.thirdQuests = this.getTypedSubList<PostDenizenQuestChain>(FeatureCategories.POST_DENIZEN_QUEST_CHAIN).map((PostDenizenQuestChain f) => f.clone()).toList();
        this.allQuestChains = this.getTypedSubList<QuestChainFeature>(FeatureCategories.QUEST_CHAIN).map((QuestChainFeature f) => f.clone()).toList();
    }

    void processDenizen(Aspect a, SBURBClass c) {
        Iterable<Feature> choices = this.featureSets[FeatureCategories.DENIZEN.name];
        if (choices == null) { return; }
        if (!choices.isEmpty) {
            this.denizenFeature = (session.rand.pickFrom(this.featureSets["denizen"]) as DenizenFeature);
        }
        if(denizenFeature == null) {
            double roll = session.rand.nextDouble(a.difficulty + c.difficulty);
            if(roll > 0.95) {
                session.logger.info("strong denizen for $c of $a");
                denizenFeature = new EasyDenizenFeature("Denizen ${session.rand.pickFrom(DenizenFeature.strongDenizens)}");
            }else if(roll < 0.05) {
                session.logger.info("weak denizen for $c of $a");
                denizenFeature = new HardDenizenFeature("Denizen ${session.rand.pickFrom(DenizenFeature.weakDenizens)}");
            }else {
                denizenFeature = new DenizenFeature("Denizen ${session.rand.pickFrom(a.denizenNames)}");
            }
        }else { //rename it, but don't replace it because it could be a hard denizen.
            denizenFeature.name = "Denizen ${session.rand.pickFrom(a.denizenNames)}";
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