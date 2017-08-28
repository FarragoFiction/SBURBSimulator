import "dart:html";
import "../SBURBSim.dart";

class ConfrontJack extends Scene{
  List<Player> playerList = [];  //what players are already in the medium when i trigger?
  bool canRepeat = false;

  ConfrontJack(Session session): super(session, false)

  @override
  bool trigger(playerList){
    this.playerList = playerList;
    return (!this.session.jack.dead  && !this.session.jack.exiled && layer.aspect == Aspects.MIGHT);

  }
}