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
    //Carapace king; king is stored on skaia, not derse/prospit
    Carapace queen;

    Ring _queensRing = null;
    Scepter _kingsScepter = null;

    @override
    FeatureTemplate featureTemplate = FeatureTemplates.MOON;
    int id; //needed so players are attached to the correct set of moons. maybe. still figuring shit out.

    Palette palette;

  Moon.fromWeightedThemes(Ring this._queensRing, Scepter this._kingsScepter, String name, Map<Theme, double> themes, Session session, Aspect a, this.id, this.palette) {
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

  Carapace get king {

      if(name.contains("Prospit")) return session.battlefield.whiteKing;
      return session.battlefield.blackKing;

  }

  //never to the point you explode tho, lower divider is stronger
  void weaken([int forceDivider = 13]) {
      hp += -1* (hp/forceDivider).floor(); //never can bring it to zero
  }

    //lower divider is stronger
    void strengthen([int forceDivider = 13]) {
        hp += 1* (hp/forceDivider).floor(); //never can bring it to zero
    }

  @override
  Element planetsplode(GameEntity killer) {

      session.logger.info("AB: Oh shit, JR! A moon is exploding! Come see this!");
      session.stats.moonDestroyed = true;
      List<String> killed = new List<String>();

      //kill the dream selves
      for(Player p in session.players) {
          //print("TEST MOON: checking to see if $p would die. ${p.moon}, has dream: ${p.dreamSelf}, is dream: ${p.isDreamSelf}");
          if(p.moon == this && p.dreamSelf && !p.isDreamSelf) {

              p.dreamSelf = false;
              Player snop = Player.makeRenderingSnapshot(p);
              snop.causeOfDeath = "after being blown up with $name.";
              snop.isDreamSelf = true;
              this.session.afterLife.addGhost(snop);
              killed.add(snop.htmlTitle());
             // print("TEST MOON: yup, they toast");
          }else {
              //print("TEST MOON: they survive.");
          }
      }

      //kill the carapaces
      for(GameEntity g in associatedEntities) {
          //if you're active you'll live....but if you aren't in a players party you won't be relevant anymore.
          if(!g.active && !g.dead) {
              killed.add(g.htmlTitle());
              g.makeDead("the $name exploding.",killer);
          }
      }

      Element ret = new DivElement();
      String killedString  = "";
      if(killed.isNotEmpty) killedString = "The ${turnArrayIntoHumanSentence(killed)} are now dead.";
      ret.setInnerHtml("${name} is now destroyed. $killedString");
      //render explosion graphic and text. text should describe if anyone died.
      //Rewards/planetsplode.png

      if(!doNotRender) {
          ImageElement image;
          if (session.derse == this) {
              image = new ImageElement(src: "images/Rewards/derse_explode.png");
          } else {
              image = new ImageElement(src: "images/Rewards/prospit_explode.png");
          }


          //can do this because it's not canvas
          //although really if my rendering pipeline were diff i could do on canvas, too.
          image.onLoad.listen((e) {
              ret.append(image);
          });
      }

      //if i ever want fanon moons, will need it to be an array instead. whatever.
      if(this == session.derse) {
          //print("TEST MOON: setting derse to null");
          session.derse = null;
      }
      if(this == session.prospit) session.prospit = null;
      //print("i think i blew up a moon and am returning $ret with ${ret.text}");
      return ret;

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

      if(name.contains("Derse")) {
          session.battlefield.blackKing.initRelationshipsAllies(this);
          session.battlefield.blackKing.initRelationshipsEnemies(opposite);
          session.battlefield.blackKing.initRelationshipsPlayers();
      }else {
          session.battlefield.whiteKing.initRelationshipsAllies(this);
          session.battlefield.whiteKing.initRelationshipsEnemies(opposite);
          session.battlefield.whiteKing.initRelationshipsPlayers();
      }
  }

  void destroyRing() {
      _queensRing.dead = true;
      _queensRing = null;
  }

  //this should instantly doom the timeline.
  void destroyScepter() {
      _kingsScepter.dead = true;
      _kingsScepter = null;
  }

    void spawnQueen() {
        //print("spawning queen $session");
        //hope field can fuck with the queen.
        if(session.mutator.spawnQueen(session)) return null;

        if(name.contains("Prospit")) {
            this.queen = new Carapace("White Queen", session,Carapace.PROSPIT, firstNames: <String>["Winsome","Windswept","Warweary","Wondering"], lastNames: <String>["Quasiroyal","Quakeress","Questant"]);
            queen.royalty = true;
            this.queen.sylladex.add(this._queensRing);
            this.queen.name = "White Queen"; //override crowned name
        }else {
            this.queen = new Carapace("Black Queen", session,Carapace.DERSE, firstNames: <String>["Baroque","Bombastic","Bitter","Batshit","Bitchy"], lastNames: <String>["Quasiroyal","Quakeress","Quaestor"]);
            queen.royalty = true;
            this.queen.sylladex.add(this._queensRing);
            this.queen.name = "Black Queen"; //override crowned name
        }

        this.queen.specibus = new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.QUEENLY]);
        queen.stats.setMap(<Stat, num>{Stats.HEALTH: 500, Stats.FREE_WILL: -100, Stats.POWER: 50});
        queen.heal();
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