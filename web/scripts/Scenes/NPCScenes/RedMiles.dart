import "../../SBURBSim.dart";
import 'dart:html';

class RedMiles extends Scene {

    //only way to escape them is to never fire them in the first place
    bool cannotEscape = false;

  RedMiles(Session session) : super(session);


  bool timeToDestroyUniverse() {
      if(findLiving(session.players).isNotEmpty) return false;
      return true;
  }



  @override
  void renderContent(Element div) {
      if(!cannotEscape) {
          Element frame = new DivElement();
          frame.setInnerHtml("<br>The ${gameEntity.name} has had enough of this bullshit. They Activate the Red Miles. They cannot be escaped.");
          frame.style.backgroundImage = "url(images/Rewards/miles.png";

          div.append(frame);
          cannotEscape = true;
          session.stats.redMilesActivated = true;
          gameEntity.usedMiles = true;
          return null; //no one dies the first turn.
      }
    cannotEscape = true;
    //session.logger.info("AB: You cannot escape the miles.");
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
      session.stats.ringWraithCrash = true;
      throw new PlayersCrashedSession(getPlayersTitlesNoHTML(<GameEntity>[this.gameEntity]) + " has turned the Red Miles onto the Universe Frog itself.  Frog/Session id was:  ${this.session.session_id}");

  }

  //each thing has a set 'do this next' if it can't be done
  void destroyLand(Element div, [int count=0]) {
      //means i've tried and failed to destroy three things
      if(count > 3) destroyUniverse(div);
      count++;

      List<Land> targets = new List<Land>();
      List<Land> spaceTargets = new List<Land>();
      for(Player p in session.players) {
        if(!p.aspect.isThisMe(Aspects.SPACE) && p.land != null  && !p.land.dead) targets.add(p.land);
        if(p.aspect.isThisMe(Aspects.SPACE) && p.land != null  && !p.land.dead) spaceTargets.add(p.land);

      }

      //only allow space planets to be destroyed last
      if(targets.isEmpty) targets.addAll(spaceTargets);

      if(targets.isEmpty) return destroyMoon(div, count);
      Land m = session.rand.pickFrom(targets);
      DivElement ret = new DivElement();
      ret.style.backgroundImage = "url(images/Rewards/miles.png";
      ret.append(m.planetsplode(gameEntity));

      ret.setInnerHtml("<br><br>The Red Miles cannot be escaped. The ${m.name} has been targeted.");

      Element test = m.planetsplode(gameEntity);
      //print ("moon exploding returns: ${test.text}");
      ret.append(test);
      div.append(ret);

  }

    void destroyMoon(Element div, [int count=0]) {
        //means i've tried and failed to destroy three things
        if(count > 3) destroyUniverse(div);
        count++;

        List<Moon> targets = new List<Moon>();
        for(Moon p in session.moons) {
            if(p != null && !p.dead) {
                session.logger.info("$p is not null for destroying");
                targets.add(p);
            }
        }

        if(targets.isEmpty) return destroyPlayer(div, count);

        Moon m = session.rand.pickFrom(targets);
        DivElement ret = new DivElement();

        ret.style.backgroundImage = "url(images/Rewards/miles.png";


        ret.setInnerHtml("<br><br>The Red Miles cannot be escaped. ${m.name} has been targeted.");
        Element test = m.planetsplode(gameEntity);
        //print ("moon exploding returns: ${test.text}");
        ret.append(test);
        div.append(ret);
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

      if(targets.isEmpty) return destroyCarapace(div, count);
      Player player = session.rand.pickFrom(targets);
      player.makeDead("not being able to escape the miles.", gameEntity);

      DivElement ret = new DivElement();
      ret.style.backgroundImage = "url(images/Rewards/miles.png";

      ret.setInnerHtml("<br><br>The Red Miles cannot be escaped. The ${player.htmlTitleBasicWithTip()} is dead.");
      CanvasElement canvas = new CanvasElement(width: canvasWidth, height: canvasHeight);
      ret.append(canvas);
      Drawing.drawSinglePlayer(canvas, player);
      div.append(ret);
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

      if(targets.isEmpty) return destroyLand(div, count);

      GameEntity g = session.rand.pickFrom(targets);
      g.makeDead("not being able to escape the miles.", gameEntity);

      DivElement ret = new DivElement();
      ret.style.backgroundImage = "url(images/Rewards/miles.png";

      ret.setInnerHtml("<br>The Red Miles cannot be escaped. The ${g.htmlTitleWithTip()} is dead.");
      div.append(ret);
  }



  //every carapace can do it, but not everyone wants to

  @override
  bool trigger(List<Player> playerList) {
      //do you have a Ring? are you violent?
      //then do it. once triggered, you can no longer escape the miles.
      if(cannotEscape) return true;
      if(gameEntity.ring == null) return false;

      //you aren't even going to try to do something this omnicidal.
      if(!gameEntity.violent) return false;

      if(session.rand.nextDouble() > .97) return true;
      return false;

  }
}