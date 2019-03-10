import "../SBURBSim.dart";
import "FeatureHolder.dart";
import "Land.dart";
import "dart:html";
import "FeatureTypes/QuestChainFeature.dart";


class Battlefield extends Land {

    Carapace whiteKing;
    Carapace blackKing;

    @override
    FeatureTemplate featureTemplate = FeatureTemplates.SKAIA;

    WeightedList<SkaiaQuestChainFeature> battleFieldQuestChains = new WeightedList<SkaiaQuestChainFeature>();

    Battlefield.fromWeightedThemes(String name, Map<Theme, double> themes, Session session, Aspect a) {
        //override land of x and y. you are named Prospit/derse/etc
        this.name = name;
        this.session = session;

        this.setThemes(themes);
        this.processThemes(session.rand);

        this.smells = this.getTypedSubList<SmellFeature>(FeatureCategories.SMELL);
        this.sounds = this.getTypedSubList<SoundFeature>(FeatureCategories.SOUND);
        this.feels = this.getTypedSubList<AmbianceFeature>(FeatureCategories.AMBIANCE);

        this.battleFieldQuestChains = this.getTypedSubList<SkaiaQuestChainFeature>(FeatureCategories.SKAIA_QUEST_CHAIN).toList();
        this.processConsort();
    }

    void spawnKings() {
            this.whiteKing = new Carapace("White King", session,Carapace.PROSPIT,firstNames: <String>["Winsome","Windswept","Warweary","Wandering","Wondering"], lastNames: <String>["Kindred","Knight","Keeper","Kisser"], ringFirstNames: <String>["White"], ringLastNames: ["King"]);
            whiteKing.royalty = true; //do before crowning, to avoid ab being confused
            this.whiteKing.sylladex.add(session.prospitScepter);
            this.whiteKing.name = "White King"; //override crowned name
            this.whiteKing.specibus = new Specibus("Backup Scepter", ItemTraitFactory.STICK, [ ItemTraitFactory.KINGLY]);
            whiteKing.grist = 1000;
            whiteKing.description = "The White King is destined to be defeated on Skaia's Battlefield so that the Reckoning may be started with his Scepter.";
            //white king is destined to be defeatd by black, so is much weaker base
            whiteKing.stats.setMap(<Stat, num>{Stats.HEALTH: 100, Stats.FREE_WILL: -100, Stats.POWER: 10});
            whiteKing.heal();
            whiteKing.scenesToAdd.insert(0, new StartReckoning(session));

            this.blackKing = new Carapace("Black King", session,Carapace.DERSE,firstNames: <String>["Bombastic","Bitter","Batshit","Boring","Brutal","Burger"], lastNames: <String>["Keeper","Knave","Key","Killer"], ringFirstNames: <String>["Black"], ringLastNames: ["King"]);
            blackKing.royalty = true; //do before crowning, to avoid ab being confused
            this.blackKing.sylladex.add(session.derseScepter);
            this.blackKing.name = "Black King"; //override crowned name
            blackKing.description = "The Black King is destined to defeat his counterpart on Skaia's Battlefield so that the Reckoning may be started with the twin Scepters.";
            //black king should be stronger than white king. period.
            this.blackKing.specibus = new Specibus("Backup Scepter", ItemTraitFactory.STICK, [ ItemTraitFactory.KINGLY]);
            blackKing.grist = 1000;
            blackKing.stats.setMap(<Stat, num>{Stats.HEALTH: 1000, Stats.FREE_WILL: -100, Stats.POWER: 100});
            blackKing.scenesToAdd.insert(0, new KillWhiteKing(session));
            blackKing.scenesToAdd.insert(0, new StartReckoning(session));
            blackKing.heal();

    }

    @override
    String get shortName {
        return "Skaia:";
    }

    void processBattlefieldShit( Map<QuestChainFeature, double> features) {
        // ;
        for(QuestChainFeature f in features.keys) {
            // ;
            if(f is SkaiaQuestChainFeature) {
                //;
                battleFieldQuestChains.add(f, features[f]);
            }
        }
    }

    String getChapter() {
        return "<h3>$shortName ${currentQuestChain.name}</h3>";
    }

    ///any quest chain can be done on the moon. Chain itself decides if can be repeated.
    @override
    String initQuest(List<GameEntity> players) {
        if(symbolicMcguffin == null) decideMcGuffins(players.first as Player);
        //first, do i have a current quest chain?
        if(currentQuestChain == null) {
            //;
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
        //;
        return ret;
    }


}