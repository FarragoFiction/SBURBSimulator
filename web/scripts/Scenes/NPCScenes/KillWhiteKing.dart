import "../../SBURBSim.dart";
import 'dart:html';

//meant to be owned by the Black King, but anyone with the black King's scepter will get this scene as well.

class KillWhiteKing extends Scene {
    KillWhiteKing(Session session) : super(session);

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
      /*
            When the first player get to the battlefield, anyone holding the Black King's Scepter
            will try to go kill whoever is holding the White King's Scepter.

            sucks if you were friends ten seconds ago, there's a REASON you'er not supposed to be holding
            this shit.
       */
      GameEntity bkowner = session.derseScepter == null  ?  null:session.derseScepter.owner;
      GameEntity wkowner = session.prospitScepter == null  ?  null:session.prospitScepter.owner;

      if(session.canReckoning && bkowner == gameEntity) return true;
  }
}