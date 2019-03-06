import "../../SBURBSim.dart";
import 'dart:html';

//name says it all, players better find the rings before the reckoning ends

class OhShitFuckWheresTheRing extends Scene {
    OhShitFuckWheresTheRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      gameEntity.available = false;
      DivElement me = new DivElement();
      div.append(me);
      me.setInnerHtml(getText());
      GameEntity bqowner = session.derseRing == null  ?  null:session.derseRing.owner;
      GameEntity wqowner = session.prospitRing == null  ?  null:session.prospitRing.owner;

      if(bqowner != null && !bqowner.alliedToPlayers) {
          Element container = new DivElement();
          me.append(container);
          GameEntity blackQueen = session.derse == null  ?  null:session.derse.queen;
          if(session.mutator.lifeField || (bqowner.unconditionallyImmortal &&  gameEntity.unconditionallyImmortal)) {
              return wellFuck(div, bqowner, session.derseRing, blackQueen);
          }else if (bqowner.dead) {
              return ohOkay(div, bqowner, session.derseRing, blackQueen);
          }else {
              return startFight(div, bqowner, session.derseRing, blackQueen);
          }
      }

      if(wqowner != null && !wqowner.alliedToPlayers && wqowner != bqowner) {
          Element container = new DivElement();
          me.append(container);
          GameEntity whiteQueen = session.prospit == null  ?  null:session.prospit.queen;

          if(session.mutator.lifeField || (wqowner.unconditionallyImmortal &&  gameEntity.unconditionallyImmortal)) {
              wellFuck(div, wqowner, session.prospitRing, whiteQueen);
          }else if (wqowner.dead) {
              return ohOkay(div, wqowner, session.prospitRing, whiteQueen);
          }else {
              startFight(div, wqowner, session.prospitRing, whiteQueen);
          }
      }
  }

    void ohOkay(Element container, GameEntity target, Ring ring, GameEntity whoSHOULDHaveIt) {
        DivElement div = new DivElement();
        container.append(div);
        String text = "";
        gameEntity.lootCorpse(target);
        text = "Oh. Huh. The ${target.htmlTitleWithTip()} is already dead? The ${gameEntity.htmlTitleWithTip()} just loots the $ring from their corpse. Easy enough.";
        div.setInnerHtml(text);
    }

    void wellFuck(Element container, GameEntity target, Ring ring, GameEntity whoSHOULDHaveIt) {
        DivElement div = new DivElement();
        container.append(div);
        String text = "";
        text = "<br><br>Well. Fuck. After countless hours spent fruitlessly strifing, the ${gameEntity.htmlTitle()} stares blankly at the ${target.htmlTitle()}. The Players need the Ring, but immortality stops things from progressing as Skaia intended. They finally resolve it via a high stakes game of coin flipping. ${target.htmlTitle()} calls heads. ";
        if(rand.nextBool()) {
            target.lootCorpse(gameEntity);
            text = "$text The coin lands on heads! The ${target.htmlTitleWithTip()} wins! We all agree this is phenomenally stupid. ";
        }else {
            gameEntity.sylladex.add(ring);
            target.lootCorpse(gameEntity);
            text = "$text The coin lands on tails! The ${gameEntity.htmlTitleWithTip()} wins! We all agree this is phenomenally stupid. ";
        }
        div.setInnerHtml(text);


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
        List<GameEntity> fightingPlayers = this.getGoodGuys();
        if(fightingPlayers.length > 6){
            ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
        }
        CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
        div.append(canvasDiv);
        Drawing.poseAsATeam(canvasDiv, fightingPlayers);
    }

  void startFight(Element container, GameEntity target, Ring ring, GameEntity whoSHOULDHaveIt) {
      DivElement div = new DivElement();
      container.append(div);
      this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
      String text = "";
      if(target == whoSHOULDHaveIt) {
          text = "<br><br><img src = 'images/sceneIcons/bq_icon.png'> The ${target.htmlTitle()} is ready to fulfill her role as the players penultimate challenge. ";
      }else {
          text = "<br><br>Huh. Well. The ${target.htmlTitle()} is DEFINITELY not a Carapace Queen. You are blown away by this stunning revelation.  Who knew that the Main Quest of SBURB could go off the rails like that???  Either way, they have to be taken out, or the game cannot be beaten. The Players prepare for an epic boss fight.";
      }

      div.setInnerHtml(text);

      List<GameEntity> fighting = this.getGoodGuys();

      for(GameEntity g in fighting) {
        g.available = false;
      }

      Team pTeam = new Team.withName("The Players",this.session, fighting);
      pTeam.canAbscond = false;
      Team dTeam = new Team.withName("The Owner of the $ring (${target.htmlTitleHPNoTip()})",this.session, [target]);
      dTeam.canAbscond = false;
      Strife strife = new Strife(this.session, [pTeam, dTeam]);
      print("before i start the strife, i think the target is alive: ${target.dead} ");
      strife.startTurn(div);

      DivElement div2 = new DivElement();
      container.append(div2);
      div2.setInnerHtml("The ${ring.owner.htmlTitleWithTip()} is now the owner of the ${ring}. ");

  }


  String getText() {
        //yes this isn't hte same thing as gnosis, but i have to pick someone, and PL's stats auto sort
      //and gnosis isn't a stat like that
        Player smartest = Stats.SBURB_LORE.sortedList(session.players).first;
      return("<br><br>Shit. Fuck. The ${smartest.htmlTitle()} just found out that you need both QUEEN's RINGS to beat this shitty game.  Time to get their Boss Fight on.");
  }

  @override
  bool trigger(List<Player> playerList) {
      if(session.canReckoning && !session.playersHaveRings()) return true;
      return false;
  }
}