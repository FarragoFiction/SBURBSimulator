import "dart:html";
import "../SBURBSim.dart";

class ConfrontJack extends Scene{
  List<Player> playerList = [];  //what players are already in the medium when i trigger?
  bool canRepeat = false;
  Player player = null;

  ConfrontJack(Session session): super(session, false);

  @override
  bool trigger(List<Player> playerList){
    this.playerList = playerList;

    this.player = findAspectPlayer(this.session.availablePlayers, Aspects.MIGHT);
    if (this.player == null) {
      return false;
    }else {
      return (this.player != null && !this.session.jack.exiled) && (this.session.jack.getStat("currentHP") >  0 );
    }
  }

  @override
  void renderContent(Element div){
    appendHtml(div,"<br> <img src = 'images/sceneIcons/jack_icon.png'> ");
  }
  dynamic content(Element div){
    String ret = "Hey, " + this.player.htmlTitle() + " is trying to fight Jack. It's a shame CACTUS IS INCOMPETENT, or else this would, i dunno, work.";
    Team pTeam = new Team.withName(this.player.htmlTitle(),this.session, this.session.availablePlayers);
    Team dTeam = new Team(this.session, [this.session.jack]);
    Strife strife = new Strife(this.session, [pTeam, dTeam]);

    strife.startTurn(div);
    appendHtml(div,""+ret);
    return div;
  }

  }
