import "dart:html";
import "../SBURBSim.dart";

class ConfrontJack extends Scene{
  List<Player> playerList = [];  //what players are already in the medium when i trigger?
  bool canRepeat = false;
  Player player = null;

  ConfrontJack(Session session): super(session, false)

  @override
  bool trigger(List<Player> playerList){
    this.playerList = playerList;

    this.player = findAspectPlayer(this.session.availablePlayers, Aspects.MIGHT);
    return(this.player != null && !this.session.jack.exiled) && (this.session.jack.getStat("currentHP") >  0 );
  }

  @override
  void renderContent(Element div){
    appendHtml(div,"<br> <img src = 'images/sceneIcons/jack_icon.png'> "+this.content());
  }
  dynamic content(){
    String ret = "Hey, " +getPlayersTitles(this.playerList) +" is trying to fight Jack. It's a shame Cactus hasnt put together his shit though.";
    return ret;
  }

  }
