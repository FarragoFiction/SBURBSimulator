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
				//not everybody knows about ectobiology.
				if(!this.session.ectoBiologyStarted && ectobiologistEnemy && player.knowsAboutSburb()){
					console.log("Free will stop from killing ectobiologist: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + "settles their shit. If this keeps up, they are going to end up killing the " + ectobiologistEnemy.htmlTitle();
					ret += " and then they will NEVER do ectobiology.  No matter HOW much of an asshole they are, it's not worth dooming the timeline. ";
					player.murderMode = false;
					player.leftMurderMode = true;
					player.triggerLevel = 0; //
					return ret;
				}
				//not everybody knows why frog breeding is important.
				if(spacePlayerEnemy && spacePlayerEnemy.landLevel < this.session.goodFrogLevel  && player.knowsAboutSburb()){
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

  //if you know better, you won't doom the session.
	this.isValidTargets(enemies){
		var spacePlayerEnemy = findAspectPlayer(enemies, "Space");
		var ectobiologistEnemy = getLeader(enemies);
		if(spacePlayerEnemy && spacePlayerEnemy.landLevel < this.session.goodFrogLevel  && player.knowsAboutSburb()){
			return false;
		}
		if(!this.session.ectoBiologyStarted && ectobiologistEnemy && player.knowsAboutSburb()){
				return false;
		}

		return true;
	}

	//hate someone, not in murder mode, self if active, other if passive. plus random, increase trigger, too. if you engage murder mode in someone else, random chance to succesfully manipulate them to hate who you hate.
	//less likely if who you hate is ectobiologist or space
	this.considerEngagingMurderMode = function(player){
		var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
		if(player.isActive() && enemies.length > 0 && player.triggerLevel > 3){
			return becomeMurderMode(player);
		}else if(enemies.length > 0 && player.triggerLevel > 3){
			return forceSomeOneElseMurderMode(player);
		}
		return null;
	}
	//i'm not in murder mode. it's not a terrible idea to kill my enemies.
	this.becomeMurderMode = function(player){
		if(!player.murderMode){
			var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
			if(this.isValidTargets(enemies)){
					console.log("chosing to go into murdermode " +this.session.session_id);
					player.murderMode = true;  //no font change. not crazy. obviously. why would you think they were?
					player.triggerLevel = 10;
					//harry potter and the methods of rationality to the rescue
					return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. And if they happen to start with the assholes...well, baby steps. It's not every day they extinguish an entire species. ";
			}
		}
		return null;
	}

	//find someone not in the list of enemies. choose whoever is enemies with the most amount of given enemies but not the player.
	this.findBestPatsy = function(player, enemies){

	}

	//thief/bard/maage/witch of mind.
	this.canStealWills = function(player){
		if(player.aspect == "Mind"){
			if(player.class_name == "Thief" || player.class_name == "Mage" || player.class_name == "Bard" || player.class_name == "Witch"){
				return true;
			}
		}
		return false;

	}

	//thief/prince/mage/witch of blood. thief/prince/mage/witch of heart. /mage/witch of rage.
	this.canInfluenceEnemies = function(player){
		if(player.aspect == "Blood"){
			if(player.class_name == "Thief" || player.class_name == "Mage" || player.class_name == "Bard" || player.class_name == "Witch"){
				return true;
			}
		}

		if(player.aspect == "Rage"){
			if( player.class_name == "Mage" || player.class_name == "Witch"){
				return true;
			}

		}
		return false;

	}

	//it's not a terrible idea to kill my enemies, and I can find someone not already in murder mode.
	//random chance of making my enemies their enemies. boosted if prince/thief of mind or blood. or witch/mage or rage? special dialogue if so.
	//have method to look for best patsy. (best one is someone who isn't already your enemy who hates the most amount of your enemies.)
	//only do mind control if whoever you pick hates less than half of who you hate.
	this.forceSomeOneElseMurderMode = function(player){
		var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
		var patsyArr = findBestPatsy(player, enemies);
		var patsy = patsyArr[0];
		var patsyVal = patsyArr[1];
		if(this.isValidTargets(enemies) && patsy){
				if(patsyVal > enemies.length/2 && patasy.triggerLevel > 1){
						console.log("manipulating someone to go into murdermode " +this.session.session_id);
						patsy.murderMode = true;
						return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use clever words to convince the " + patsy.htmlTitleBasic() + " of the righteousness of their plan. They agree to carry out the bloody work. ";

				}else if(canStealWills(player) && patsy.freeWill * 2 < player.freeWill){  //can't steal your will if you have enough of it.
					console.log("mind controling someone to go into murdermode and altering their enemies with game powers." +this.session.session_id);
					patsy.murderMode = true;
					patsy.triggerLevel = 10;
					var rage = this.alterEnemies(patsy, enemies,player);
					return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the very will of the " + patsy.htmlTitleBasic() + " and use them as a weapon. This is completely terrifying.  " + rage;
				}else if(canInfluenceEnemies(player) && patsy.freeWill * 2 < player.freeWill){
					console.log("rage controling into murdermode and altering their enemies with game powers." +this.session.session_id);
					patsy.murderMode = true;
					patsy.triggerLevel = 10;
					var rage = this.alterEnemies(patsy, enemies,player);
					var modifiedTrait = "relationships"
					if(player.aspect == "Heart") modifiedTrait = "identity"
					if(player.aspect == "Rage") modifiedTrait = "sanity"
					return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the " + patsy.htmlTitleBasic() + "'s " + modifiedTrait + " until they are willing to carry out their plan. This is completely terrifying. " + rage;
				}
		}
		return null;
	}

	//my enemies are your enemies.
	this.alterEnemies = function(patsy, enemies,player){
			for(var i = 0; i< enemies.length; i++){
				var enemy = enemies[i];
				if(enemy != patsy){//maybe i SHOULD reneable self-relationships. maybe you hate yourself? try to kill yourself?
					var r1 = player.getRelationshipWith(enemies[i]);
					var r2 = patsy.getRelationshipWith(enemies[i]);
					r2.value = r1.value;
				}
			}
			//hate you for doing this to me.
			var r = patsy.getRelationshipWith(player)
			var rage = 0;
			if (patsy.freeWill > 0) rage = -3;
			if (patsy.freeWill > 50) rage = -9;
			r.value += rage;
			var ret = ""
			if(rage < -3) ret = "The " + patsy.htmlTitle() + " seems to be upset about this, underneath the control.";
			if(rage < -9) ret = "The " + patsy.htmlTitle() + " is barely under control. They seem furious. ";
			return ret;
	}

	// do it to self if active, do it to someone else if not.  need to have it not be destiny. bonus if there are dead players (want to avenge them/stop more corpses).
	//sedoku reference???
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
