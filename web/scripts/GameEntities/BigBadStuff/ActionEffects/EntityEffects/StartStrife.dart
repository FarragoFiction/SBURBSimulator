import "../../../../SBURBSim.dart";
import 'dart:html';

//no chance to survive, no strife no anything. it's a red miles situation
//not really any details, or modifiers
class StartStrife extends EffectEntity {
    @override
    String name = "StartStrife";
    StartStrife(SerializableScene scene) : super(scene);


  @override
  void syncFormToMe() {
    ////does nothing since i have no personal data
  }

    @override
    void renderForm(Element divbluh) {
        setupContainer(divbluh);

        DivElement me = new DivElement();
        container.append(me);
        me.setInnerHtml("<b>Start Strife:</b> <br>Starts a regular strife. (i.e. you could lose this, unless you are unconditionally immortal). <br><br>");
        syncToForm();
    }

  @override
  void syncToForm() {
      scene.syncForm();
  }

  //all of your allies
    List<GameEntity> getTeam(List<GameEntity> entities){
      //if i don't do this it tries to add toa  list i'm currently looping in like a fucking dunk ass
      List<GameEntity> fuckingClone = new List.from(entities);
           for(GameEntity e in fuckingClone){
            entities.addAll(e.doomedTimeClones);
            for(GameEntity g in e.companionsCopy) {
                if(!g.dead) entities.add(g);
            }
        }
        return entities;
    }


  @override
  void effectEntities(GameEntity effector,List<GameEntity> entities) {
      takeCareOfStrife(entities);
  }

  void takeCareOfStrife(List<GameEntity> entities) {
        //figure out if it's two teams or three teams
      Team bigBadTeam = new Team.withName("${scene.gameEntity.htmlTitle()} and their Allies",scene.session, getTeam(<GameEntity>[scene.gameEntity]));
      bigBadTeam.canAbscond = false;
      List<GameEntity> playersAndAllies = new List<GameEntity>();
      List<GameEntity> other = new List<GameEntity>();

      for(GameEntity e in entities) {
          //no double booking
        if(!bigBadTeam.members.contains(e)) {
            if(e.alliedToPlayers) {
                playersAndAllies.add(e);
            }else {
                other.add(e);
            }
        }
      }

      Team playersTeam;
      Team othersTeam;

      if(playersAndAllies.isNotEmpty) playersTeam = new Team.withName("The Players and their Allies",scene.session, playersAndAllies);
      if(other.isNotEmpty) othersTeam = new Team(scene.session, other);

      //render text on screen what the teams are

      //start the fight
      List<Team> teams = new List<Team>();
      teams.add(bigBadTeam);
      if(playersTeam != null) teams.add(playersTeam);
      if(othersTeam != null) teams.add(othersTeam);

      Strife strife = new Strife(scene.session, teams);
      strife.startTurn(scene.myElement);
  }


  @override
  ActionEffect makeNewOfSameType() {
    return new StartStrife(scene);
  }
}