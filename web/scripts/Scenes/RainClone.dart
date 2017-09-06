import "dart:html";
import "../SBURBSim.dart";


class RainClone extends Scene {
  List<Player> playerList = []; //what players are already in the medium when i trigger?
  bool canRepeat = true; //todo: change such that this can repeat 2-3 times in
  Player original = null;
  Player other = null;

  RainClone(Session session) :super(session);

  @override
  bool trigger(List<Player> playerList){
    this.playerList = playerList;
    var living = findLivingPlayers(playerList);
    this.original = findAspectPlayer(living, Aspects.RAIN);
    if (this.original == null) {
      return false;
    } else {
      return (this.original != null && this.session.rand.nextIntRange(0, 100) >= 90);//yes, this is random. kill me.
    }
  }
  @override
  void renderContent(Element div) {
    appendHtml(div,"<br>");
    var divID = (div.id);
    String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
    appendHtml(div,canvasHTML);

    var canvas = querySelector("#canvas"+ divID);
    Drawing.drawGodSymbolBG(canvas, this.original);
    Drawing.drawSprite(canvas, this.original);
    Drawing.drawSpriteTurnways(canvas, this.original);

    String ret = "The " + this.original.htmlTitle() + " Just made a clone of themselves?";
    appendHtml(div, ret);

    //todo: make it hapen.
    Player rainyClone = new Player();
    rainyClone = this.original.clone();
    rainyClone.session = this.original.session;
    rainyClone.denizen = this.original.denizen;//clones don't get their own denizen. hopefully, this wont exile the Original's Denizen...
    rainyClone.relationships = this.original.relationships;//todo:


    Relationship.transferFeelingsToClones(this.original, [rainyClone]);
    for (int j = 0; j < this.session.players.length; j++) {
      this.other = this.session.players[j];
      this.other.generateRelationships([rainyClone]);
      rainyClone.generateRelationships([this.other]);
    } //should have neutral relationship with self.

    rainyClone.guardian = this.original.guardian;
    for (int i = 0; i < this.session.players.length; i++) {
      GameEntity g = this.session.players[i]; //could be a sprite, and they don't have classpects.
      if (g is Player) {
        Player p = this.session.players[i];
        if (p == this.original) {
          super.session.players.insert(i + 1, rainyClone);
          i = this.session.players.length + 1;
        }
      }
    }

    ret = "<br> ...Oh. It seems that this has not been programmed yet. The new copy of the " + rainyClone.htmlTitleBasic() + " looks dissapointed, and wanders off to some obscure corner of the medium.";
    appendHtml(div, ret);
    session.logger.info("tried to clone Rain player.");


  }
}