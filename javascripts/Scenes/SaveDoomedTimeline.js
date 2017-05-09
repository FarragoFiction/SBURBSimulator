//if leader dies before last player is in OR before performing ectobiology, it's a doomed timeline.
function SaveDoomedTimeLine(session){
	this.session=session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.timePlayer = null;
	this.leaderPlayer = null;
	this.reason = "";
	this.doomedTimeClone = null;
	this.trigger = function(playerList){
		this.timePlayer = findAspectPlayer(session.players, "Time"); //they don't have to be in the medium, though
		this.leaderPlayer = getLeader(session.players);
		this.playerList = playerList;
		/*
		if(this.timePlayer.dead){  //a dead time player can't prevent shit.
			//console.log("time player is dead, not triggering")
			//console.log(this.timePlayer);
			return false;
		}*/
		//console.log("time player is not dead,  do i trigger?")
		return (this.ectoDoom() || this.playerDoom() || this.randomDoom());
	}

	this.makeDoomedSnapshot = function(){
		var timeClone = makeRenderingSnapshot(this.timePlayer);
		timeClone.dead = false;
		timeClone.doomed = true;
		//from a different timeline, things went differently.
		var rand = Math.seededRandom();
		if(rand>.8){
			timeClone.godTier = !timeClone.godTier;
		}else if(rand>.6){
			timeClone.isDreamSelf = !timeClone.isDreamSelf;
		}else if(rand>.4){
			timeClone.grimDark = !timeClone.grimDark;
		}else if(rand>.2){
			timeClone.murderMode = !timeClone.murderMode;
		}
		this.doomedTimeClone = timeClone;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
		var divID = (div.attr("id"))
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);
		drawTimeGears(canvas, this.doomedTimeClone);
		drawSinglePlayer(canvas, this.doomedTimeClone);

	}

	this.leaderIsFucked = function(){
		if(this.leaderPlayer.dead && !this.leaderPlayer.dreamSelf && !this.leaderPlayer.godTier && !this.leaderPlayer.godDestiny){
			//console.log('leader is fucked')
			return true;
		}
		return false;
	}

	this.ectoDoom = function(){
		if(this.leaderIsFucked() && !this.session.ectoBiologyStarted){
			this.reason = "Leader killed before ectobiology."
			//console.log(this.reason)
			return true; //paradox, the babies never get made.
		}
		return false;
	}

	this.playerDoom = function(){
		//greater time pressure for getting all players in, can't wait for a revive.
		if(this.leaderPlayer.dead && this.playerList.length < this.session.players.length && this.playerList.length != 1){ //if i die before entering, well, that's yellowYard bullshit
			this.reason = "Leader killed before all players in medium.";  //goddamn it past jr, there was a TYPO here, no WONDER it never happened.
			console.log("!!!!!!!!!!!!!!!oh hell YES " + this.session.session_id)
			return true; //not everybody is in, leader can't be server for final player
		}
		return false;
	}

	this.randomDoom = function(){
		this.reason = "Shenanigans"
		return Math.seededRandom() > .99
	}

	this.content = function(){
		var ret = "A " + this.timePlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
		ret += " They come with a dire warning of a doomed timeline. ";

		if(this.reason == "Leader killed before ectobiology."){
			//alert("ecto doom")
			ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
			ret += " none of the Players will even be born in the first place (Long story, just trust them). ";

			this.session.doomedTimelineReasons.push(this.reason)
			this.leaderPlayer.dead = false;
			var r = this.timePlayer.getRelationshipWith(this.leaderPlayer);
			if(r && r.value != 0){
					if(r.value > 0){
						console.log(" fully restoring leader health from time shenanigans: " + this.session.session_id)
						ret += " They make it so that never happened. Forget about it. ";
						this.leaderPlayer.currentHP = this.leaderPlayer.hp;
					}else{
						console.log(" barely restoring leader health from time shenanigans: " + this.session.session_id)
						ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
						this.leaderPlayer.currentHP = this.leaderPlayer.hp/10;
					}
			}else{
				console.log(" half restoring leader health from time shenanigans: " + this.session.session_id)
				ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. ";
			}

		}else if(this.reason == "Leader killed before all players in medium."){
			ret += " If the " + this.leaderPlayer.htmlTitleBasic() + " dies right now, ";
			ret += " the " +this.session.players[this.session.players.length-1].htmlTitleBasic() + " will never even make it into the medium. "; //only point of paradox is for last player
			ret += " After all, the " + this.leaderPlayer.htmlTitleBasic() + " is their server player. ";
			this.leaderPlayer.dead = false;
			var r = this.timePlayer.getRelationshipWith(this.leaderPlayer);
			if(r && r.value != 0){
					if(r.value > 0){
						console.log(" fully restoring leader health from time shenanigans before all players in session: " + this.session.session_id)
						ret += " They make it so that never happened. Forget about it. ";
						this.leaderPlayer.currentHP = this.leaderPlayer.hp;
					}else{
						console.log(" barely restoring leader health from time shenanigans before all players in session : " + this.session.session_id)
						ret += " They take a twisted pleasure out of waiting until the last possible moment to pull the " + this.leaderPlayer.htmlTitleBasic() + "'s ass out of the danger zone. ";
						this.leaderPlayer.currentHP = this.leaderPlayer.hp/10;
					}
			}else{
				console.log(" half restoring leader health from time shenanigans before all players in session: " + this.session.session_id)
				ret += " They interupt things before the " + this.leaderPlayer.htmlTitleBasic() +  " gets hurt too bad. ";
			}
			this.session.doomedTimelineReasons.push(this.reason)
		}else{
			if(this.timePlayer.leader && !this.session.ectoBiologyStarted ){
					console.log("time player doing time ectobiology: " + this.session.session_id)
					this.timePlayer.performEctobiology(this.session);
					this.reason = "Time player didn't do ectobiology."
					session.doomedTimelineReasons.push(this.reason)
					ret += " They need to do the ectobiology right freaking now, or none of the players will ever even be born.";
			}else{
				this.reason = "Shenanigans"
				session.doomedTimelineReasons.push(this.reason)
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
			console.log("death's hand maid in: " + this.session.session_id)
			ret += " Time really is the shittiest aspect. They make sure everybody is dead in this timeline, as per inevitability's requirements, then they sullenly vanish in a cloud of clocks and gears. "
		}
		this.makeDoomedSnapshot();
		this.timePlayer.doomedTimeClones.push(this.doomedTimeClone);
		this.timePlayer.triggerLevel ++; 
		this.timePlayer.flipOut("their own doomed time clones")
		return ret;
	}
}
