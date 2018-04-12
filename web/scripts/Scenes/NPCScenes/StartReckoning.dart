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
      me.setInnerHtml(getText());
      div.append(me);

  }

  String getText() {

  }


  @override
  bool trigger(List<Player> playerList) {

      //first, if i don't have both scepters, don't even bother
      GameEntity bkowner = session.derseScepter == null  ?  null:session.derseScepter.owner;
      GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;

      if(bkowner != wkowner) return false;
      if(bkowner != gameEntity) return false;
      //alright, so now I know I own both scepeters.
      session.logger.info("$gameEntity has both scepters, will they cause a reckoning?");
      if(gameEntity.alliedToPlayers) {
          Player spacePlayer = session.findBestSpace();
          if(session.fullFrogCheck(spacePlayer)) {
              return true;
          }
      }else {
          return true; //assap, just like jack did, just like the black king will.
      }

  }
}