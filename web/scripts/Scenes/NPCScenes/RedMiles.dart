import "../../SBURBSim.dart";
import 'dart:html';

class RedMiles extends Scene {

    //only way to escape them is to never fire them in the first place
    bool cannotEscape = false;

  RedMiles(Session session) : super(session);


  bool timeToDestroyUniverse() {
      if(findLiving(session.players).isNotEmpty) return false;
  }



  @override
  void renderContent(Element div) {
    cannotEscape = true;
    session.logger.info("AB: You cannot escape the miles.");
    //pick a random player or land or moon
      //if you can't find anything, pick the universe itself (i.e. session crash)

    if(timeToDestroyUniverse()) return destroyUniverse(div);

    String land = "land";
    String player = "player";
    String carapace = "carapace";
    String moon = "moon";
    List<String> possibilities = <String>[land, player, carapace, moon];
    String chosen = session.rand.pickFrom(possibilities);

    if(chosen == land) {
        return destroyLand(div);
    }else if(chosen == player) {
        return destroyPlayer(div);
    }else if(chosen == moon) {
        return destroyMoon(div);
    }else if(chosen == carapace) {
        return destroyCarapace(div);
    }

  }

  //nothing left to destroy, so destroy the session
  void destroyUniverse(Element div) {
      throw new PlayersCrashedSession(getPlayersTitlesNoHTML(<GameEntity>[this.gameEntity]) + " has turned the Red Miles onto the Universe Frog itself.  Frog/Session id was:  ${this.session.session_id}");

  }

  void destroyLand(Element div) {
      //loop through all players, collect all their non null lands
      //pick a random land
      // land.planetsplode()
  }

  void destroyPlayer(Element div) {
      //technically a sauce player could trigger this, but the 'not self' protection doesn't apply
  }

  void destroyMoon(Element div) {

  }

  void destroyCarapace(Element div) {
      //not self
  }

  //only if nothing left to destroy
  void destroySession(Element div) {

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