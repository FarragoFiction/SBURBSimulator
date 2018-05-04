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
      //session.logger.info("DEBUG DESTROY MOON: making moon $name");
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
      killer.moonKillCount ++;
      session.logger.info("AB: Oh shit, JR! A moon is exploding! Come see this!");
      session.stats.moonDestroyed = true;
      List<String> killed = new List<String>();

      //kill the dream selves
      for(Player p in session.players) {
          if(p.moon == this && p.dreamSelf && !p.isDreamSelf) {
              print("$p died in a moon splosion");
              p.dreamSelf = false;
              Player snop = Player.makeRenderingSnapshot(p);
              snop.causeOfDeath = "after being blown up with $name.";
              snop.isDreamSelf = true;
              this.session.afterLife.addGhost(snop);
              killed.add(snop.htmlTitle());
          }else {
              print("$p did not die  in a moon splosion. Is it not their moon? They have ${p.moon} and it was $this, ${p.moon == this}");

          }
      }

      //kill the carapaces
      for(GameEntity g in associatedEntities) {
          //if you're active you'll live....but if you aren't in a players party you won't be relevant anymore.
          if(!g.active && !g.dead) {
              killed.add(g.htmlTitle());
              //don't loot shit you explode
              g.makeDead("the $name exploding.",killer, false);
          }
      }

      Element ret = new DivElement();
      String killedString  = "";
      String are = "are";
      if(killed.length == 1) are = "is";
      if(killed.isNotEmpty) killedString = "The ${turnArrayIntoHumanSentence(killed)} $are now dead.";
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

      dead = true;

      //;
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
      if(_queensRing != null) {
          _queensRing.dead = true;
          _queensRing = null;
      }
      if(name.contains("Prospit")) {
        session.prospitRing = null;
      }else {
          session.derseRing = null;
      }

  }

  //this should instantly doom the timeline.
  void destroyScepter() {
      _kingsScepter.dead = true;
      _kingsScepter = null;
  }

    void spawnQueen() {
        //;
        //hope field can fuck with the queen.
        if(session.mutator.spawnQueen(session)) return null;

        if(name.contains("Prospit")) {
            this.queen = new Carapace("White Queen", session,Carapace.PROSPIT, firstNames: <String>["Winsome","Windswept","Warweary","Wondering"], lastNames: <String>["Quasiroyal","Quakeress","Questant"],ringFirstNames: <String>["White"], ringLastNames: <String>["Queen"]);
            queen.royalty = true;
            queen.description = "Prospit's White Queen, famously kind and compassionate. She does not leave her Royal Chambers until it's time for the final battle.";
            this.queen.sylladex.add(this._queensRing);
            this.queen.name = "White Queen"; //override crowned name
        }else {
            this.queen = new Carapace("Black Queen", session,Carapace.DERSE, firstNames: <String>["Baroque","Bombastic","Bitter","Batshit","Bitchy"], lastNames: <String>["Quasiroyal","Quakeress","Quaestor"],ringFirstNames: <String>["Black"], ringLastNames: <String>["Queen"]);
            queen.royalty = true;
            queen.description = "Derses's Black Queen, famously a huge bitch. She does not leave her Royal Chambers until it's time for the final battle.";
            this.queen.sylladex.add(this._queensRing);
            this.queen.name = "Black Queen"; //override crowned name
        }

        this.queen.specibus = new Specibus("Blade", ItemTraitFactory.BLADE, [ ItemTraitFactory.QUEENLY]);
        queen.stats.setMap(<Stat, num>{Stats.HEALTH: 500, Stats.FREE_WILL: -100, Stats.POWER: 50});
        queen.heal();
    }

    Carapace get activateRandomCaparapce {
        List<Carapace> choices = new List<Carapace>();
        for(GameEntity g in associatedEntities) {
            if(g is Carapace && !g.active) {
                if(session.rand.nextDouble() < g.activationChance) choices.add(g);
            }
        }
        //;

        //always pick jack, he is the main npc
        if(choices.contains(session.npcHandler.jack)) return session.npcHandler.jack;
        return session.rand.pickFrom(choices);
    }

    Carapace get partyRandomCarapace {
        List<Carapace> choices = new List<Carapace>();
        for(GameEntity g in associatedEntities) {
            if(g is Carapace && !g.active) {
                if(session.rand.nextDouble() < g.companionChance) choices.add(g);
            }
        }
        //;

        //always pick jack, he is the main npc
        if(choices.contains(session.npcHandler.jack)) return session.npcHandler.jack;
        return session.rand.pickFrom(choices);
    }


  Carapace get randomNonActiveCarapace {
      List<Carapace> choices = new List<Carapace>();
      for(GameEntity g in associatedEntities) {
          if(g is Carapace && !g.active) {
              choices.add(g);
          }
      }
      //;

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
     // ;
      for(QuestChainFeature f in features.keys) {
         // ;
          if(f is MoonQuestChainFeature) {
              //;
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
          //;
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
        //;
        return ret;
    }
}