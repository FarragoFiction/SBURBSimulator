import "dart:html";
import "../SBURBSim.dart";

class RainClone extends Scene {

  List<Player> playerList = []; //what players are already in the medium when i trigger?
  bool canRepeat = false; //todo: change such that this can repeat 2-3 times in
  Player player = null;

  RainClone(Session session) :super(session);

  @override
  bool trigger(List<Player> playerList){
    this.playerList = playerList;

    this.player =
        findAspectPlayer(this.session.availablePlayers, Aspects.RAIN);
    if (this.player == null) {
      return false;
    } else {
      return (this.player != null);
    }
  }

  @override
  void renderContent(Element div) {
    appendHtml(div,"<br>");
    var divID = (div.id);
    String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
    appendHtml(div,canvasHTML);
    var canvas = querySelector("#canvas"+ divID);
    Drawing.drawGodSymbolBG(canvas, this.player);
    Drawing.drawSprite(canvas, this.player);
    Drawing.drawSpriteTurnways(canvas, this.player);
    String ret = "The " + this.player.htmlTitle() +
        " Just made a clone of themselves? WTF?";
    appendHtml(div, ret);
    //todo: make it hapen.
    ret = "<br> ...Oh. It seems that AC has not programmed this yet. The new copy of the " + this.player.htmlTitleBasic() + " looks dissapointed, and wanders off to some obscure corner of the medium.";
    appendHtml(div, ret);
  }
}