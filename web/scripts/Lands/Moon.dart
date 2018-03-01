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
    Carapace king;
    Carapace queen;

    Ring queensRing = null;
    Scepter kingsScepter = null;

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
      setHP();

      this.moonQuestChains = this.getTypedSubList(FeatureCategories.MOON_QUEST_CHAIN).toList();
      this.processConsort();

  }

  @override
  Element planetsplode(GameEntity killer) {
      if(session is DeadSession) {
          (session as DeadSession).failed = true;
      }

      //KILL all non activated npcs
      //Kill all players with you as a dream moon's dream self (unless they are the dream self)
        //do i generate ghosts for this? how did i handle jack killing dream selves in old code?

      //if i'm derse, set session's derse to null, vice versa
      //render explosion graphic and text. text should describe if anyone died.
      //Rewards/derse_explode.png or Rewards/prospit_exploder.png
  }

    @override
    void setHP() {
        hp = (session.sessionHealth/2).round();
    }

  void initRelationships(Moon opposite) {
      for(GameEntity g in associatedEntities) {
          if(g is Carapace) {
              Carapace c = g as Carapace;
              c.initRelationshipsAllies(this);
              c.initRelationshipsEnemies(opposite);
              c.initRelationshipsPlayers();

          }
      }
      queen.initRelationshipsAllies(this);
      queen.initRelationshipsEnemies(opposite);
      queen.initRelationshipsPlayers();

      king.initRelationshipsAllies(this);
      king.initRelationshipsEnemies(opposite);
      king.initRelationshipsPlayers();
  }

  void destroyRing() {
      queensRing.dead = true;
      queensRing = null;
  }

  //this should instantly doom the timeline.
  void destroyScepter() {
      kingsScepter.dead = true;
      kingsScepter = null;
  }

    void spawnQueen() {
        //print("spawning queen $session");
        //hope field can fuck with the queen.
        if(session.mutator.spawnQueen(session)) return null;
        this.queensRing = new Ring.withoutOptionalParams("${name.toUpperCase()} RING OF ORBS ${session.convertPlayerNumberToWords()}FOLD",[ ItemTraitFactory.QUEENLY] );
        Fraymotif f = new Fraymotif("Red Miles", 3);
        f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
        f.desc = " You cannot escape them. ";
        this.queensRing.fraymotifs.add(f);


        if(name.contains("Prospit")) {
            this.queen = new Carapace("White Queen", session,Carapace.PROSPIT, firstNames: <String>["Winsome","Windswept","Warweary","Wondering"], lastNames: <String>["Quasiroyal","Quakeress","Questant"]);
            this.queen.sylladex.add(this.queensRing);
            this.queen.name = "White Queen"; //override crowned name
        }else {
            this.queen = new Carapace("Black Queen", session,Carapace.DERSE, firstNames: <String>["Baroque","Bombastic","Bitter","Batshit","Bitchy"], lastNames: <String>["Quasiroyal","Quakeress","Quaestor"]);
            this.queen.sylladex.add(this.queensRing);
            this.queen.name = "Black Queen"; //override crowned name
        }

        this.queen.specibus = new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.QUEENLY]);
        queen.stats.setMap(<Stat, num>{Stats.HEALTH: 500, Stats.FREE_WILL: -100, Stats.POWER: 50});
        queen.heal();
    }

    void spawnKing() {
        if(session.mutator.spawnKing(session)) return null;
        this.kingsScepter = new Scepter.withoutOptionalParams("SCEPTER",[ ItemTraitFactory.KINGLY] );
        Fraymotif f = new Fraymotif("Reckoning Meteors", 3); //TODO eventually check for this fraymotif (just lik you do troll psionics) to decide if you can start recknoing.;
        f.effects.add(new FraymotifEffect(Stats.POWER, 2, true));
        f.desc = " The very meteors from the Reckoning rain down. ";
        this.kingsScepter.fraymotifs.add(f);

        if(name.contains("Prospit")) {
            this.king = new Carapace("White King", session,Carapace.PROSPIT,firstNames: <String>["Winsome","Windswept","Warweary","Wandering","Wondering"], lastNames: <String>["Kindred","Knight","Keeper","Kisser"]);
            this.king.sylladex.add(this.kingsScepter);
            this.king.name = "White King"; //override crowned name

        }else {
            this.king = new Carapace("Black King", session,Carapace.DERSE,firstNames: <String>["Bombastic","Bitter","Batshit","Boring","Brutal"], lastNames: <String>["Keeper","Knave","Key","Killer"]);
            this.king.sylladex.add(this.kingsScepter);
            this.king.name = "Black King"; //override crowned name


        }
        this.king.specibus = new Specibus("Backup Scepter", ItemTraitFactory.STICK, [ ItemTraitFactory.KINGLY]);


        king.grist = 1000;
        king.stats.setMap(<Stat, num>{Stats.HEALTH: 1000, Stats.FREE_WILL: -100, Stats.POWER: 100});
        king.heal();
    }

  Carapace get randomNonActiveCarapace {
      List<Carapace> choices = new List<Carapace>();
      for(GameEntity g in associatedEntities) {
          if(g is Carapace && !g.active) {
              choices.add(g);
          }
      }
      //print("getting a random carapace from $choices");

      //always pick jack, he is the main npc
      if(choices.contains(session.npcHandler.jack)) return session.npcHandler.jack;
      return session.rand.pickFrom(choices);
  }

  //your moon is me
  List<Player> get players {
      List<Player> ret = new List<Player>();
      for(Player p in session.players) {
          if(p.moon == this) {
              ret.add(p);
          }
      }
      return ret;
  }

  //has a dream self and also is not a dream self.
  List<Player> get playersOnMoon {
      List<Player> ret = new List<Player>();
      List playerList = players;
      for(Player p in playerList) {
          if(!p.isDreamSelf && p.dreamSelf) {
              ret.add(p);
          }
      }
      return ret;
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