import "../../SBURBSim.dart";
import 'dart:html';

//meant to be owned by the Black King, but anyone with the black King's scepter will get this scene as well.

class StartReckoning extends Scene {
    StartReckoning(Session session) : super(session);

  @override
  void renderContent(Element div) {
      //;
      gameEntity.available = false;
      DivElement me = new DivElement();
      me.setInnerHtml("<br>${getText()}");
      div.append(me);
      //don't start it directly, skaia will handle this
      session.plzStartReckoning = true;
  }

  String ectoBiologyString() {
      String intro = "";
      Player leader = session.getLeader();
      if (this.session.stats.ectoBiologyStarted) {
          intro += " Remember those random baby versions of the players the " + leader.htmlTitleBasic() + " made? ";
          if (this.session.stats.scratched) {
              intro += "Wait... DID they make the babies? Or, was it their guardian, the " + session.getLeader(getGuardiansForPlayers(this.session.players)).htmlTitleBasic() + "? Scratched sessions are so confusing...";
          }
          intro += " Yeah, that didn't stop being a thing that was true. ";
          intro += " It turns out that those babies ended up on the meteors heading straight to Skaia. ";
          intro += " And to defend itself, Skaia totally teleported those babies back in time, and to Earth. ";
          intro += "We are all blown away by this stunning revelation.  Wow, those babies were the players? Really?  Like, a paradox?  Huh. ";
      } else if (!this.session.stats.ectoBiologyStarted && leader.aspect == Aspects.TIME && !leader.dead) {
          leader.performEctobiology(this.session);
          intro += " Okay. Don't panic. But it turns out that the " + leader.htmlTitle() + " completly forgot to close one of their time loops. ";
          intro += " They were totally supposed to take care of the ectobiology. It's cool though, they'll just go back in time and take care of it now. ";
          intro += " They warp back to the present in a cloud of clocks and gears before you even realize they were gone. See, nothing to worry about. ";
      } else if (!session.mutator.spaceField) {
          intro += " So. I don't know if YOU know that this was supposed to be a thing, but the " + leader.htmlTitleBasic();
          intro += " was totally supposed to have taken care of the ectobiology. ";
          intro += " They didn't. They totally didn't.  And now, it turns out that none of the players could have possibly been born in the first place. ";
          intro += " Textbook case of a doomed timeline.  Apparently the Time Player ";
          if (findAspectPlayer(session.players, Aspects.TIME).doomedTimeClones.length > 0) {
              intro += ", despite all the doomed time clone shenanigans, ";
          }
          intro += "was not on the ball with timeline management. Nothing you can do about it. <Br><Br>GAME OVER.";
          this.session.stats.doomedTimeline = true;
          intro += "<br><br>";
          SimController.instance.storyElement.appendHtml(intro, treeSanitizer: NodeTreeSanitizer.trusted);
          //session.logger.info("reckoning scratch button");
          this.session.stats.scratchAvailable = true;
          SimController.instance.renderScratchButton(this.session);
          this.session.stats.scratchAvailable = true;
          return intro;
      } else {
          session.logger.info("AB: Space4 Gnosis is making ectobiology able to happen in child sessions. ");
          intro += "You find out that the ${session.mutator.spacePlayer.htmlTitle()} took care of things. ";
          intro += " Apparently now you're destined to have always have had been born in some other session? You get a little dizzy trying to think about it. ";
          intro += " At least you're able to follow that you SHOULD be doomed right now because ectobiology totally didn't happen. But you aren't. And you should thank the ${session.mutator.spacePlayer.htmlTitle()} ";
      }
      return intro;
  }

  String getText() {
      GameEntity blackKing = session.battlefield == null  ?  null:session.battlefield.blackKing;

      String ectobiology = ectoBiologyString();
      session.stats.nonKingReckoning = true;
      if(gameEntity == blackKing) {
          session.stats.nonKingReckoning = false;
          return("The ${gameEntity.htmlTitleWithTip()} fulfills his ancient purpose and calls up the Meteors of the Reckoning. The Players do not have much time remaining to beat the game, if they are to get the Ultimate Frog into Skaia before the Meteors destroy it.  <Br><br>${ectobiology}");
      }else if(gameEntity.alliedToPlayers) {
          return("The Players are finally ready to beat the game. The  ${gameEntity.htmlTitleWithTip()} calls up the Meteors of the Reckoning, to fullfill the time loop and prepare Skaia to recieve the Ultimate Frog.  <Br><br>${ectobiology}");
      }else if(gameEntity is Carapace && (gameEntity as Carapace).type == Carapace.DERSE) {
          return("The ${gameEntity.htmlTitleWithTip()} has no intention of allowing a Blasphemous Frog be bred, and calls up the Meteors of the Reckoning in an attempt to end the game before the players can do so. <Br><br>${ectobiology}");
      }else {
          return("It's not clear why the ${gameEntity.htmlTitleWithTip()} calls up the Meteor of the Reckoning. Was it malice? An accident? A plan? Some machinations from Skaia itself? The Players do not have much time remaining to beat the game, if they are to get the Ultimate Frog into Skaia before the Meteors destroy it.  <Br><br>${ectobiology}");
      }

  }


  @override
  bool trigger(List<Player> playerList) {
      if(session.didReckoning) return false;
      if(session is DeadSession) return false;

      //first, if i don't have both scepters, don't even bother
      GameEntity bkowner = session.derseScepter == null  ?  null:session.derseScepter.owner;
      GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;

      if(bkowner != wkowner) return false;
      if(bkowner != gameEntity) return false;
      //alright, so now I know I own both scepeters.
      //session.logger.info("$gameEntity has both scepters, will they cause a reckoning?");
      if(gameEntity.alliedToPlayers) {
          Player spacePlayer = session.findBestSpace();
          //help the space player out out right (otherwise we can get a VERY long session)
          spacePlayer.landLevel += session.minFrogLevel;
          spacePlayer.grist += session.minimumGristPerPlayer;
          //either the players have already won, or now there is no way to.
          if(session.sickFrogCheck(spacePlayer) || spacePlayer.land == null || !spacePlayer.land.dead) {
              return true;
          }
      }else {
          return true; //assap, just like jack did, just like the black king will.
      }
      return false;

  }
}