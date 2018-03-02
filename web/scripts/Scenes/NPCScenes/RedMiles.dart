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

  //each thing has a set 'do this next' if it can't be done
  void destroyLand(Element div, [int count=0]) {
      //means i've tried and failed to destroy three things
      if(count > 3) destroyUniverse(div);
      count++;

      List<Land> targets = new List<Land>();
      for(Player p in session.players) {
        if(p.land != null) targets.add(p.land);
      }

      if(targets.isEmpty) destroyMoon(div, count);
      session.rand.pickFrom(targets).planetsplode(gameEntity);
  }

    void destroyMoon(Element div, [int count=0]) {
        //means i've tried and failed to destroy three things
        if(count > 3) destroyUniverse(div);
        count++;

        List<Land> targets = new List<Land>();
        for(Moon p in session.moons) {
            if(p != null) targets.add(p);
        }

        if(targets.isEmpty) destroyPlayer(div, count);
        session.rand.pickFrom(targets).planetsplode(gameEntity);
    }

  void destroyPlayer(Element div, [int count=0]) {
      //technically a sauce player could trigger this, but the 'not self' protection doesn't apply
      //means i've tried and failed to destroy three things
      if(count > 3) destroyUniverse(div);
      count++;
      List<Player> targets = new List<Player>();
      for(Player p in session.players) {
          if(!p.dead) targets.add(p);
      }

      if(targets.isEmpty) destroyCarapace(div, count);
      session.rand.pickFrom(targets).makeDead("not being able to escape the miles.", gameEntity);

  }



  void destroyCarapace(Element div, [int count=0]) {
      //means i've tried and failed to destroy three things
      if(count > 3) destroyUniverse(div);
      count++;

      //loop through all players, collect all their non null lands
      //pick a random land
      // land.planetsplode()
      List<GameEntity> targets = new List<GameEntity>();
      for(Moon p in session.moons) {
          if(p != null) {
            for(GameEntity g in p.associatedEntities) {
                if(!g.dead && g != gameEntity) targets.add(g);
            }
          }
      }

      if(targets.isEmpty) destroyLand(div, count);

      session.rand.pickFrom(targets).makeDead("not being able to escape the miles.", gameEntity);
  }



  //every carapace can do it, but not everyone wants to

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