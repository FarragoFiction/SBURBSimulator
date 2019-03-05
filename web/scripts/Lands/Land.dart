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

    //for a land, it will just be their player.
    //but for a MOON it will be every carapace and all associated dream selves.
    List<GameEntity> associatedEntities = new List<GameEntity>();

    bool dead = false;

    //land hp will buff royalty (if moon)
    //and will be directly compared to a Big Bad's attack power to see if it can be destroyed.
    //corruption weakens a land
    int hp = 0;
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

    ConsortFeature consortFeature;
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
        l.hp = hp;
        return l;
    }

    String initQuest(List<GameEntity> players) {
        if(symbolicMcguffin == null) decideMcGuffins(players.first as Player);
        if(noMoreQuests) return "";
        //first, do i have a current quest chain?
        if(currentQuestChain == null) currentQuestChain = selectQuestChainFromSource(players, firstQuests);
        //ask my quest chain if it's finished. if it is, go to the next set of quest chains
        decideIfTimeForNextChain(players); //will pick next chain if this is done.
    }

    String getLandText(Player player, String helperText, [bool html = true]) {
        String name = "";
        if(html) {
            name = "${player.htmlTitleWithTip()}";
        }else {
            name = "${player.htmlTitle()}";
        }
        return "${player.land.getChapter()}The $name is in the ${player.land.name}. ${player.land.randomFlavorText(session.rand, player)} $helperText";

    }

    @override
    String toString() {
        return "$name";
    }

    String get shortName {
        RegExp exp = new RegExp(r"""\b(\w)""", multiLine: true);
        return "${joinMatches(exp.allMatches(name)).toUpperCase()}";
    }

    String getChapter() {
        return "<h3>$shortName ${currentQuestChain.name}, Part ${currentQuestChain.chapter}: </h3>";
    }

    bool doQuest(Element div, Player p1, GameEntity p2) {

        bool ret = currentQuestChain.doQuest(p1, p2, denizenFeature, consortFeature, symbolicMcguffin, physicalMcguffin, div, this);
        if(currentQuestChain.finished) {
            p1.leveledTheHellUp = true;
           // session.logger.info("deciding what to do next.");
            decideHowToProcede(); //if i just finished the last quest, then i am done.
        }
        //;
        return ret;
    }

    void decideMcGuffins(Player p1) {
        symbolicMcguffin = session.rand.pickFrom(p1.aspect.symbolicMcguffins);
        physicalMcguffin = session.rand.pickFrom(p1.aspect.physicalMcguffins);
    }

    void decideHowToProcede() {
        if(currentQuestChain.finished) {
            if(currentQuestChain is PreDenizenQuestChain) {
                //;
                firstCompleted = true;
            }else if(currentQuestChain is DenizenQuestChain) {
                //;
                secondCompleted = true;
            }else{
                //;
                thirdCompleted = true;
                noMoreQuests = true;

            }
        }
    }

    void decideIfTimeForNextChain(List<GameEntity> players) {
        if(currentQuestChain.finished) {
            if(currentQuestChain is PreDenizenQuestChain) {
                //;
                firstCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, secondQuests);
            }else if(currentQuestChain is DenizenQuestChain) {
                //;
                secondCompleted = true;
                currentQuestChain = selectQuestChainFromSource(players, thirdQuests);
            }else{
                //;
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
        //;
        if(source.isEmpty) {
            currentQuestChain = null;
            noMoreQuests = true;
        }
        //Step one, check all for condition. if your condition is met , you make it to round 2.
       // WeightedList<QuestChainFeature> valid = (source.where((QuestChainFeature c) => c.condition(p1)).toList() as WeightedList);
        WeightedList<QuestChainFeature> valid = new WeightedList<QuestChainFeature>();
        for(WeightPair<QuestChainFeature> p in source.pairs) {
            //TODO make work for multiple players post DEAD Sessions
           // ;
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
       // ;
        if(themes == null) return; //just make an empty land. (nneeded for dead sessions);

        pickName(themes);

        this.setThemes(themes);
        this.processThemes(session.rand);
        this.setFeatureSubLists();

        this.processDenizen(a,c);
        this.processConsort();
        setHP();
    }

    //by default, each land has a portion of the sessions hp, though it isn't the same thing as the session's hp.
    void setHP() {
        //ironically, the way lands get set up this has the unintended effect of
        //making it so the first player has the strongest land, and the last the weakest.
        //while it's unintended, this sounds like something that would happen in glitch faq so....
        //canon.
        //wait it might only happen....huh. why are lands being made so many times?
        //first few lands have that problem, but not others. and then it thinks 9 players and not 7
        //whatever. it's not broken.
        int ratio = 1+session.players.length;
        hp = (session.sessionHealth/ratio).round();
        if(corrupted) hp = (hp/2).round();
       // ;

    }

    Element planetsplode(GameEntity killer) {
        session.logger.info("AB: Oh shit, JR! A land is exploding! Come see this!");
        session.stats.planetDestroyed = true;
        killer.landKillCount ++;
        dead = true;
        name = "Destroyed $name";

        if(session is DeadSession) {
            (session as DeadSession).failed = true;
        }
        List<String> killed = new List<String>();
        List<GameEntity> renderableTargets = new List<GameEntity>();
        //KILL the associated player (unless they have reached skaia)
        for(GameEntity g in associatedEntities) {
            if(g is Player && !g.dead) {
                Player p = g as Player;
                //land is gone, this should be only reference to it
                //p.land = null;
                if(p.aspect == Aspects.SPACE) {
                    session.stats.brokenForge = true;
                }
                if(!p.canHelp()) { //you can't leave your planet yet, you're dead, and no one can get to your body to smooch it, so dream self dead, too
                    killed.add(p.htmlTitle());
                    renderableTargets.add(p);
                    killPlayer(p, killer);
                }else if(!thirdCompleted && session.rand.nextBool()) {
                    //you happened to be on your planet even though you could have been off
                    killed.add(p.htmlTitle());
                    killPlayer(p, killer);
                    renderableTargets.add(p);
                }
                //if third IS completed, assume they are on skaia and so safe
            }
            killer.makeBigBad();
        }

        Element ret = new DivElement();
        String killedString  = "";
        String are = "are";
        if(killed.length == 1) are = "is";
        if(killed.isNotEmpty) killedString = "The ${turnArrayIntoHumanSentence(killed)} $are now dead.";
        String bb = "";
        if(killer != null) bb = killer.makeBigBad();

        ret.setInnerHtml( "The ${name} is now destroyed. $killedString $bb");
        //render explosion graphic and text. text should describe if anyone died.
        //Rewards/planetsplode.png
        if(!doNotRender) {
            ImageElement image = new ImageElement(src: "images/Rewards/planetsplode.png");
            ret.append(image);
            if(renderableTargets.isNotEmpty) {
                CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
                ret.append(canvasDiv);
                Drawing.poseAsATeam(canvasDiv, renderableTargets);
            }
        }

        return ret;
    }

    void killPlayer(Player p, GameEntity killer) {
        p.makeDead("The $name exploding.", killer);
        if(!p.dreamSelf) {
            p.isDreamSelf = true;
            //don't loot shit youe xplode
            p.makeDead("the $name exploding, and leaving no corpse behind to smooch.",killer,false);
        }
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

    void processConsort() {
        this.consortFeature = (session.rand.pickFrom(this.featureSets["consort"]) as ConsortFeature);
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
                //session.logger.info("strong denizen for $c of $a");
                denizenFeature = new EasyDenizenFeature("Denizen ${session.rand.pickFrom(DenizenFeature.strongDenizens)}");
            }else if(roll < 0.05) {
                //session.logger.info("weak denizen for $c of $a");
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