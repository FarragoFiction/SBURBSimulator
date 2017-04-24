function FreeWillStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.decision = null
	this.player
	//luck can be good or it can be bad.
	//should something special happen if you have a lot of negative free will? like...
	//maybe exile shenanigans?
	this.trigger = function(playerList){
		this.decision = null;//reset
		this.player = null;
		//what the hell roue of doom's corpse. corpses aren't part of the player list!
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var player = this.session.availablePlayers[i];
			if(player.freeWill > 25){  //don't even get to consider a decision if you don't have  more than default free will.
				var decision = this.getPlayerDecision(player);
				if(decision){
					if(!this.decision || player.freeWill > this.player.freeWill){  //whoever has the most will makes the decision.
						this.decision = decision;
						this.player = player;
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
			console.log("disengage murde mode")
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
	this.isValidTargets = function(enemies,player){
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
			return this.becomeMurderMode(player);
		}else if(enemies.length > 0 && player.triggerLevel > 3){
			return this.forceSomeOneElseMurderMode(player);
		}
		return null;
	}
	//i'm not in murder mode. it's not a terrible idea to kill my enemies.
	this.becomeMurderMode = function(player){
		if(!player.murderMode){
			var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
			if(this.isValidTargets(enemies,player)){
					console.log("chosing to go into murdermode " +this.session.session_id);
					player.murderMode = true;  //no font change. not crazy. obviously. why would you think they were?
					player.triggerLevel = 10;
					//harry potter and the methods of rationality to the rescue
					return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. And if they happen to start with the assholes...well, baby steps. It's not every day they extinguish an entire species. ";
			}
		}
		return null;
	}

	this.howManyEnemiesInCommon = function(enemies, patsy){
		var myEnemies = patsy.getEnemiesFromList(findLivingPlayers(this.session.players));
		var num = 0;
		for(var i = 0; i<enemies.length; i++){
			var e = enemies[i];
			if(myEnemies.indexOf(e) != -1) num ++;
		}
		return num;
	}
	
	this.howManyFriendsYouHate = function(friends, patsy){
		var myEnemies = patsy.getEnemiesFromList(findLivingPlayers(this.session.players));
		var num = 0;
		for(var i = 0; i<friends.length; i++){
			var e = friends[i];
			if(myEnemies.indexOf(e) != -1) num ++;
		}
		return num;
	}

	//find someone not in the list of enemies. choose whoever is enemies with the most amount of given enemies
	//free will isn't about randomness. decisions. choices. alternatives.
	//they can be enemeis with the player. makes for ironic betryal.
	this.findBestPatsy = function(player, enemies){
			var bestPatsy = null; //array with [patsy, numEnemiesInCommon]
			var living = findLivingPlayers(this.session.players);
			var friends = player.getFriendsFromList(living)
			for(var i = 0; i<living.length; i++){
				var p = living[i];
				if(p != player){ //can't be own patsy
					if(bestPatsy == null){
						bestPatsy = [p,this.howManyEnemiesInCommon(enemies, p)];
					}else if(!p.murderMode){ //not already in murder mode
							var numEnemiesInCommon = this.howManyEnemiesInCommon(enemies, p);
							var patsyHatesMyFriend = this.howManyFriendsYouHate(friends, p)  //you aren't a good patsy if you are going to kill the people i care about along with my enemies.
							var val = numEnemiesInCommon - patsyHatesMyFriend;
							if(val > bestPatsy[1]){
								bestPatsy = [p,val];
							}
					}
				}
			}
			return bestPatsy
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

	this.getInfluenceSymbol = function(player){
		if(player.aspect == "Mind") return "mind_forehead.png"
		if(player.aspect == "Rage") return "rage_forehead.png"
		if(player.aspect == "Blood") return "blood_forehead.png"
		if(player.aspect == "Heart") return "heart_forehead.png"
	}

	//it's not a terrible idea to kill my enemies, and I can find someone not already in murder mode.
	//random chance of making my enemies their enemies. boosted if prince/thief of mind or blood. or witch/mage or rage? special dialogue if so.
	//have method to look for best patsy. (best one is someone who isn't already your enemy who hates the most amount of your enemies.)
	//only do mind control if whoever you pick hates less than half of who you hate.
	this.forceSomeOneElseMurderMode = function(player){
		var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
		var patsyArr = this.findBestPatsy(player, enemies);
		var patsy = patsyArr[0];
		var patsyVal = patsyArr[1];
		if(this.isValidTargets(enemies,player) && patsy){
				if(patsyVal > 3*enemies.length/4 && patsy.triggerLevel > 1){
						console.log("manipulating someone to go into murdermode " +this.session.session_id + " patsyVal = " + patsyVal);
						patsy.murderMode = true;
						patsy.triggerLevel = 10;
						return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use clever words to convince the " + patsy.htmlTitleBasic() + " of the righteousness of their plan. They agree to carry out the bloody work. ";

				}else{
					patsy = getRandomElementFromArray(enemies);//no longer care about "best"
					if(this.canStealWills(player) && patsy.freeWill  < player.freeWill){  //can't steal your will if you have enough of it.
						console.log("mind controling someone to go into murdermode and altering their enemies with game powers." +this.session.session_id);
						patsy.murderMode = true;
						patsy.triggerLevel = 10;
						patsy.influenceSymbol = this.getInfluenceSymbol(player);
						var rage = this.alterEnemies(patsy, enemies,player);
						return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the very will of the " + patsy.htmlTitleBasic() + " and use them as a weapon. This is completely terrifying.  " + rage;
					}else if(this.canInfluenceEnemies(player) && patsy.freeWill  < player.freeWill){
						console.log("rage/blood controling into murdermode and altering their enemies with game powers." +this.session.session_id);
						patsy.murderMode = true;
						patsy.triggerLevel = 10;
						patsy.influenceSymbol = this.getInfluenceSymbol(player);
						var rage = this.alterEnemies(patsy, enemies,player);
						var modifiedTrait = "relationships"
						if(player.aspect == "Heart") modifiedTrait = "identity"
						if(player.aspect == "Rage") modifiedTrait = "sanity"
						return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the " + patsy.htmlTitleBasic() + "'s " + modifiedTrait + " until they are willing to carry out their plan. This is completely terrifying. " + rage;
					}else{
						console.log("can't manipulate someone into murdermode and can't use game powers."+this.session.session_id)
					}
				}
		}
		return null;
	}

	//my enemies are your enemies.
	this.alterEnemies = function(patsy, enemies,player){
			//hate you for doing this to me.
			var r = patsy.getRelationshipWith(player)
			var rage = 0;
			if (patsy.freeWill > 0) rage = -3;
			if (patsy.freeWill > 50) rage = -9;
			r.value += rage;
			var ret = ""
			if(rage < -3) ret = "The " + patsy.htmlTitle() + " seems to be upset about this, underneath the control.";
			if(rage < -9) ret = "The " + patsy.htmlTitle() + " is barely under control. They seem furious. ";
			//make snapshot of state so they can maybe break free later.
			patsy.stateBackup = new MiniSnapShot(patsy);
			for(var i = 0; i< enemies.length; i++){
				var enemy = enemies[i];
				if(enemy != patsy){//maybe i SHOULD reneable self-relationships. maybe you hate yourself? try to kill yourself?
					var r1 = player.getRelationshipWith(enemies[i]);
					var r2 = patsy.getRelationshipWith(enemies[i]);
					r2.value = r1.value;
				}
			}
			return ret;
	}

	// do it to self if active, do it to someone else if not.  need to have it not be destiny. bonus if there are dead players (want to avenge them/stop more corpses).
	//sedoku reference???
	this.considerForceGodTier = function(player){
			return null;
	}

	//needs to be a murder mode player. more likely if you like them.  if active and you like them a lot, do it yourself. if passive, see if you can get somebody else to do it for you (mastermind)
	//more likely if murderMode player is ectobiologist or space
	//can be mind control.
	this.considerCalmMurderModePlayer = function(player){
			return null;
	}

	//needs to be a murdermode player,  more likely if you dislike them. if active, do it yourself, if passive, see if you can get somebody else to do it for you. need to be stronger than them.
	//less likely if murderMode player is ectobiologist or space
	this.considerKillMurderModePlayer = function(player){
		return null;
	}

	//if self, just fucking do it. otherwise, pester them. raise power to min requirement, if it's not already there.
	this.considerMakingEctobiologistDoJob = function(player){
		return null;
	}

	//if self, just fucking do it. raise land level. otherwise, pester them. raise power to min requirement, if it's not already there.
	//or if knight, drag their ass to the planet and do some.
	this.considerMakingSpacePlayerDoJob = function(player){
		return null;
	}

	//if  SELF is mind controlled, can break free if free will high enough.
	//if someone ELSE is mind controlled (and not by you), can help them break free.
	this.considerBreakFreeControl = function(player){
		return null;
	}

	this.getPlayerDecision = function(player){
		//reorder things to change prevelance.
		var ret = this.considerBreakFreeControl(player);  //TODO if you are under influence, here is how you can break free, if you free will is strong enough. mini snapshot has code that can help
		if(ret == null) ret = this.considerKillMurderModePlayer(player);
		if(ret == null) ret = this.considerKillMurderModePlayer(player);
		//let them decide to enter or leave grim dark, and kill or calm grim dark player
		if(ret == null) ret = this.considerDisEngagingMurderMode(player); //done
		if(ret == null) ret = this.considerMakingEctobiologistDoJob(player);
		if(ret == null) ret = this.considerMakingSpacePlayerDoJob(player);
		if(ret == null) ret = this.considerForceGodTier(player);
		if(ret == null) ret = this.considerEngagingMurderMode(player);  //done

		return ret;
	}

	this.content = function(){
		console.log("Decision event: " + this.session.session_id)
		var ret = "Decision Event: ";
		removeFromArray(this.player, this.session.availablePlayers);
		ret += this.decision;  //it already happened, it's a string. ineligible for being an important event influencable by yellow yard. (john's retcon time powers can confound a decision like this tho)

		return ret;
	}
}
