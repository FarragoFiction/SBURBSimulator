import "dart:html";
import "../SBURBSim.dart";

class ConfrontJack extends Scene {
  List<Player> playerList = []; //what players are already in the medium when i trigger?
  bool canRepeat = false;
  Player player = null;

  ConfrontJack(Session session) : super(session, false);

  @override
  bool trigger(List<Player> playerList) {
    this.playerList = playerList;
    var living = findLivingPlayers(this.session.players);
    this.player = findAspectPlayer(living, Aspects.MIGHT);
    if (this.player == null) {
      return false;
    } else {
      return (this.player != null && !this.session.npcHandler.jack.exiled) && (this.session.npcHandler.jack.getStat("currentHP") > 0);
    }
  }

  @override
  void renderContent(Element div) {
    appendHtml(div, "<br> <img src = 'images/sceneIcons/jack_icon.png'> ");
    String ret = "The " + this.player.htmlTitle() + " does not trust Jack, and would prefer him dead. They confront Jack, ready for Strife.";
    appendHtml(div, ret);
    Team pTeam = new Team.withName(
        this.player.htmlTitle(), this.session, [this.player]);
    Team dTeam = new Team(this.session, [this.session.npcHandler.jack]);
    Strife strife = new Strife(this.session, [pTeam, dTeam]);
    strife.startTurn(div);
    if (this.session.npcHandler.jack.getStat("currentHP") <= 0){
      this.session.npcHandler.jack.setStat("currentHP",0); //effectively dead.
      this.session.npcHandler.jack.exiled = true;
      String winText = "The strife with Jack was successful. His corpse has been exiled, never to be seen again.";
      appendHtml(div, winText);
    };

    return;
  }
}

