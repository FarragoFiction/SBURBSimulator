import "dart:html";
import "../SBURBSim.dart";
/*
    These are how Wastes, and things that aspire to be Wastes, do their shit.
    sburbLore and Gnosis will function similarly to corruption and GrimDark.

    sburbLore will have a max value, and if it goes over that, gnosis goes up by 1
    This scene is the parallel of goGrim dark. When you go up by a gnosis level, this scene
    will say shit about it.  It will use Session Mutator to

 */

class GetWasted extends Scene {
    Player player; //only one player can get wasted at a time.
    int tippingPointBase = 1;
    GetWasted(Session session): super(session);

  @override
  bool trigger(List<Player> playerList){
      this.playerList = playerList;
      this.player = null;
      List<Player> possibilities = new List<Player>();
      for(Player p in session.availablePlayers){ //unlike grim dark, corpses are not allowed to have eureka moments.
          if(this.loreReachedTippingPoint(p)){
              possibilities.add(p);
          }
      }
      this.player = rand.pickFrom(possibilities);
      return this.player != null;
  }

  bool loreReachedTippingPoint(Player p){
      return p.getStat("sburbLore") >= tippingPointBase * p.gnosis; //linear growth, but the base is high.
  }

  @override
  void renderContent(Element div) {
      print("Getting Wasted in session ${session.session_id}");
      this.player.setStat("sburbLore",0);
      this.player.gnosis ++;
      appendHtml(div,"OMFG, THIS WOULD DO SOMETHING IF JR WASN'T A LAZY PIECE OF SHIT. Player has: ${player.getStat("sburbLore")} sburbLore and ${player.gnosis} gnosis.");
  }
}
