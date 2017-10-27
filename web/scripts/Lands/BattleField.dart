import "../SBURBSim.dart";
import "FeatureHolder.dart";
import "Land.dart";
import "dart:html";
import "FeatureTypes/QuestChainFeature.dart";


class Battlefield extends Land {
    @override
    FeatureTemplate featureTemplate = FeatureTemplates.SKAIA;

    WeightedList<SkaiaQuestChainFeature> battleFieldQuestChains = new WeightedList<SkaiaQuestChainFeature>();

    Battlefield.fromWeightedThemes(String name, Map<Theme, double> themes, Session session, Aspect a) {
        //override land of x and y. you are named Prospit/derse/etc
        this.name = name;
        this.session = session;

        this.setThemes(themes);
        this.processThemes(session.rand);

        this.smells = this.getTypedSubList(FeatureCategories.SMELL);
        this.sounds = this.getTypedSubList(FeatureCategories.SOUND);
        this.feels = this.getTypedSubList(FeatureCategories.AMBIANCE);

        this.battleFieldQuestChains = this.getTypedSubList(FeatureCategories.SKAIA_QUEST_CHAIN).toList();
    }

    @override
    String get shortName {
        return "Skaia:";
    }

    void processBattlefieldShit( Map<QuestChainFeature, double> features) {
        // print("Processing moon shit: ${features.keys}");
        for(QuestChainFeature f in features.keys) {
            // print("checking if ${f} is a moon quest.  ${f is MoonQuestChainFeature}");
            if(f is SkaiaQuestChainFeature) {
                //print("adding moon quest chain");
                battleFieldQuestChains.add(f, features[f]);
            }
        }
    }

    String getChapter() {
        return "<h3>$shortName ${currentQuestChain.name}</h3>";
    }

    ///any quest chain can be done on the moon. Chain itself decides if can be repeated.
    @override
    String initQuest(List<Player> players) {
        if(symbolicMcguffin == null) decideMcGuffins(players.first);
        //first, do i have a current quest chain?
        if(currentQuestChain == null) {
            //print("going to pick a moon quest from ${moonQuestChains}");
            currentQuestChain = selectQuestChainFromSource(players, battleFieldQuestChains);
            //nobody else can do this.
            if(!currentQuestChain.canRepeat) battleFieldQuestChains.remove(currentQuestChain);

        }


    }

    //never switch chain sets.
    @override
    bool doQuest(Element div, Player p1, GameEntity p2) {
        // the chain will handle rendering it, as well as calling it's reward so it can be rendered too.
        bool ret = currentQuestChain.doQuest(p1, p2, denizenFeature, consortFeature, symbolicMcguffin, physicalMcguffin, div, this);
        if(currentQuestChain.finished){
            currentQuestChain = null;
        }
        //print("ret is $ret from $currentQuestChain");
        return ret;
    }


}