import "../../SBURBSim.dart";
import 'dart:html';

//name says it all, players better find the rings before the reckoning ends

class OhShitFuckWheresTheRing extends Scene {
    OhShitFuckWheresTheRing(Session session) : super(session);

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
      if(session.canReckoning && !session.playersHaveRings()) return true;
  }
}