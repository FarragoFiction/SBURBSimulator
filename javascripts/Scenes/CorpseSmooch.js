//x times corpse smooch combo.
function CorpseSmooch(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dreamersToRevive = [];
	this.combo = 0;

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dreamersToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this. if you're a jerk, no luck.
			if(p.dreamSelf){
				this.dreamersToRevive.push(p);
			}
		}
		//corspses can't smooch themselves.
		return this.dreamersToRevive.length > 0 && this.dreamersToRevive.length < playerList.length;

	}

	this.renderContent = function(div){
		this.combo = 0;
		div.append("<br>"+this.contentForRender(div));

		if(this.combo>1){
			var divID = (div.attr("id")) + "_" + "combo";
			var canvasHTML = "<br><canvas id='canvasCombo" + divID+"' width='" +canvasWidth + "' height="+canvasHeight/3 + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvasCombo"+ divID);
			this.drawCombo(canvasDiv, this.combo);
		}
	}

	this.makeAlive = function(d){
		//foundRareSession(div, "A player was corpse smooched alive.")
		d.dead = false;
		d.dreamSelf = false;
		d.isDreamSelf = true;
		d.murderMode = false;
		d.grimDark = false;
		d.triggerLevel = 1;
		d.leftMurderMode = false; //no scars
		d.victimBlood = null; //clean face
	}

	this.makeDead = function(d){
		d.dreamSelf = false;
		d.dead = true;
	}

	//smoocher on left, corpse on right, them waking up on prospit/derse on far right
	this.drawCorpseSmooch = function(canvas, dead_player, royalty, repeatTime){
		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,royalty)

		dead_player.dead = true;
		dead_player.isDreamSelf = false;  //temporarily show non dream version
		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(dSpriteBuffer,dead_player)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,100,0)

		var moonBuffer = getBufferCanvas(document.getElementById("canvas_template"));
		drawMoon(moonBuffer, dead_player);
		this.makeAlive(dead_player);
		drawSprite(moonBuffer,dead_player)
		copyTmpCanvasToRealCanvasAtPos(canvas, moonBuffer,600,0)
		//this.makeAlive(dead_player); //make SURE the player is alive after smooches.

	}

	this.drawCombo = function(canvas,comboNum){
		drawComboText(canvas, comboNum);
	}

	this.ignoreEnemies = function(player, royalty){
		if(!royalty){
			return null;
		}
		var r = royalty.getRelationshipWith(player);
		if(!r || (r && r.value < 0)){
			return null;
		}
		return royalty;
	}

	this.getRoyalty = function(d){
		var royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(this.session.availablePlayers));
		royalty = this.ignoreEnemies(d, royalty);
		if(!royalty){
			//okay, princes are traditional...
			royalty = findClassPlayer(findLivingPlayers(this.session.availablePlayers), "Prince");
			if(royalty && royalty.grimDark == true){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		if(!royalty){
			//okay, anybody free?
			royalty = getRandomElementFromArray(findLivingPlayers(this.session.availablePlayers));
			if(royalty && royalty.grimDark == true){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		//shit, maybe your best friend can drop what they are doing to save your ass?
		if(!royalty){
			royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(this.playerList));
		}
		royalty = this.ignoreEnemies(d, royalty);
		//is ANYBODY even alive out there????
		if(!royalty){
			royalty = getRandomElementFromArray(findLivingPlayers(this.playerList));
			if(royalty && royalty.grimDark == true){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		return royalty;
	}

	this.renderForPlayer = function(div, deadPlayer){
		var royalty = this.getRoyalty(deadPlayer)
		if(royalty){
			var divID = (div.attr("id")) + "_" + deadPlayer.chatHandle;
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvas"+ divID);
			this.drawCorpseSmooch(canvasDiv, deadPlayer, royalty, 1000)
		}else{
			this.makeDead(deadPlayer); //dream self dies, too
		}

	}

	//don't actually bring themt o life yet, cause it gets rid of grimdark/murdermode etc.
	this.contentForRender = function(div){
		var ret = "";
		this.combo = 0;
		for(var i = 0; i<this.dreamersToRevive.length; i++){
			var d = this.dreamersToRevive[i];
			//have best friend mac on you.
			var royalty = this.getRoyalty(d);

			if(royalty){
				royalty.triggerLevel ++;
				ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
				ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
				this.renderForPlayer(div, this.dreamersToRevive[i]);
				//this.makeAlive(d);
				this.combo ++;
			}else{
				this.addImportantEvent(d);
				ret += d.htmlTitle() + "'s corpse waits patiently for the kiss of life. But nobody came. ";
				ret += " Their dream self dies as well. ";
				this.makeDead(d);
			}
		}
		if(this.combo > 1){
			ret += this.combo +"X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;
	}

	this.addImportantEvent = function(player){
		var current_mvp =  findStrongestPlayer(this.session.players)
		if(player.godDestiny == false){//could god tier, but fate wn't let them
			this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}else if(this.session.reckoningStarted == true) { //if the reckoning started, they couldn't god tier.
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
			this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
		}else{
				this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}
	}

	//prefer to be smooched by prince who doesn't hate you, or person who likes you best.
	this.content = function(){
		var ret = "";
		var combo = 0;
		for(var i = 0; i<this.dreamersToRevive.length; i++){
			var d = this.dreamersToRevive[i];
			//have best friend mac on you.
			var royalty = this.getRoyalty(d);

			if(royalty){
				royalty.triggerLevel ++;
				ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
				ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
				this.makeAlive(d);
				combo ++;
			}else{
				ret += d.htmlTitle() + "'s corpse waits patiently for the kiss of life. But nobody came. ";
				ret += " Their dream self dies as well. ";
				this.makeDead(d);
			}
		}
		if(combo > 1){
			ret += combo +"X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;

	}

}
