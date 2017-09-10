import "dart:html";
import "../SBURBSim.dart";


//if leader dies before last player is in OR before performing ectobiology, it's a doomed timeline.
class AccidentallySaveDoomedTimeline extends Scene {
  List<Player> playerList = [];  //what players are already in the medium when i trigger?
  Player chaosPlayer = null;
  Player leaderPlayer = null;
  String reason = "";
  Player doomedTimeClone = null;
  Player enablingPlayer = null;


  AccidentallySaveDoomedTimeline(Session session): super(session);

  @override
  bool trigger(playerList){
    this.chaosPlayer = null;
    this.enablingPlayer = null;
    var times = findAllAspectPlayers(this.session.players, Aspects.CHAOS); //they don't have to be in the medium, though
    this.enablingPlayer = rand.pickFrom(times); //ironically will probably allow more timeless sessions without crashes.
    this.leaderPlayer = getLeader(session.players);
    this.playerList = playerList;

    if(this.enablingPlayer != null){
      if(this.enablingPlayer.isActive() || rand.nextDouble() > .5){
        this.chaosPlayer = this.enablingPlayer;
      }else{  //somebody else can be voided.
        this.chaosPlayer = rand.pickFrom(this.session.players);  //passive time players make doomed clones of others.
      }
    }
    /*
		if(this.timePlayer.dead){  //a dead time player can't prevent shit.
			////session.logger.info("time player is dead, not triggering");
			////session.logger.info(this.timePlayer);
			return false;
		}*/
    ////session.logger.info("time player is not dead,  do i trigger?");
    return (this.chaosPlayer != null && (this.ectoDoom() || this.playerDoom() || this.randomDoom(times.length)));
  }

  @override
  void renderContent(Element div){
    ////session.logger.info("time clone " + this.timePlayer + " " + this.session.session_id.toString());
    appendHtml(div,"<br><img src = 'images/sceneIcons/chaos_icon.png'>"+this.content());
    var divID = (div.id);
    String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+canvasHeight.toString() + "'>  </canvas>";
    appendHtml(div,canvasHTML);
    var canvas = querySelector("#canvas"+ divID);
    Drawing.drawTimeGears(canvas);
    Drawing.drawSinglePlayer(canvas, this.doomedTimeClone);

  }
  bool leaderIsFucked(){
    if(this.leaderPlayer.dead && !this.leaderPlayer.dreamSelf && !this.leaderPlayer.godTier && !this.leaderPlayer.godDestiny){
      ////session.logger.info('leader is fucked');
      return true;
    }
    return false;
  }
  bool ectoDoom(){
    if(this.leaderIsFucked() && !this.session.stats.ectoBiologyStarted){
      this.reason = "Leader killed before ectobiology.";
      ////session.logger.info(this.reason);
      return true; //paradox, the babies never get made.
    }
    return false;
  }
  bool playerDoom(){
    //greater time pressure for getting all players in, can't wait for a revive.
    if(this.leaderPlayer.dead && this.playerList.length < this.session.players.length && this.playerList.length != 1){ //if i die before entering, well, that's yellowYard bullshit
      this.reason = "Leader killed before all players in medium.";  //goddamn it past jr, there was a TYPO here, no WONDER it never happened.
      //session.logger.info("!!!!!!!!!!!!!!!oh hell YES " + this.session.session_id.toString());
      return true; //not everybody is in, leader can't be server for final player
    }
    return false;
  }
  bool randomDoom(numTries){
    this.reason = "Shenanigans";
    for(int i = 0; i<numTries; i++){
      if(rand.nextDouble() > .99) return true;
    }
    return false;
  }
  dynamic content(){
    String ret = "Minutes ago, but not many, in a slightly different timeline, a " + this.chaosPlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
    ret += " They don't actually know what's going on themselves... ";
    if(this.enablingPlayer != this.chaosPlayer){
      //session.logger.info("nonTime player doomed time clone: " + this.session.session_id.toString());
      ret += " The " + this.enablingPlayer.htmlTitleBasic() + " accidentally forced them back in time... ";

    }

    if(this.reason == "Leader killed before ectobiology."){
      //alert("ecto doom");
      ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
      ret += " none of the Players will even be born in the first place (They ramble on, reading notes off sloppy index cards.)";

      this.session.doomedTimelineReasons.add(this.reason);
      this.leaderPlayer.dead = false;
      this.leaderPlayer.renderSelf();
      var r = this.chaosPlayer.getRelationshipWith(this.leaderPlayer);
      if(r != null && r.value != 0){
        if(r.value > 0){
          ////session.logger.info(" fully restoring leader health from time shenanigans: " + this.session.session_id.toString());
          ret += " They accidentally save a life. ";
          this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp"));
        }else{
          ////session.logger.info(" barely restoring leader health from time shenanigans: " + this.session.session_id.toString());
          ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
          this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp")/10);
        }
      }else{
        ////session.logger.info(" half restoring leader health from time shenanigans: " + this.session.session_id.toString());
        this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp")/2);
        ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. Not intentionally, of course. ";
      }

    }else if(this.reason == "Leader killed before all players in medium."){
      ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
      ret += " the " +this.session.players[this.session.players.length-1].htmlTitleBasic() + " will never even make it into the medium. "; //only point of paradox is for last player
      ret += " After all, the " + this.leaderPlayer.htmlTitleBasic() + " is their server player. The player doesn't know this of course. They're just guessing. ";
      this.leaderPlayer.dead = false;
      this.leaderPlayer.renderSelf();
      var r = this.chaosPlayer.getRelationshipWith(this.leaderPlayer);
      if(r != null && r.value != 0){
        if(r.value > 0){
          //session.logger.info(" fully restoring leader health from time shenanigans before all players in session: " + this.session.session_id.toString());
          ret += " They accidentally save a life.";
          this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp"));
        }else{
          //session.logger.info(" barely restoring leader health from time shenanigans before all players in session : " + this.session.session_id.toString());
          ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
          this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp")/10);
        }
      }else{
        //session.logger.info(" half restoring leader health from time shenanigans before all players in session: " + this.session.session_id.toString());
        ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. Not intentionally, of course. ";
        this.leaderPlayer.setStat("currentHP",this.leaderPlayer.getStat("hp")/2);
      }
      this.session.doomedTimelineReasons.add(this.reason);
    }else{
      if(this.chaosPlayer.leader && !this.session.stats.ectoBiologyStarted ){
        //session.logger.info("time player doing time ectobiology: " + this.session.session_id.toString());
        this.chaosPlayer.performEctobiology(this.session);
        this.reason = "Time player didn't do ectobiology.";
        session.doomedTimelineReasons.add(this.reason);
        ret += "They ramble on about babies.";
      }else{
        this.reason = "Shenanigans";
        session.doomedTimelineReasons.add(this.reason);
        ret += " It's too complicated to explain, but everyone has already screwed up beyond repair. Just trust them. You don't trust them. ";
      }
    }



    var living = findLivingPlayers(this.session.players);
    if(living.length > 0){
      ret += " The " + this.chaosPlayer.htmlTitleBasic() + " has sacrificed themselves to change the timeline... accidentally. ";
      ret += " YOUR session's " + this.chaosPlayer.htmlTitle() + " is fine, don't worry about it...but THIS one is now doomed. ";
      ret += " They don't know what to do now. ";
      ret += " As quickly as they appeared, they vanish... mid-sentence...";
    }else{
      //session.logger.info("death's hand maid in: " + this.session.session_id.toString());
      ret += " Being a Chaos player sucks. Accidentally dooming the timeline, they have a hard time feeling guilty. They disappear off to who knows where. ";
    }
    this.doomedTimeClone = Player.makeDoomedSnapshot(this.chaosPlayer);
    this.chaosPlayer.addDoomedTimeClone(this.doomedTimeClone);
    return ret;
  }

}
