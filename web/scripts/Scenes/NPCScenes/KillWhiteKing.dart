import "../../SBURBSim.dart";
import 'dart:html';

//meant to be owned by the Black King, but anyone with the black King's scepter will get this scene as well.

class KillWhiteKing extends Scene {
    KillWhiteKing(Session session) : super(session);


    @override
    void renderContent(Element div) {
        session.logger.info("Time to kick the White King's Ass.");
        gameEntity.available = false;
        DivElement me = new DivElement();
        div.append(me);
        me.setInnerHtml(getText());
        GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;

        Element container = new DivElement();
        me.append(container);
        GameEntity whiteKing = session.battlefield == null  ?  null:session.battlefield.whiteKing;
        if(session.mutator.lifeField || (whiteKing.unconditionallyImmortal &&  gameEntity.unconditionallyImmortal)) {
            return wellFuck(div, wkowner, session.prospitScepter, whiteKing);
        }else if (whiteKing.dead) {
            return ohOkay(div, wkowner, session.prospitScepter, whiteKing);
        }else {
            return startFight(div, wkowner, session.prospitScepter, whiteKing);
        }
    }

    void ohOkay(Element container, GameEntity target, Scepter scepter, GameEntity whoSHOULDHaveIt) {
        DivElement div = new DivElement();
        container.append(div);
        String text = "";
        gameEntity.lootCorpse(target);
        text = "Oh. Huh. The ${target.htmlTitle()} is already dead? The ${gameEntity.htmlTitleWithTip()} just loots the $scepter from their corpse. Easy enough.";
        div.setInnerHtml(text);
    }

    void wellFuck(Element container, GameEntity target, Scepter scepter, GameEntity whoSHOULDHaveIt) {
        DivElement div = new DivElement();
        container.append(div);
        String text = "";
        text = "<br><br>Well. Fuck. After countless hours spent fruitlessly strifing, the ${gameEntity.htmlTitle()} stares blankly at the ${target.htmlTitle()}. How do you meet the Scepter's calling when both parties are immortal? They finally resolve it via a high stakes game of coin flipping. ${target.htmlTitle()} calls heads. ";
        if(rand.nextBool()) {
            target.sylladex.add(scepter);
            text = "$text The coin lands on heads! The ${target.htmlTitleWithTip()} wins! We all agree this is phenomenally stupid. ";

        }else {
            gameEntity.sylladex.add(scepter);
            text = "$text The coin lands on tails! The ${gameEntity.htmlTitleWithTip()} wins! We all agree this is phenomenally stupid. ";
        }
        div.setInnerHtml(text);
    }


    void startFight(Element container, GameEntity target, Scepter scepter, GameEntity whoSHOULDHaveIt) {
        DivElement div = new DivElement();
        container.append(div);
        String text = "";
        if(target == whoSHOULDHaveIt) {
            text = "<br><br>It is time for the The ${target.htmlTitle()}'s inevitable defeat. ";
        }else {
            text = "<br><br>Huh. Well. The ${target.htmlTitle()} is DEFINITELY not the WHITE KING. You are blown away by this stunning revelation.  Who knew that the Main Quest of SBURB could go off the rails like that???  Either way, the scepters require a strife.";
        }

        div.setInnerHtml(text);

        List<GameEntity> fighting = <GameEntity>[gameEntity];

        for(GameEntity g in fighting) {
            g.available = false;
        }

        Team pTeam = new Team.withName("The Owner of the ${session.derseScepter} (${gameEntity.htmlTitleHPNoTip()}) ",this.session, fighting);
        pTeam.canAbscond = false;
        Team dTeam = new Team.withName("The Owner of the ${session.prospitScepter} (${target.htmlTitleHPNoTip()})",this.session, [target]);
        dTeam.canAbscond = false;
        Strife strife = new Strife(this.session, [pTeam, dTeam]);
        print("before i start the strife, i think the target is dead: ${target.dead} ");
        strife.startTurn(div);

        DivElement div2 = new DivElement();
        container.append(div2);
        String what = "";
        if(scepter.owner != gameEntity) what = "Uh. I....really don't think that was supposed to happen. Fuck. Now what happens?";
        div2.setInnerHtml("<br>The ${scepter.owner.htmlTitleWithTip()} is now the owner of the ${scepter}. $what <br>");

    }


    String getText() {
        String friends = "";
        GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;
        if(gameEntity.friendsWith(wkowner)) friends = "They get a really bad feeling about this. ";
        return("<br><br>It is time. The ${gameEntity.htmlTitle()} feels the inexporable pull of the ${session.derseScepter.baseName} to slay whosoever bears the ${session.prospitScepter.baseName}. $friends");
    }

  @override
  bool trigger(List<Player> playerList) {
      if(session is DeadSession) return false; //they do shit different

      /*
            When the first player get to the battlefield, anyone holding the Black King's Scepter
            will try to go kill whoever is holding the White King's Scepter.

            sucks if you were friends ten seconds ago, there's a REASON you'er not supposed to be holding
            this shit.
       */
      GameEntity bkowner = session.derseScepter == null  ?  null:session.derseScepter.owner;
      GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;


      if(bkowner != gameEntity) return false;

      //please don't try to murder yourself. it's fine.
      if(bkowner == wkowner || wkowner == null) return false;
      //you don't necessarily murder your counterpart the second a player sets foot on the battlefield
      if(session.canReckoning && session.rand.nextDouble()<.75) return true;

      return false;
  }
}