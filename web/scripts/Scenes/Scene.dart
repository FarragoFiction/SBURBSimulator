import 'AccidentallySaveDoomedTimeline.dart';
import "dart:html";
import "../SBURBSim.dart";

abstract class Scene {
  bool canRepeat = true;
  Session session;
    List<Player> playerList = new List<Player>(); //eventually get rid of this, but not today
  Scene(Session this.session, [bool this.canRepeat = true]); //eventually take in session.


  //each scene should know how to be triggered.
  bool trigger(List<Player> playerList);

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(Element div);


  //TODO maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
  //but like, only things related to scenes, not all the shitty things I added just so i'd have them
  //  like ocdatastring shit.

  static void createScenesForSession(Session session){
    session.scenes = [new GetWasted(session),new StartDemocracy(session), new JackBeginScheming(session), new KingPowerful(session), new QueenRejectRing(session), new GiveJackBullshitWeapon(session), new JackPromotion(session), new JackRampage(session)];
    //relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
    session.scenes.addAll([new QuadrantDialogue(session),new FreeWillStuff(session),new GrimDarkQuests(session),new Breakup(session), new RelationshipDrama(session), new UpdateShippingGrid(session),  new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new MurderPlayers(session),new BeTriggered(session),]);
    session.scenes.addAll([new VoidyStuff(session), new FaceDenizen(session), new DoEctobiology(session), new LuckStuff(session), new RainClone(session), new DoLandQuest(session)]);
    session.scenes.addAll([new SolvePuzzles(session), new ExploreMoon(session)]);
    session.scenes.addAll([new LevelTheHellUp(session)]);

    //make sure kiss, then godtier, then godtierrevival, then any other form of revival.
    //make sure life stuff happens AFTER a chance at god tier, or life players PREVENT god tiering.
    session.deathScenes = [new AccidentallySaveDoomedTimeline(session), new SaveDoomedTimeLine(session), new GetTiger(session), new CorpseSmooch(session), new GodTierRevival(session), new LifeStuff(session)];  //are always available.
    session.reckoningScenes = [new FightQueen(session), new FightKing(session)];

    //scenes can add other scenes to available scene list. (for example, spy missions being added if Jack began scheming)
    session.available_scenes = []; //remove scenes from this if they get used up.
    //make non shallow copy.
    for(num i = 0; i<session.scenes.length; i++){
      session.available_scenes.add(session.scenes[i]);
    }
  }

  //dead sessions are exactly like regular sessions but only 1 player in array and less scenes.
  static void createScenesForDeadSession(Session session) {
      throw("todo");
  }




  //scenes call this to know how to put together pesterlogs
  static String chatLine(start, player, line){
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

class SaveDoomedTimeLine2 {
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
  void renderContent(Element div, num i);

  Random get rand => this.session.rand;
}
