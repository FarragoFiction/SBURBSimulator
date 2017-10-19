import "../SBURBSim.dart";
import "FeatureHolder.dart";
import "Land.dart";
import "dart:html";


import "FeatureTypes/QuestChainFeature.dart";
/**
 * Session has a list of all possible moons, which it passes to a player when it assigns them a moon.
 *
 * A moon allows you to do as many questChains as are available, with repeats.
 *
 * Quest chains can be ADDED to a moon. (for example, NPC update might have a meeting with WV add "weaken queen" chain)
 *
 * TODO If a moon is destroyed, all dream selves beloning to the moon are destroyed as well.
 * This means a moon should have a list of dream selves on it, when the NPC update is a thing.
 */
class Moon extends Land {
    WeightedList<MoonQuestChainFeature> moonQuestChains = new WeightedList<MoonQuestChainFeature>();

    @override
    FeatureTemplate featureTemplate = FeatureTemplates.MOON;
    int id; //needed so players are attached to the correct set of moons. maybe. still figuring shit out.

    Palette palette;

  Moon.fromWeightedThemes(String name, Map<Theme, double> themes, Session session, Aspect a, this.id, this.palette) {
      //override land of x and y. you are named Prospit/derse/etc
      this.name = name;
      this.session = session;

      this.setThemes(themes);
      this.processThemes(session.rand);

      this.smells = this.getTypedSubList(FeatureCategories.SMELL);
      this.sounds = this.getTypedSubList(FeatureCategories.SOUND);
      this.feels = this.getTypedSubList(FeatureCategories.AMBIANCE);

      this.moonQuestChains = this.getTypedSubList(FeatureCategories.MOON_QUEST_CHAIN).toList();
  }

  @override
    String get shortName {
        return "Strange Dreams:";
    }

  void processMoonShit( Map<QuestChainFeature, double> features) {
     // print("Processing moon shit: ${features.keys}");
      for(QuestChainFeature f in features.keys) {
         // print("checking if ${f} is a moon quest.  ${f is MoonQuestChainFeature}");
          if(f is MoonQuestChainFeature) {
              //print("adding moon quest chain");
              moonQuestChains.add(f, features[f]);
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
          currentQuestChain = selectQuestChainFromSource(players, moonQuestChains);
          //nobody else can do this.
          if(!currentQuestChain.canRepeat) moonQuestChains.remove(currentQuestChain);

      }


  }

     //never switch chain sets.
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