function FreeWillStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.decision = null
	//luck can be good or it can be bad.
	//should something special happen if you have a lot of negative free will? like...
	//maybe exile shenanigans?
	this.trigger = function(playerList){
		this.decision = null;//reset
		//what the hell roue of doom's corpse. corpses aren't part of the player list!
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var player = this.session.availablePlayers[i];
			if(player.freeWill > 25){  //don't even get to consider a decision if you don't have  more than default free will.
				var decision = this.getPlayerDecision(player);
				if(decision){
					var d = new WillPower(player, decision)
					if(!this.decision || d.player.freeWill > this.decision.player.freeWill){  //whoever has the most will makes the decision.
						this.decision = d;
					}
				}
			}
		}
		return this.decision != null;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	//in murder mode, plus random. reduce trigger, too. only for self (whether active or passive)
	//more likely if who you hate is ectobiologist or space
	this.considerDisEngagingMurderMode = function(player){
		if(player.murderMode){
				var ret = "";
				var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
				var spacePlayerEnemy = findAspectPlayer(enemies, "Space");
				var ectobiologistEnemy = getLeader(enemies);
				if(!this.session.ectoBiologyStarted && ectobiologistEnemy){
					console.log("Free will stop from killing ectobiologist: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + "settles their shit. If this keeps up, they are going to end up killing the " + ectobiologistEnemy.htmlTitle();
					ret += " and then they will NEVER do ectobiology.  No matter HOW much of an asshole they are, it's not worth dooming the timeline. ";
					player.murderMode = false;
					player.leftMurderMode = true;
					player.triggerLevel = 0; //
					return ret;
				}

				if(spacePlayerEnemy && spacePlayerEnemy.landLevel < this.session.goodFrogLevel){
					console.log("Free will stop from killing space player: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + "settles their shit. If this keeps up, they are going to end up killing the " + spacePlayerEnemy.htmlTitle();
					ret += " and then they will NEVER have frog breeding done. They can always kill them AFTER they've escaped to the new Universe, right? ";
					player.murderMode = false;
					player.leftMurderMode = true;
					player.triggerLevel = 0; //
					return ret;
				}
				//NOT luck. just obfuscated reasons.
				if(Math.seededRandom() > 0.5){
					console.log("Free will stop from killing everybody: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + "settles their shit. No matter HOW much of an asshole people are, SBURB is the true enemy, and they are not going to let themselves forget that. ";
					player.murderMode = false;
					player.leftMurderMode = true;
					player.triggerLevel = 0; //
					return ret;
				}
		}
		return null;
	}

	//hate someone, not in murder mode, self if active, other if passive. plus random, increase trigger, too. if you engage murder mode in someone else, random chance to succesfully manipulate them to hate who you hate.
	//less likely if who you hate is ectobiologist or space
	this.considerEngagingMurderMode = function(player){
		var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
		var spacePlayerEnemy = findAspectPlayer(enemies, "Space");
		var ectobiologistEnemy = getLeader(enemies);
		if(!spacePlayerEnemy && !ectobiologistEnemy){
			var ret = "";
		}
		return null;
	}

	// do it to self if active, do it to someone else if not.  need to have it not be destiny. bonus if there are dead players (want to avenge them/stop more corpses).
	this.considerForceGodTier = function(player){

	}

	//needs to be a murder mode player. more likely if you like them.  if active and you like them a lot, do it yourself. if passive, see if you can get somebody else to do it for you (mastermind)
	//more likely if murderMode player is ectobiologist or space
	this.considerCalmMurderModePlayer = function(player){

	}

	//needs to be a murdermode player,  more likely if you dislike them. if active, do it yourself, if passive, see if you can get somebody else to do it for you. need to be stronger than them.
	//less likely if murderMode player is ectobiologist or space
	this.considerKillMurderModePlayer = function(player){

	}

	//if self, just fucking do it. otherwise, pester them. raise power to min requirement, if it's not already there.
	this.considerMakingEctobiologistDoJob = function(player){

	}

	//if self, just fucking do it. raise land level. otherwise, pester them. raise power to min requirement, if it's not already there.
	this.considerMakingSpacePlayerDoJob = function(player){

	}

	this.getPlayerDecision = function(player){
		//reorder things to change prevelance.
		var ret = this.considerCalmMurderModePlayer(player);
		if(ret == null) ret = this.considerKillMurderModePlayer(player);
		if(ret == null) ret = this.considerDisEngagingMurderMode(player);
		if(ret == null) ret = this.considerEngagingMurderMode(player);
		if(ret == null) ret = this.considerMakingEctobiologistDoJob(player);
		if(ret == null) ret = this.considerMakingSpacePlayerDoJob(player);
		if(ret == null) ret = this.considerForceGodTier(player);
		return ret;
	}




	this.processDecision = function(){

	}

	this.content = function(){
		console.log("Decision event: " + this.session.session_id)
		var ret = "Decision Event: ";
		removeFromArray(this.player, this.session.availablePlayers);
		for(var i = 0; i<this.wills.length; i++){
			var will = this.wills[i];
			removeFromArray(will.player, this.session.availablePlayers);
			ret += this.processDecision(will);
		}

		return ret;
	}
}

function WillPower(player, decision){
	this.player = player;
	this.decision = decision;
}
