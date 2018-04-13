import "../../SBURBSim.dart";
import 'dart:html';

//name says it all, players better find the rings before the reckoning ends

class OhShitFuckWheresTheRing extends Scene {
    OhShitFuckWheresTheRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      gameEntity.available = false;
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      GameEntity bqowner = session.derseRing == null  ?  null:session.derseRing.owner;
      GameEntity wqowner =  session.prospitRing == null  ?  null:session.prospitRing.owner;

      if(bqowner != null && !bqowner.alliedToPlayers) {
          Element container = new DivElement();
          me.append(container);
          GameEntity blackQueen = session.derse == null  ?  null:session.derse.queen;
          startFight(div, bqowner, session.derseRing, blackQueen);
      }

      if(wqowner != null && !wqowner.alliedToPlayers) {
          Element container = new DivElement();
          me.append(container);
          GameEntity whiteQueen = session.prospit == null  ?  null:session.prospit.queen;
          startFight(div, wqowner, session.prospitRing, whiteQueen);
      }
      div.append(me);
  }

    List<GameEntity> getGoodGuys(){
        List<GameEntity>  living = findLiving(this.session.players);
        List<GameEntity>  allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

        for(num i = 0; i<allPlayers.length; i++){
            living.addAll(allPlayers[i].doomedTimeClones);
            for(GameEntity g in allPlayers[i].companionsCopy) {
                if(g is Player && !g.dead) living.add(g);
            }

        }
        return living;
    }


    void renderGoodguys(Element div){
        num ch = canvasHeight;
        List<Player> fightingPlayers = this.getGoodGuys();
        if(fightingPlayers.length > 6){
            ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
        }
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, fightingPlayers);
    }

  void startFight(Element div, GameEntity target, Ring ring, GameEntity whoSHOULDHaveIt) {
      this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
      String text = "";
      if(target == whoSHOULDHaveIt) {
          text = "<img src = 'images/sceneIcons/bq_icon.png'> The ${target.htmlTitle()} is ready to fulfill her role as the players penultimate challenge. ";
      }else {
          text = "Huh. Well. The ${target.htmlTitle()} is DEFINITELY not a Carapace Queen. You are blown away by this stunning revelation.  Who knew that the Main Quest of SBURB could go off the rails like that???  Either way, they have to be taken out, or the game cannot be beaten. The Players prepare for an epic boss fight.";
      }

      div.setInnerHtml(text);

      List<GameEntity> fighting = this.getGoodGuys();

      for(GameEntity g in fighting) {
        g.available = false;
      }

      Team pTeam = new Team.withName("The Players",this.session, fighting);
      pTeam.canAbscond = false;
      Team dTeam = new Team(this.session, [target]);
      dTeam.canAbscond = false;
      Strife strife = new Strife(this.session, [pTeam, dTeam]);
      strife.timeTillRocks = 10;
      strife.startTurn(div);

  }


  String getText() {
        Player smartest = Stats.SBURB_LORE.sortedList(session.players).first;
      return("Shit. Fuck. The ${smartest.htmlTitle()} just found out that you need both QUEEN's RINGS to beat this shitty game.  Time to get their Boss Fight on.");
  }

  @override
  bool trigger(List<Player> playerList) {
      if(session.canReckoning && !session.playersHaveRings()) return true;
      return false;
  }
}