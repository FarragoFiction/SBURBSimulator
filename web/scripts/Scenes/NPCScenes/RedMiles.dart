import "../../SBURBSim.dart";
import 'dart:html';

class RedMiles extends Scene {

    //only way to escape them is to never fire them in the first place
    bool cannotEscape = false;

  RedMiles(Session session) : super(session);


  @override
  void renderContent(Element div) {
    cannotEscape = true;
    session.logger.info("AB: You cannot escape the miles.");
    //pick a random player or land or moon
      //if you can't find anything, pick the universe itself (i.e. session crash)

    String land = "land";
    String player = "player";
    String carapace = "carapace";
    String moon = "moon";
    List<String> possibilities = <String>[land, player, carapace, moon];

    throw("todo");
  }

  void destroyLand() {

  }

  void destroyPlayer() {
      //technically a sauce player could trigger this, but the 'not self' protection doesn't apply
  }

  void destroyMoon() {

  }

  void destroyCarapace() {
      //not self
  }

  //only if nothing left to destroy
  void destroySession() {

  }

  @override
  bool trigger(List<Player> playerList) {
      //do you have a Ring? are you violent?
      //then do it. once triggered, you can no longer escape the miles.
      if(gameEntity.ring == null) return false;
      if(cannotEscape) return true;
      //you aren't even going to try to do something this omnicidal.
      if(!gameEntity.violent) return false;

      if(session.rand.nextDouble() > .7) return true;
      return false;

  }
}