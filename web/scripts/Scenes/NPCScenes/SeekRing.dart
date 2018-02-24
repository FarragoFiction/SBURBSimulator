import "../../SBURBSim.dart";
import 'dart:html';

class SeekRing extends Scene {
    GameEntity target;
    Action tactic;

    SeekRing(Session session) : super(session);

  @override
  void renderContent(Element div) {
      session.logger.info("$gameEntity is seeking the ring.");
      DivElement me = new DivElement();
      me.setInnerHtml(getText());
      div.append(me);

  }

  void tryFighting() {

  }

  String getText() {

      return "TODO: pick a tactic. try for the ring.";
  }

  @override
  bool trigger(List<Player> playerList) {
      GameEntity whiteRingOwner = session.prospit.queensRing.owner;
      GameEntity blackRingOwner = session.derse.queensRing.owner;

      if(gameEntity.violent) tactic = tryFighting;


      //find who has each ring.
      //for each bearer, ask:
      //if i am stronger than the ring holder, and violent, i will try to strife it off them
      //if i am lucky, or have high relationship with ring holder, i will just ask for it
      //if i am fast and lucky, i will try to steal it
      //not all carapaces have 'seek ring' as an option. only ambitious ones
      //this quest can be GIVEN to someone, though.
      //for example, should a big bad have the ring, all players and allies should get this quest
      return false;
  }
}