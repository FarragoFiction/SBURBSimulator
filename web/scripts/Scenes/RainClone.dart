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
    var living = findLivingPlayers(this.session.players);
    this.player = findAspectPlayer(living, Aspects.RAIN);
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

    String ret = "The " + this.player.htmlTitle() + " Just made a clone of themselves?";
    appendHtml(div, ret);

    //todo: make it hapen.
    Player rainyClone = new Player();
    rainyClone = this.player.clone();
    rainyClone.session = this.player.session;
    rainyClone.denizen = this.player.denizen;//clones don't get their own denizen. hopefully, this wont exile the Original's Denizen...
    rainyClone.relationships = this.player.relationships;//todo:


    Relationship.transferFeelingsToClones(this.player, [rainyClone]);
    for (int j = 0; j < this.session.players.length; j++) {
      this.player = this.session.players[j];
      player.generateRelationships([rainyClone]);
    } //should have neutral relationship with self.

    rainyClone.guardian = this.player;
    for (int i = 0; i < playerList.length; i++) {
      GameEntity g = playerList[i]; //could be a sprite, and they don't have classpects.
      if (g is Player) {
        Player p = playerList[i];
        if (p == this.player) {
          super.session.players.insert(i, rainyClone);
        }
      }
    }

    ret = "<br> ...Oh. It seems that this has not been programmed yet. The new copy of the " + rainyClone.htmlTitleBasic() + " looks dissapointed, and wanders off to some obscure corner of the medium.";
    appendHtml(div, ret);
    session.logger.info("tried to clone Rain player.");


  }
}