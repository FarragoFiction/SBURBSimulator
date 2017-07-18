part of SBURBSim;
abstract class Scene {
  Session session;
  bool canRepeat = true;
  List<Player> playerList = new List<Player>(); //eventually get rid of this, but not today
  Scene(this.session); //eventually take in session.


  //each scene should know how to be triggered.
  bool trigger(List<Player> playerList);

  //each scene should handle rendering itself, whether via text or canvas
  void renderContent(var div);


  //TODO maybe things that used to be global methods in  scene ccontroller can be static methods here
  //don't need a separate thing.  scene_controller's make scenes for session is a natural fit here.
  //but like, only things related to scenes, not all the shitty things I added just so i'd have them
  //  like ocdatastring shit.

  static void createScenesForSession(Session session){
    session.scenes = [new StartDemocracy(session), new JackBeginScheming(session), new KingPowerful(session), new QueenRejectRing(session), new GiveJackBullshitWeapon(session), new JackPromotion(session), new JackRampage(session)];
    //relationship drama has a high priority because it can distract a session from actually making progress. happened to universe a trolls.
    session.scenes.addAll([new QuadrantDialogue(session),new FreeWillStuff(session),new GrimDarkQuests(session),new Breakup(session), new RelationshipDrama(session), new UpdateShippingGrid(session),  new EngageMurderMode(session), new GoGrimDark(session),  new DisengageMurderMode(session),new MurderPlayers(session),new BeTriggered(session),]);
    session.scenes.addAll([new VoidyStuff(session), new FaceDenizen(session), new DoEctobiology(session), new LuckStuff(session), new DoLandQuest(session)]);
    session.scenes.addAll([new SolvePuzzles(session), new ExploreMoon(session)]);
    session.scenes.addAll([new LevelTheHellUp(session)]);

    //make sure kiss, then godtier, then godtierrevival, then any other form of revival.
    //make sure life stuff happens AFTER a chance at god tier, or life players PREVENT god tiering.
    session.deathScenes = [ new SaveDoomedTimeLine(session), new GetTiger(session), new CorpseSmooch(session), new GodTierRevival(session), new LifeStuff(session)];  //are always available.
    session.reckoningScenes = [new FightQueen(session), new FightKing(session)];

    //scenes can add other scenes to available scene list. (for example, spy missions being added if Jack began scheming)
    session.available_scenes = []; //remove scenes from this if they get used up.
    //make non shallow copy.
    for(num i = 0; i<session.scenes.length; i++){
      session.available_scenes.add(session.scenes[i]);
    }
  }

  //makes copy of player list (no shallow copies!!!!)
  static List<Player> setAvailablePlayers(List<Player> playerList, Session session){
    session.availablePlayers = [];
    for(num i = 0; i<playerList.length; i++){
      //dead players are always unavailable.
      if(!playerList[i].dead){
        session.availablePlayers.add(playerList[i]);
      }
    }
    return session.availablePlayers;
  }

  //TODO got rid of 1 entirely because haven't supported 1.0 in a while, so rename this when done.
  static void processScenes2(List<Player> playerList, Session session){
    //print("processing scene");
    //querySelector("#story").append("processing scene");
    setAvailablePlayers(playerList,session);
    for(num i = 0; i<session.available_scenes.length; i++){
      var s = session.available_scenes[i];
      //var debugQueen = queenStrength;
      if(s.trigger(playerList)){
        //session.scenesTriggered.add(s);
        session.numScenes ++;
        s.renderContent(session.newScene());
        if(!s.canRepeat){
          //removeFromArray(s,session.available_scenes);
          session.available_scenes.remove(s);
        }
      }
    }

    for(num i = 0; i<session.deathScenes.length; i++){
      var s = session.deathScenes[i];
      if(s.trigger(playerList)){
        //	session.scenesTriggered.add(s);
        session.numScenes ++;
        s.renderContent(session.newScene());
      }
    }


  }


  //TODO got rid of 1 entirely because haven't supported 1.0 in a while, so rename this when done.
  static void processReckoning2(playerList, session){
    for(num i = 0; i<session.reckoningScenes.length; i++){
      var s = session.reckoningScenes[i];
      if(s.trigger(playerList)){
        //session.scenesTriggered.add(s);
        session.numScenes ++;
        s.renderContent(session.newScene());
      }
    }

    for(num i = 0; i<session.deathScenes.length; i++){
      var s = session.deathScenes[i];
      if(s.trigger(playerList)){
        //	session.scenesTriggered.add(s);
        session.numScenes ++;
        s.renderContent(session.newScene());
      }
    }
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



}