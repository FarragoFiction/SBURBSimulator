import "dart:html";
import "../../SBURBSim.dart";

abstract class Scene {
  Session session;
  //mostly for npcs in new scene system
  GameEntity gameEntity;
  String name = "???";


  List<Player> playerList = new List<Player>(); //eventually get rid of this, but not today
  Scene(Session this.session); //eventually take in session.



  //each scene should know how to be triggered.
  bool trigger(List<Player> playerList);

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(Element div);


  //TODO maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
  //but like, only things related to scenes, not all the shitty things I added just so i'd have them
  //  like ocdatastring shit.

  static void createScenesForPlayer(Session session, Player player){
   //;
    if(session is DeadSession) {
      createScenesForDeadSession(session, player);
      return;
    }

    player.scenes = [new FuckingDie(session),new OhShitFuckWheresTheRing(session), new StrifeBigBad(session), new GetWasted(session), new QueenRejectRing(session)];
    //relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
    player.scenes.addAll([new QuadrantDialogue(session),new FreeWillStuff(session),new Gristmas(session), new GrimDarkQuests(session),new Breakup(session), new RelationshipDrama(session), new UpdateShippingGrid(session),  new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new MurderPlayers(session),new BeTriggered(session),]);
    player.scenes.addAll([new VoidyStuff(session),  new DoEctobiology(session), new LuckStuff(session), new QuestsAndStuff(session)]);
    player.scenes.addAll([new LevelTheHellUp(session)]);

    //make sure kiss, then godtier, then godtierrevival, then any other form of revival.
    //make sure life stuff happens AFTER a chance at god tier, or life players PREVENT god tiering.
    session.deathScenes = [ new SaveDoomedTimeLine(session), new GetTiger(session), new CorpseSmooch(session), new GodTierRevival(session), new LifeStuff(session)];  //are always available.
    session.reckoningScenes = [new FightQueen(session), new FightKing(session), new StrifeBigBadFinale(session)];

  }

  //dead sessions are exactly like regular sessions but only 1 player in array and less scenes. no romance, etc.
  static void createScenesForDeadSession(Session session, Player player) {
    //;
    player.scenes = [new FuckingDie(session),new DeadQuests(session),new DeadMeta(session)];
    //relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
    player.scenes.addAll([new Gristmas(session),new FreeWillStuff(session),new GrimDarkQuests(session),  new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new BeTriggered(session),]);
    player.scenes.addAll([new VoidyStuff(session), new LuckStuff(session)]);

    player.scenes.addAll([new LevelTheHellUp(session)]);

    //make sure kiss, then godtier, then godtierrevival, then any other form of revival.
    //make sure life stuff happens AFTER a chance at god tier, or life players PREVENT god tiering.
    session.deathScenes = [ new SaveDoomedTimeLine(session), new GodTierRevival(session), new LifeStuff(session)];  //are always available.
    session.reckoningScenes = [new FightQueen(session), new FightKing(session)];

    //scenes can add other scenes to available scene list. (for example, spy missions being added if Jack began scheming)

  }




  //scenes call this to know how to put together pesterlogs
  static String chatLine(String start, Player player, String line){
    if(player.grimDark  > 3){
      line = Zalgo.generate(line);
      return start + line.trim()+"\n"; //no whimsy for grim dark players
    }else if(player.grimDark  > 1){
      return start + line.trim()+"\n"; //no whimsy for grim dark players
    }else{
      return start + player.quirk.translate(line).trim()+"\n";
    }
  }

  Random get rand => this.session.rand;
}

abstract class IntroScene {
	bool canRepeat;
  Session session;
    List<Player> playerList = new List<
      Player>(); //eventually get rid of this, but not today
  IntroScene(this.session, [this.canRepeat = false]); //eventually take in session.


  //apparently can't have method overloading. blugh.
  bool trigger(List<Player> playerList, Player player);

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(Element div, int i);

  Random get rand => this.session.rand;
}
