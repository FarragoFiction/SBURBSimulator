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
      /*
            Two Main Trigger types:

            if you're allied with the players, you wait for them to have a full frog and enough grist and the rings.

            if youre not....you just fucking do it. right away.

       */
  }
}