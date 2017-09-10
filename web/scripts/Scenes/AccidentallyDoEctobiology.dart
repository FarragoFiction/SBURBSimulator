import "dart:html";
import "../SBURBSim.dart";


//only needs to happen once, but if it DOESN'T happen before reckoning (or leader is permanently killed) doomed timeline.
class AccidentallyDoEctobiology extends Scene {
  List<Player> playerList = [];  //what players are already in the medium when i trigger?
  Player chaosPlayer = null;
  List<Player> playersMade = []; //keep track because not all players get made (multi session bullshit)




  AccidentallyDoEctobiology(Session session): super(session, false);

  @override
  bool trigger(List<Player> playerList){
    this.playerList = playerList;
    this.chaosPlayer = getLeader(this.session.getReadOnlyAvailablePlayers());  //dead men do no ectobiology
    if(this.chaosPlayer != null && this.chaosPlayer.dead == false && this.session.stats.ectoBiologyStarted == false){
      return this.chaosPlayer.getStat("power") > (rand.nextDouble()*200); //can't do it right out of the bat. might never do it
    }
    return false;
  }
  void drawLeaderPlusBabies(Element div){
    //alert("drawing babies");
    num repeatTime = 1000;
    String divID = (div.id) + "_babies";
    int ch = canvasHeight;
    if(this.session.players.length > 6){
      ch = (canvasHeight*1.5).round();
    }
    String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$ch'>  </canvas>";
    appendHtml(div, canvasHTML);
    //different format for canvas code
    Element canvasDiv = querySelector("#canvas"+ divID);
    Drawing.poseBabiesAsATeam(canvasDiv, this.chaosPlayer, this.playersMade, getGuardiansForPlayers(this.playersMade));
  }
  @override
  void renderContent(Element div){

    div.appendHtml("<br><img src = 'images/sceneIcons/ectobiology_icon.png'>"+this.content(),treeSanitizer: NodeTreeSanitizer.trusted);
    this.drawLeaderPlusBabies(div);
  }
  dynamic content(){
    ////session.logger.info("doing ectobiology for session " + this.session.session_id);
    this.session.stats.ectoBiologyStarted = true;
    this.playersMade = findPlayersWithoutEctobiologicalSource(this.session.players);
    setEctobiologicalSource(this.playersMade, session.session_id);
    String ret = " The " + this.chaosPlayer.htmlTitle();
    ret += " vanishes into thin air, accidentally appearing in a strange lab.";
    ret +=  " They fall face first onto a button, creating a shit ton of babies??? What??? The babies look just like the" + getPlayersTitlesBasic(this.playersMade);
    if(session.stats.scratched){
      ret += " That's a lot of babies...";
      ret += " Uh, does this have a connection to another session? Maybe?";
    }else{
      ret += " That's a lot of babies... ";
      ret += " What is even going on here? ";
    }
    this.chaosPlayer.increasePower();
    this.chaosPlayer.leveledTheHellUp = true;
    this.chaosPlayer.level_index +=3;
    session.removeAvailablePlayer(chaosPlayer);
    this.chaosPlayer.flipOut(" how the Ultimate Goddamned Riddle means that if they didn't play this bullshit game in the first place they never would have been born at all");
    return ret;
  }

}
