function FreeWillStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.decision = null
	this.player = null
	this.renderPlayer1 = null;
	this.renderPlayer2 = null;
	this.playerGodTiered = null;
	//luck can be good or it can be bad.
	//should something special happen if you have a lot of negative free will? like...
	//maybe exile shenanigans?
	this.trigger = function(playerList){
		this.decision = null;//reset
		this.player = null;
		this.renderPlayer1 = null;
		this.renderPlayer2 = null;
		this.playerGodTiered = null;
		//sort players by free will. highest goes first. as soon as someone makes a decision, return. decision happens during trigger, not content. (might be a mistake)
		//way i was doing it before means that MULTIPLE decisions happen, but only one of them render.
		var players = sortPlayersByFreeWill(this.session.availablePlayers);
		for(var i = 0; i<players.length; i++){
			var player = players[i];
			var breakFree = this.considerBreakFreeControl(player);
			if(breakFree){  //somebody breaking free of mind control ALWAYS has priority (otherwise, likely will never happen since they have so little free will to begin with.)
				this.player = player;
				this.decision = breakFree;
				return true;
			}
			if(player.freeWill > 200 || player.canMindControl()){  //don't even get to consider a decision if you don't have  more than default free will.//TODO raise to over 60 'cause that is highest default free will possible. want free will to be rarer.
				var decision = this.getPlayerDecision(player);
				if(decision){
					this.player = player;
					this.decision = decision;
					return true;
				}
			}
		}

		return this.decision != null;
	}

	this.renderPlayers = function(div){
		//console.log("rendering free will player(s): " + this.session.session_id)

		var divID = (div.attr("id")) + "_freeWillBulshit" + this.renderPlayer1.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);

		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,this.renderPlayer1)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
		if(this.renderPlayer2){
			var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
			drawSprite(dSpriteBuffer,this.renderPlayer2)
			copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0)
		}

	}

	this.renderGodTier = function(div){
		//console.log(this.playerGodTiered.title() + " rendering free will god tier: " + this.session.session_id)
		var divID = (div.attr("id")) + "_freeWillBulshit" + this.playerGodTiered.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		var f = this.session.fraymotifCreator.makeFraymotif([this.playerGodTiered], 3);//first god tier fraymotif
		this.playerGodTiered.fraymotifs.push(f);
		div.append(" They learn " + f.name + ". ") ;
		div.append(canvasHTML);
		var canvas = document.getElementById("canvas"+ divID);



		drawGetTiger(canvas, [this.playerGodTiered],repeatTime) //only draw revivial if it actually happened.
	}

	this.renderContent = function(div){
		var psionic = "";
		var pname = this.player.canMindControl()
		if( pname){
			console.log("psychic powers used to mind control in session: " + this.session.session_id)
			psionic =  " The " + this.player.htmlTitleBasic() + " uses their "+ pname + ". "
		} 
		div.append("<br><img src = 'images/sceneIcons/freewill_icon.png'> "+psionic + this.content());
		if(this.playerGodTiered){
			this.renderGodTier(div);
		}else if(this.renderPlayer1){
			this.renderPlayers(div);
		}
	}


	//in murder mode, plus random. reduce trigger, too. only for self (whether active or passive)
	//more likely if who you hate is ectobiologist or space
	this.considerDisEngagingMurderMode = function(player){
		if(player.murderMode){
			//console.log("disengage murde mode")
				var ret = "";
				var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
				var spacePlayerEnemy = findAspectPlayer(enemies, "Space");
				var ectobiologistEnemy = getLeader(enemies);
				//not everybody knows about ectobiology.
				if(!this.session.ectoBiologyStarted && ectobiologistEnemy && (player.knowsAboutSburb() && player.grimDark < 2)){
					//console.log("Free will stop from killing ectobiologist: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. If this keeps up, they are going to end up killing the " + ectobiologistEnemy.htmlTitle();
					ret += " and then they will NEVER do ectobiology.  No matter HOW much of an asshole they are, it's not worth dooming the timeline. ";
					player.unmakeMurderMode();
					player.sanity = 10; //
					removeFromArray(player, this.session.availablePlayers);
					return ret;
				}
				//not everybody knows why frog breeding is important.
				if(spacePlayerEnemy && spacePlayerEnemy.landLevel < this.session.goodFrogLevel  && (player.knowsAboutSburb() && player.grimDark < 2)){
					//console.log("Free will stop from killing space player: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. If this keeps up, they are going to end up killing the " + spacePlayerEnemy.htmlTitle();
					ret += " and then they will NEVER have frog breeding done. They can always kill them AFTER they've escaped to the new Universe, right? ";
					player.unmakeMurderMode();
					player.sanity = 10; //
					removeFromArray(player, this.session.availablePlayers);
					return ret;
				}
				//NOT luck. just obfuscated reasons.
				if(Math.seededRandom() > 0.5){
					//console.log("Free will stop from killing everybody: " + this.session.session_id);
					ret += "With a conscious act of will, the " + player.htmlTitle() + " settles their shit. No matter HOW much of an asshole people are, SBURB is the true enemy, and they are not going to let themselves forget that. ";
					player.unmakeMurderMode();
					player.sanity = 10; //
					removeFromArray(player, this.session.availablePlayers);
					return ret;
				}
		}
		return null;
	}

  //if you know better, you won't doom the session.
	this.isValidTargets = function(enemies,player){
		var spacePlayerEnemy = findAspectPlayer(enemies, "Space");
		var ectobiologistEnemy = getLeader(enemies);
		if(spacePlayerEnemy && spacePlayerEnemy.landLevel < this.session.goodFrogLevel  && (player.knowsAboutSburb() && player.grimDark < 2)){ //grim dark players don't care if it dooms things.
			return false;
		}
		if(!this.session.ectoBiologyStarted && ectobiologistEnemy && (player.knowsAboutSburb() && player.grimDark < 2)){
				return false;
		}

		return true;
	}

	//hate someone, not in murder mode, self if active, other if passive. plus random, increase trigger, too. if you engage murder mode in someone else, random chance to succesfully manipulate them to hate who you hate.
	//less likely if who you hate is ectobiologist or space
	//allow some randomness here.
	this.considerEngagingMurderMode = function(player){
		var enemies = player.getEnemiesFromList(findLivingPlayers(this.session.players));
		if(player.isActive() && enemies.length > 2 && player.sanity < 0 && !player.murderMode && Math.seededRandom() >0.98){
			return this.becomeMurderMode(player);
		}else if(enemies.length > 0 && player.sanity < 0 && Math.seededRandom() > 0.98){
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
					player.makeMurderMode();
					player.sanity = -10;
					removeFromArray(player, this.session.availablePlayers);
					this.renderPlayer1 = player;
					console.log('deciding to be flipping shit')
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

	//who is the most crazy murderer out there?
	this.findMurderModePlayerBesides = function(player){
		var ret = null;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var m = this.session.availablePlayers[i];
			if(!ret || (m.sanity < ret.sanity && !m.dead && m.murderMode)){
				ret = m;
			}
		}
		if(!ret.murderMode) ret = null;
		if(ret == player && player.aspect != "Time") ret = null;  //you should TOTALLY be able to calm your past selves shit.
		return ret;
	}

	//as little randomness in free will as possible. choices. decisions.
	this.findNonGodTierBesidesMe = function(player){
		//console.log(player.title() + " is looking for a god tier besides themselves: " + this.session.session_id)
		var ret = null;
		var ret_abs_value = 0;
		if(player.aspect == "Time" && !player.godTier) return player;  //god tier yourself first.
		//ideally somebody i wouldn't miss too much if they were gone, and wouldn't fear too much if they had phenomenal cosmic power. so. lowest abs value.
		for(var i = 0; i<player.relationships.length; i++){
			var r = player.relationships[i];
			var v = Math.abs(r.value)
			if(!ret || (v < ret_abs_value && !r.target.dead && !r.target.godTier)){
				ret = r;
				ret_abs_value = v;
			}
		}

		if(ret.target == player && player.aspect != "Time") ret = null;
		return ret.target;
	}

	//free will isn't about randomness. decisions. choices. alternatives.
	//they can be enemeis with the player. makes for ironic betryal.
	this.findBestPatsy = function(player, enemies){
			var bestPatsy = null; //array with [patsy, numEnemiesInCommon]
			var living = findLivingPlayers(this.session.players);
			var friends = player.getFriendsFromList(living)
			for(var i = 0; i<living.length; i++){
				var p = living[i];
				if(p != player || player.aspect == "Time"){ //can't be own patsy
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
			if(bestPatsy.murderMode && Math.seededRandom() > .75) bestPatsy = null; //mostly don't bother already murder mode players.
			return bestPatsy
	}


	//thief/prince/mage/witch of blood. thief/prince/mage/witch of heart. /mage/witch of rage.
	this.canInfluenceEnemies = function(player){
		if(player.aspect == "Blood" || player.aspect == "Heart" ||player.aspect == "Mind" ){
			if(player.class_name == "Maid" || player.class_name == "Seer" || player.class_name == "Bard" || player.class_name == "Rogue"){
				return true;
			}
		}

		if(player.aspect == "Rage"){
			if( player.class_name == "Seer" || player.class_name == "Maid"){
				return true;
			}

		}
		return false;

	}

	//bard,  rogue can alter Negative fate
	//sylph, seer, maid, and page of light/life/heart/mind can as well.
	this.canAlterNegativeFate = function(player){
		if(player.aspect == "Light" || player.aspect == "Life" || player.aspect == "Heart" || player.aspect == "Mind"){
			if(player.class_name == "Maid" || player.class_name == "Seer"){
				return true;
			}
		}

		if(player.aspect == "Doom"){
			if(player.class_name == "Bard" || player.class_name == "Rogue" || player.class_name == "Maid" || player.class_name == "Seer"){
				return true;
			}
		}
		return false;
	}

	this.getManipulatableTrait = function(player){
		var ret =  ""
		if(player.aspect == "Heart") ret = "identity"
		if(player.aspect == "Blood") ret = "relationships"
		if(player.aspect == "Mind") ret = "mind"
		if(player.aspect == "Rage") ret = "sanity"
		if(player.aspect == "Hope") ret = "beliefs"
		if(player.aspect == "Doom") ret = "fear"
		if(player.aspect == "Breath") ret = "motivation"
		if(player.aspect == "Space") ret = "commitment"
		if(player.aspect == "Time") ret = "fate"
		if(player.aspect == "Light") ret = "luck"
		if(player.aspect == "Void") ret = "nothing"
		if(player.aspect == "Life") ret = "purpose"
		return ret;
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
				if(patsyVal > enemies.length/2 && patsy.sanity < 1){
						console.log("manipulating someone to go into murdermode " +this.session.session_id + " patsyVal = " + patsyVal);
						patsy.makeMurderMode();
						patsy.sanity = -10;
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(patsy, this.session.availablePlayers);
						this.renderPlayer1 = player;
						this.renderPlayer2 = patsy;
						var loop = ""
						var timeIntro = "";
						if(player == patsy){
							loop = "You get dizzy trying to follow the time logic that must have caused this to happen. Did they only go crazy because their future self went crazy because THEIR future self went crazy....? Or wait, is this a doomed time clone...? Fuck. Time is the shittiest aspect."
							//console.log(player.title() +" convincing past/future self to go murder mode " + this.session.session_id);
						}else if(player.aspect == "Time" && Math.random()>.25){ //most manipulative time bastards are from teh future
							timeIntro = " from the future"
						}
						//console.log("forcing someone else to be flipping shit")
						return "The " + player.htmlTitleBasic() + timeIntro + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use clever words to convince the " + patsy.htmlTitleBasic() + " of the righteousness of their plan. They agree to carry out the bloody work. " + loop;

				}else{
					patsy = getRandomElementFromArray(enemies);//no longer care about "best"
					if(this.canInfluenceEnemies(player) && patsy.freeWill  < player.freeWill && patsy.influencePlayer != player){
						console.log(player.title() +" controling into murdermode and altering their enemies with game powers." +this.session.session_id);
						patsy.makeMurderMode();
						patsy.sanity = -10;
						patsy.flipOut(" about how they are being forced into MurderMode")
						patsy.influenceSymbol = this.getInfluenceSymbol(player);
						patsy.influencePlayer = player;
						var rage = this.alterEnemies(patsy, enemies,player);
						var modifiedTrait = this.getManipulatableTrait(player);
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(patsy, this.session.availablePlayers);
						this.renderPlayer1 = player;
						this.renderPlayer2 = patsy;
						console.log("forcing someone else to be flipping shit")
						return "The " + player.htmlTitleBasic() + " has thought things through. They are not crazy. To the contrary, they feel so sane it burns like ice. It's SBURB that's crazy.  Surely anyone can see this? The only logical thing left to do is kill everyone to save them from their terrible fates. They use game powers to manipulate the " + patsy.htmlTitleBasic() + "'s " + modifiedTrait + " until they are willing to carry out their plan. This is completely terrifying. " + rage;
					}else{
						////console.log("can't manipulate someone into murdermode and can't use game powers. I am: " + player.title() + " " +this.session.session_id)
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
			if(!patsy.stateBackup) patsy.stateBackup = new MiniSnapShot(patsy);  //but don't save state if ALREADY controlled.
			for(var i = 0; i< enemies.length; i++){
				var enemy = enemies[i];
				if(enemy != patsy){//maybe i SHOULD reneable self-relationships. maybe you hate yourself? try to kill yourself?
					var r1 = player.getRelationshipWith(enemies[i]);
					var r2 = patsy.getRelationshipWith(enemies[i]);
					r2.saved_type = r2.badBig;
					r2.old_type = r2.saved_type; //no drama on my end.
					r2.value = r1.value;
				}
			}
			return ret;
	}

	// do it to self if active, do it to someone else if not.  need to have it not be destiny. bonus if there are dead players (want to avenge them/stop more corpses).
	//sedoku reference???
	this.considerForceGodTier = function(player){
		if(!player.knowsAboutSburb()) return null; //regular players will never do this
		if(player.freeWill < 50) return null; //requires great will power to commit suicide or murder for the greater good.
		if(player.isActive() && (player.sanity > 0 || player.murderMode)){
			return this.becomeGod(player);
		}else if(player.sanity > 0 || player.murderMode) {  //don't risk killing a friend unless you're already crazy or the idea of failure hasn't even occured to you.
			return this.forceSomeOneElseBecomeGod(player);
		}
		return null;
	}



	//if I fail at this, the sacrifice is dead adn I am horrifically triggered at my failure.
	this.forceSomeOneElseBecomeGod = function(player){
		var sacrifice = this.findNonGodTierBesidesMe(player);
		if(sacrifice && !sacrifice.dead && !sacrifice.godTier){
			var bed = "bed"
			var loop = ""

			var timeIntro = "";
			if(player == sacrifice){
				loop = "You get dizzy trying to follow the time logic that must have caused this to happen. Did they try to god tier because their future self told them to? But the future self only told them to because THEIR future self told them... Or wait, is this a doomed time clone...? Fuck. Time is the shittiest aspect."
				console.log(player.title() +" convincing past/future self to go god tier" + this.session.session_id);
			}else if(player.aspect == "Time" && Math.random()>.25){
				timeIntro = " from the future"
			}
			var intro = "The " + player.htmlTitleBasic() + timeIntro + " knows how the god tiering mechanic works"
			if(sacrifice.sprite.name == "sprite"){  //isn't gonna happen to yourself, 'cause you have to be 'available'.
				intro += ", to the point of abusing glitches and technicalities the game itself to exploit it before the " + sacrifice.htmlTitle() + " is even in the Medium"
				console.log("HAX! I call HAX! " + this.session.session_id)
			}
			if(player.murderMode){
				intro += " and they are too far gone to care about casualties if it fails"
			}

			if(sacrifice.isDreamSelf) bed = "slab"
			if(sacrifice.freeWill <= player.freeWill && player.power < 200){ //can just talk them into this terrible idea.   not a good chance of working.
				if(sacrifice.godDestiny && (sacrifice.dreamSelf || sacrifice.isDreamSelf)){ //if my dream self is dead and i am my real self....
					var ret =  this.godTierHappens(sacrifice);
					removeFromArray(player, this.session.availablePlayers);
					removeFromArray(sacrifice, this.session.availablePlayers);
					//console.log(player.title() + " commits murder and someone else gets tiger " + this.session.session_id);
					return intro +". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed + ". " + ret + " It is not a very big deal at all. " + loop;  //caliborn
				}else if(sacrifice.rollForLuck() + player.rollForLuck() > 200){  //BOTH have to be lucky.
					//console.log(player.title() + " commits murder and someone else gets tiger and it is all very lucky. " + this.session.session_id);
					var ret =  this.godTierHappens(sacrifice);
					return intro + ". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed + ". " + ret + " It is a stupidly huge deal, since the " + sacrifice.htmlTitleBasic() + " was never destined to God Tier at all. But I guess the luck of both players was enough to make things work out, in the end."  + loop;
				}else{
					removeFromArray(player, this.session.availablePlayers);
					removeFromArray(sacrifice, this.session.availablePlayers);

					player.sanity += -1000;
					player.flipOut(" how stupid they could have been to force the " + sacrifice.htmlTitleBasic() + " to commit suicide" )
					this.renderPlayer1 = player;
					this.renderPlayer2 = sacrifice;
					//console.log(player.title() + " commits murder for god tier but doesn't get tiger " + this.session.session_id);
					var ret = intro + ". They conjole and wheedle and bug and fuss and meddle until the " + sacrifice.htmlTitleBasic() + " agrees to go along with the plan and be killed on their " + bed;
					if(!sacrifice.godDestiny){
						sacrifice.makeDead("trying to go God Tier against destiny.");
						ret +=  ". A frankly ridiculous series of events causes the " + sacrifice.htmlTitleBasic() + "'s dying body to fall off their " + bed + ". They were never destined to GodTier, and SBURB neurotically enforces such things. The " + player.htmlTitleBasic() + timeIntro + " tries desparately to get them to their " + bed + " in time, but in vain. They are massively triggered by their own astonishing amount of hubris. ";
					}else{
						console.log(" could not god tier because lack of dream self in session: " + this.session.session_id)
						sacrifice.makeDead("trying to go God Tier wthout a dream self.");
						ret += ".  Unfortunately, you need a dream self to go GodTier, and the " + sacrifice.htmlTitleBasic() + " does not have one. They die for no reason. Nothing glows, their body does not float, and the magnitude of the " + player.htmlTitleBasic() + timeIntro +"'s hubris astonishes everyone. ";
					}
					return ret + loop;
				}
			}else if(player.power > 200 && this.canAlterNegativeFate(player) && (sacrifice.dreamSelf || sacrifice.isDreamSelf)){  //straight up ignores godDestiny  no chance of failure.
				var ret =  this.godTierHappens(sacrifice);
				removeFromArray(player, this.session.availablePlayers);
				removeFromArray(sacrifice, this.session.availablePlayers);
				var trait = this.getManipulatableTrait(player)
				//console.log(player.title() + " controls someone into getting tiger " + this.session.session_id);
				return "The " + player.htmlTitleBasic() + timeIntro +" knows how the god tiering mechanic works. They don't leave anything to chance and use their game powers to influence the  " + sacrifice.htmlTitleBasic() + "'s " + trait + " until they are killed on their " + bed + ". " + ret ;

			}
		}
	}

	//if I know about SBURB and have a lot of willPower then I can do this. If I don't, will never work up the nerve.
	//me am play god.
	this.becomeGod = function(player){
		if(!player.godTier){
			var intro = "The " + player.htmlTitleBasic()+" knows how the god tiering mechanic works"
			if(player.murderMode){
				intro += " and they are too far gone to care about the consequences of failure"
			}
			if(player.godDestiny){

				removeFromArray(player, this.session.availablePlayers);
				if((player.dreamSelf || player.isDreamSelf)){
					var ret =  this.godTierHappens(player);
					return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " It is not a very big deal at all. ";  //caliborn
				}else{
					console.log(player.title() + " player accidentally suicided trying to god tier without a dream self : "  + this.session.session_id)
					player.makeDead( "trying to go God Tier without a dream self.");
					return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " They may have known enough to exploit the God Tiering mechanic, but apparently hadn't taken into account the fact that you need a DREAM SELF to ascend to the GOD TIERS. Whoops. DEAD. ";
				}
				//console.log(player.title() + " commits suicide and gets tiger " + this.session.session_id);
			}else{
				if(player.rollForLuck() > 100){
					removeFromArray(player, this.session.availablePlayers);
					if((player.dreamSelf || player.isDreamSelf)){
						var ret =  this.godTierHappens(player);
						return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " It is probably for the best that they don't know how huge a deal this is. If they hadn't caught a LUCKY BREAK, they would have died here forever. They were never destined to go God Tier, even if they commited suicide.  ";
					}else{
						console.log(player.title() + " player accidentally suicided trying to god tier without a dream self : "  + this.session.session_id)
						player.makeDead( "trying to go God Tier without a dream self.");
						return intro + ". They steel their will and prepare to commit a trivial act of self suicide. " + ret + " They may have known enough to exploit the God Tiering mechanic, but apparently hadn't taken into account the fact that you need a DREAM SELF to ascend to the GOD TIERS. Whoops. DEAD. ";

					}
					}else{
					player.dead = true;
					var bed = "bed"
					if(player.isDreamSelf) bed = "slab"
					removeFromArray(player, this.session.availablePlayers);
					player.makeDead( "trying to go God Tier against destiny."); //if slab, no corpse produced.
					this.renderPlayer1 = player;
					//console.log(player.title() + " commits suicide but doesn't get tiger " + this.session.session_id);

					return intro + ". They steel their will and prepare to commit a trivial act of self suicide. A frankly ridiculous series of events causes their dying body to fall off the " + bed + ". They may have known enough to exploit the God Tiering mechanic, but apparently hadn't taken into account how neurotically SBURB enforces destiny.  They are DEAD.";
				}
			}
		}
	}

	this.godTierHappens = function(player){
		var ret = "";
		if(!player.isDreamSelf){
				ret += "The " + player.htmlTitleBasic() + "'s body glows, and rises Skaiaward. "+"On " + player.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
				this.session.questBed = true;
				player.makeDead("on their quest bed")
		}else{
			ret += "The " + player.htmlTitleBasic() + " glows and ascends to the God Tiers with a sweet new outfit."
			this.session.sacrificialSlab = true;
			//player.makeDead("on their sacrificialSlab") //no corpse with slab, instead corpse BECOMES god tier.
		}
		player.makeGodTier();
		this.session.choseGodTier = true;
		this.playerGodTiered = player;
		return ret;
	}


	//exclusively mind control
	this.considerCalmMurderModePlayer = function(player){
		var murderer = this.findMurderModePlayerBesides(player);
		if(murderer && !murderer.dead && this.canInfluenceEnemies(player) && player.power > 25 && player.getFriends().length > player.getEnemies().length){  //if I am not a violent person, and I CAN force you to calm down. I will.
			var loop = ""

		    console.log(player.title() + " controlling murderer to make them placid " + this.session.session_id)
			removeFromArray(player, this.session.availablePlayers);
			removeFromArray(murderer, this.session.availablePlayers);
			if(!murderer.stateBackup) murderer.stateBackup = new MiniSnapShot(murderer);
			murderer.nullAllRelationships();
			murderer.unmakeMurderMode();
			murderer.sanity = 100;
			murderer.influenceSymbol = this.getInfluenceSymbol(player);
			murderer.influencePlayer = player;
			murderer.getRelationshipWith(player).value += (player.freeWill - murderer.freeWill*2);  //might love or hate you during this.
			var trait = this.getManipulatableTrait(player);
			this.renderPlayer1 = player;
			this.renderPlayer2 = murderer;
			console.log(trait + " control calming a player: " + this.session.session_id)
			return "The " + player.htmlTitle() + " has had enough of the " + murderer.htmlTitle() + "'s murderous ways.  They manipulate their " + trait+ " until they are basically little more than an empty shell. They are such an asshole before they are finally controlled. Oh, wow. No. They are never going to be allowed to be free again. Never, never, never again. Never. Wow.  " ;
		}
		return null;
	}

	//either make someone love ME, or make two people get together who otherwise wouldn't. can be sweet, or creepy.
	this.considerMakeSomeoneLove = function(player){

		return null;
	}

	//needs to be a murdermode player,  more likely if you dislike them. if active, do it yourself, if passive, see if you can get somebody else to do it for you. need to be stronger and faster than them.
	//less likely if murderMode player is ectobiologist or space
	this.considerKillMurderModePlayer = function(player){
		var murderer = this.findMurderModePlayerBesides(player);
		if(murderer && !player.isActive() && !murderer.dead && this.isValidTargets([murderer], player) && player.power > 25 && this.canInfluenceEnemies(player)){
			return this.sendPatsyAfterMurderer(player, murderer);
		}else if(murderer && !murderer.dead && (player.causeOfDeath.indexOf(murderer.class_name) == -1)){  //you haven't killed me recently.
			//console.log(player.title() + " want to kill murdermode player and my causeOfeath is" + player.causeOfDeath +  " and session is: " + this.session.session_id)
			return this.killMurderer(player, murderer);
		}
		return null;
	}

	this.killMurderer = function(player, murderer){
		if(player.mobility > murderer.mobility){
			if(player.power * player.getPVPModifier("Attacker") > murderer.power * murderer.getPVPModifier("Defender")){  //power is generic. generally scales with any aplicable stats. lets me compare two different aspect players.
				//console.log(player.title() + " choosing to kill murderer. " + this.session.session_id)
				player.victimBlood = murderer.bloodColor;
				removeFromArray(player, this.session.availablePlayers);
				removeFromArray(murderer, this.session.availablePlayers);
				this.renderPlayer1 = player;
				this.renderPlayer2 = murderer;
				murderer.makeDead("being put down like a rabid dog by the " + player.titleBasic());
				player.pvpKillCount ++;
				this.session.murdersHappened = true;
				return "The " + player.htmlTitleBasic() + " cannot let this continue any further. The " + murderer.htmlTitleBasic() + " is a threat to everyone. They corner them, and have a brief, bloody duel that ends in the death of the " + murderer.htmlTitleBasic() + ". " + getPVPQuip(murderer,player, "Defender", "Attacker") + " Everyone is a little bit safer.";
			}else{
				//console.log(player.title() + " choosing to kill murderer but instead killed. " + this.session.session_id)
				murderer.victimBlood = player.bloodColor;
				removeFromArray(murderer, this.session.availablePlayers);
				removeFromArray(player, this.session.availablePlayers);
				player.makeDead("fighting against the crazy " + murderer.titleBasic());
				murderer.pvpKillCount ++;
				this.session.murdersHappened = true;
				this.renderPlayer1 = player;
				this.renderPlayer2 = murderer;
				return "The " + player.htmlTitleBasic() + " cannot let this continue any further. The " + murderer.htmlTitleBasic() + " is a threat to everyone. They corner them, and have a brief, bloody duel that ends in the death of the " + player.htmlTitleBasic() + ".  " + getPVPQuip(player,murderer, "Attacker", "Defender") + " Everyone is a little bit less safe.";
			}
		}
	}

	//ONLY mind control. Set all relationships to neutral except murderer, put into murder mode.
	this.sendPatsyAfterMurderer = function(player, murderer){
		var patsy = player.getWorstEnemyFromList(this.session.availablePlayers);
		if(patsy && !patsy.dead && patsy != murderer && patsy.freeWill  < player.freeWill ){  //they exist and I don't already control them.
			if(!patsy.stateBackup) patsy.stateBackup = new MiniSnapShot(patsy);
			//console.log(player.title() + " controlling player to kill murderer. " + this.session.session_id)
			patsy.nullAllRelationships();
			var r = patsy.getRelationshipWith(murderer);
			r.value = -100;;
			r.saved_type = r.badBig;
			r.old_type = r.saved_type; //no drama on my end.
			patsy.makeMurderMode();
			removeFromArray(player, this.session.availablePlayers);
			removeFromArray(patsy, this.session.availablePlayers);
			patsy.sanity = -100;
			patsy.flipOut(" how they are being forced to try to kill the " + murderer.htmlTitleBasic());
			patsy.influenceSymbol = this.getInfluenceSymbol(player);
			patsy.influencePlayer = player;
			patsy.getRelationshipWith(player).value += (player.freeWill - patsy.freeWill*2);  //might love or hate you during this.
			this.renderPlayer1 = player;
			this.renderPlayer2 = patsy;
			var trait = this.getManipulatableTrait(player);
			return "The " + murderer.htmlTitle() + " needs to die. They are a threat to everyone. The " +player.htmlTitleBasic() + " manipulates the " + patsy.htmlTitleBasic() + "'s " + trait + " until they focus only on their hate for the " + murderer.htmlTitle() + " and how they need to die.";
		}
	}

	//if self, just fucking do it. otherwise, pester them. raise power to min requirement, if it's not already there.
	this.considerMakingEctobiologistDoJob = function(player){
		if(!this.session.ectoBiologyStarted && player.knowsAboutSburb() && player.grimDark < 2 ){
			var timeIntro = "";
			if(player.aspect == "Time" && Math.random()>.25){
				timeIntro = " from the future"
			}
			if(player.leader){
				//console.log(player.title() +" did their damn job. " +this.session.session_id);
				removeFromArray(player, this.session.availablePlayers);
				player.performEctobiology(this.session);
				return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules. Yes, they could wait to do Ectobiology until they are 'supposed' to. But. Just. Fuck that shit. That's how doomed timelines get made. They create baby versions of everybody. Don't worry about it.";
			}else{

				var leader = getLeader(this.session.availablePlayers);
				if(leader && !leader.dead && leader.grimDark < 2){ //you are NOT gonna be able to convince a grim dark player to do their SBURB duties.
					if(leader.freeWill < player.freeWill){
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(leader, this.session.availablePlayers);
						//console.log(player.title() +" convinced ectobiologist to do their damn job. " +this.session.session_id);
						player.performEctobiology(this.session);
						return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules. They pester the " + leader.htmlTitle() + " to do Ectobiology. That's why they're the leader. They bug and fuss and meddle and finally the " + leader.htmlTitle() + " agrees to ...just FUCKING DO IT.  Baby versions of everybody are created. Don't worry about it.";

					}else if(player.power > 50){
						//console.log(player.title() +" mind controlled ectobiologist to do their damn job. " +this.session.session_id);
						player.performEctobiology(this.session);
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(leader, this.session.availablePlayers);
						var trait = this.getManipulatableTrait(player)
						return "The " + player.htmlTitle() + timeIntro + " is not going to play by SBURB's rules.  When bugging and fussing and meddling doesn't work, they decide to rely on game powers. They straight up manipulate the recalcitrant " + leader.htmlTitle() + "'s " + trait + " until they just FUCKING DO ectobiology.  Baby versions of everybody are created. The " + player.htmlTitle() + timeIntro + " immediatley drops the effect. It's like it never happened. Other than one major source of failure being removed from the game. " ;
					}
				}
			}
		}
		return null;
	}

	//if self, just fucking do it. raise land level. otherwise, pester them. raise power to min requirement, if it's not already there.
	//or if knight, drag their ass to the planet and do some.
	this.considerMakingSpacePlayerDoJob = function(player){
		var space = findAspectPlayer(this.session.availablePlayers, "Space");
		if(space && space.landLevel < this.session.goodFrogLevel && player.knowsAboutSburb() && player.grimDark < 2 ){ //grim dark players don't care about sburb
			if(player == space){
				//console.log(player.title() +" did their damn job breeding frogs. " +this.session.session_id);
				space.landLevel += 10;
				removeFromArray(player, this.session.availablePlayers);
				return "The " + player.htmlTitle() + " is not going to fall into SBURB's trap. They know why frog breeding is important, and they are going to fucking DO it. ";
			}else{
				var timeIntro = "";
				if(player.aspect == "Time" && Math.random()>.25){
					timeIntro = " from the future"
				}
				if(!space.dead){
					if(space.freeWill < player.freeWill && space.grimDark < 2){  //grim dark players just don't do their SBURB duties unless forced.
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(player, this.session.availablePlayers);
						//console.log(player.title() +" convinced space player to do their damn job. " +this.session.session_id);
						space.landLevel += 10;
						return "The " + player.htmlTitle() + timeIntro + " is not going to to fall into SBURB's trap. They pester the " + space.htmlTitle() + " to do frog breeding, even if it seems useless. They bug and fuss and meddle and finally the " + space.htmlTitle() + " agrees to ...just FUCKING DO IT.";

					}else if(player.power > 50){
						//console.log(player.title() +" mind controlled space player to do their damn job. " +this.session.session_id);
						space.landLevel += 10;
						removeFromArray(player, this.session.availablePlayers);
						removeFromArray(space, this.session.availablePlayers);
						var trait = this.getManipulatableTrait(player)
						return "The " + player.htmlTitle() + " is not going to to fall into SBURB's trap. When bugging and fussing and meddling doesn't work, they decide to rely on game powers. They straight up manipulate the recalcitrant " + space.htmlTitle() + "'s " + trait + " until they just FUCKING DO frog breeding for awhile. The " + player.htmlTitle() + " drops the effect before it can change something permanent. " ;
					}
				}
			}
		}
		return null;
	}


	this.considerBreakFreeControl = function(player){
		var ip = player.influencePlayer;
		if(ip){
			////console.log("I definitely am mind controlled. " + player.title() + " by " + ip.title() + " " + this.session.session_id);
			if(ip.dead){
				removeFromArray(player, this.session.availablePlayers);
				player.influencePlayer = null;
				player.influenceSymbol = null;
				player.stateBackup.restoreState(player);
				this.renderPlayer1 = player;
				//console.log("freed from control  with influencer death" +this.session.session_id);
				return "With the death of the " + ip.htmlTitleBasic() + ", the " + player.htmlTitle() + " is finally free of their control. ";
			}else if(player.dead){
				removeFromArray(player, this.session.availablePlayers);
				player.influencePlayer = null;
				player.influenceSymbol = null;
				player.stateBackup.restoreState(player);
				this.renderPlayer1 = player;
				//console.log("death freed player from control" +this.session.session_id);
				return "In death, the " + player.htmlTitle() + " is finally free of the " + ip.htmlTitle() + "'s control.";
			}else if(player.freeWill > ip.freeWill){
				removeFromArray(player, this.session.availablePlayers);
				player.influencePlayer = null;
				player.influenceSymbol = null;
				player.stateBackup.restoreState(player);
				this.renderPlayer1 = player;
				//console.log("freed from control with player will" +this.session.session_id);
				return "The " + player.htmlTitle() + " manages to wrench themselves free of the " + ip.htmlTitle() + "'s control.";
			}else{
				////console.log("The " + player.title() + "cannot break free of the " + ip.title() + "'s control. IP Dead: " + ip.dead + " ME Dead: " + player.dead + " My FW: " + player.freeWill + " IPFW:" + ip.freeWill)
				return null;
			}
		}
		////console.log("returning null")
		return null;
	}

	this.getPlayerDecision = function(player){
		//reorder things to change prevelance.
		var ret = null;  //breaking free of mind control doesn't happen here.
		//consider trying to force someone to love you.either through wordss (like horrus/rufioh (not that horrus knew that's what was happening) or through creepy game powers.
		if(ret == null) ret = this.considerCalmMurderModePlayer(player);
		if(ret == null) ret = this.considerKillMurderModePlayer(player);
		//let them decide to enter or leave grim dark, and kill or calm grim dark player
		if(ret == null) ret = this.considerDisEngagingMurderMode(player); //done
		if(ret == null) ret = this.considerMakingEctobiologistDoJob(player); //done
		if(ret == null) ret = this.considerMakingSpacePlayerDoJob(player);  //done
		if(ret == null) ret = this.considerForceGodTier(player); //done
		if(ret == null) ret = this.considerMakeSomeoneLove(player);
		if(ret == null) ret = this.considerEngagingMurderMode(player);  //done

		return ret;
	}

	this.content = function(){
		this.session.hasFreeWillEvents = true;
		//var ret = "<img src = 'images/free_will_event.png'/><Br>"; //get rid of prefix soon.
		var ret = ""
		removeFromArray(this.player, this.session.availablePlayers);
		ret += this.decision;  //it already happened, it's a string. ineligible for being an important event influencable by yellow yard. (john's retcon time powers can confound a decision like this tho)

		return ret;
	}
}
