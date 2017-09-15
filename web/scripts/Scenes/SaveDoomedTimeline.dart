import "dart:html";
import "../SBURBSim.dart";


//if leader dies before last player is in OR before performing ectobiology, it's a doomed timeline.
class SaveDoomedTimeLine extends Scene {
	List<Player> playerList = [];  //what players are already in the medium when i trigger?
	Player timePlayer = null;
	Player leaderPlayer = null;
	String reason = "";
	Player doomedTimeClone = null;
	Player enablingPlayer = null;


	SaveDoomedTimeLine(Session session): super(session);

	@override
	bool trigger(playerList){
		this.timePlayer = null;
		this.enablingPlayer = null;
		var times = findAllAspectPlayers(this.session.players, Aspects.TIME); //they don't have to be in the medium, though
		this.enablingPlayer = rand.pickFrom(times); //ironically will probably allow more timeless sessions without crashes.
		this.leaderPlayer = getLeader(session.players);
		this.playerList = playerList;
		
		if(this.enablingPlayer != null){
			if(this.enablingPlayer.isActive() || rand.nextDouble() > .5){
				this.timePlayer = this.enablingPlayer;
			}else{  //somebody else can be voided.
				this.timePlayer = rand.pickFrom(this.session.players);  //passive time players make doomed clones of others.
			}
		}
		/*
		if(this.timePlayer.dead){  //a dead time player can't prevent shit.
			////session.logger.info("time player is dead, not triggering");
			////session.logger.info(this.timePlayer);
			return false;
		}*/
		////session.logger.info("time player is not dead,  do i trigger?");
		return (this.timePlayer != null && (this.ectoDoom() || this.playerDoom() || this.randomDoom(times.length)));
	}

	@override
	void renderContent(Element div){
		////session.logger.info("time clone " + this.timePlayer + " " + this.session.session_id.toString());
		appendHtml(div,"<br><img src = 'images/sceneIcons/time_icon.png'>"+this.content());
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
		String ret = "Minutes ago, but not many, in a slightly different timeline, a " + this.timePlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
		ret += " They come with a dire warning of a doomed timeline. ";
		if(this.enablingPlayer != this.timePlayer){
			//session.logger.info("nonTime player doomed time clone: " + this.session.session_id.toString());
			ret += " The " + this.enablingPlayer.htmlTitleBasic() + " helped them come back in time to change things. ";

		} 

		if(this.reason == "Leader killed before ectobiology."){
			//alert("ecto doom");
			ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
			ret += " none of the Players will even be born in the first place (Long story, just trust them). ";

			this.session.doomedTimelineReasons.add(this.reason);
			this.leaderPlayer.dead = false;
			this.leaderPlayer.renderSelf();
			var r = this.timePlayer.getRelationshipWith(this.leaderPlayer);
			if(r != null && r.value != 0){
					if(r.value > 0){
						////session.logger.info(" fully restoring leader health from time shenanigans: " + this.session.session_id.toString());
						ret += " They make it so that never happened. Forget about it. ";
						this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH));
					}else{
						////session.logger.info(" barely restoring leader health from time shenanigans: " + this.session.session_id.toString());
						ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
            this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH)/10);
					}
			}else{
				////session.logger.info(" half restoring leader health from time shenanigans: " + this.session.session_id.toString());
        this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH)/2);
				ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. ";
			}

		}else if(this.reason == "Leader killed before all players in medium."){
			ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
			ret += " the " +this.session.players[this.session.players.length-1].htmlTitleBasic() + " will never even make it into the medium. "; //only point of paradox is for last player
			ret += " After all, the " + this.leaderPlayer.htmlTitleBasic() + " is their server player. ";
			this.leaderPlayer.dead = false;
			this.leaderPlayer.renderSelf();
			var r = this.timePlayer.getRelationshipWith(this.leaderPlayer);
			if(r != null && r.value != 0){
					if(r.value > 0){
						//session.logger.info(" fully restoring leader health from time shenanigans before all players in session: " + this.session.session_id.toString());
						ret += " They make it so that never happened. Forget about it. ";
            this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH));
					}else{
						//session.logger.info(" barely restoring leader health from time shenanigans before all players in session : " + this.session.session_id.toString());
						ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
            this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH)/10);
					}
			}else{
				//session.logger.info(" half restoring leader health from time shenanigans before all players in session: " + this.session.session_id.toString());
				ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. ";
        this.leaderPlayer.setStat(Stats.CURRENT_HEALTH,this.leaderPlayer.getStat(Stats.HEALTH)/2);
			}
			this.session.doomedTimelineReasons.add(this.reason);
		}else{
			if(this.timePlayer.leader && !this.session.stats.ectoBiologyStarted ){
					//session.logger.info("time player doing time ectobiology: " + this.session.session_id.toString());
					this.timePlayer.performEctobiology(this.session);
					this.reason = "Time player didn't do ectobiology.";
					session.doomedTimelineReasons.add(this.reason);
					ret += " They need to do the ectobiology right freaking now, or none of the players will ever even be born.";
			}else{
				this.reason = "Shenanigans";
				session.doomedTimelineReasons.add(this.reason);
				ret += " It's too complicated to explain, but everyone has already screwed up beyond repair. Just trust them. ";
			}
		}



		var living = findLivingPlayers(this.session.players);
		if(living.length > 0){
			ret += " The " + this.timePlayer.htmlTitleBasic() + " has sacrificed themselves to change the timeline. ";
			ret += " YOUR session's " + this.timePlayer.htmlTitle() + " is fine, don't worry about it...but THIS one is now doomed. ";
			ret += " Least they can do after saving everyone is to time travel to where they can do the most good. ";
			ret += " After doing something inscrutable, they vanish in a cloud of clocks and gears. ";
		}else{
			//session.logger.info("death's hand maid in: " + this.session.session_id.toString());
			ret += " Time really is the shittiest aspect. They make sure everybody is dead in this timeline, as per inevitability's requirements, then they sullenly vanish in a cloud of clocks and gears. ";
		}
		this.doomedTimeClone = Player.makeDoomedSnapshot(this.timePlayer);
		this.timePlayer.addDoomedTimeClone(this.doomedTimeClone);
		return ret;
	}

}
