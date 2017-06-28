//x times corpse smooch combo.
function CorpseSmooch(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dreamersToRevive = [];
	this.combo = 0;

	this.trigger = function(playerList){
		//console.log('checking corpse smooch')
		this.playerList = playerList;
		this.dreamersToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this. if you're a jerk, no luck.
			//if(p.dreamSelf){ //no longer only dream self cause this generates important events for ANY death that is left unfixed.
			this.dreamersToRevive.push(p);
			//}
		}
		//corspses can't smooch themselves.
		var living = findLivingPlayers(this.session.players);
		//console.log(this.dreamersToRevive.length + " vs "  + playerList.length)
		return this.dreamersToRevive.length > 0 && living.length>0;

	}

	this.renderContent = function(div){
		this.dreamersToRevive;
		////console.log(this.dreamersToRevive)
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
		d.dreamSelf = false; //only one self now.
		d.isDreamSelf = true;
		d.makeAlive();
	}

	this.makeDead = function(d){
		//console.log("make dead " + d.title())
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
		drawSpriteFromScratch(dSpriteBuffer,dead_player)

		copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,0,0)
		copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,200,0)

		var moonBuffer = getBufferCanvas(document.getElementById("canvas_template"));
		drawMoon(moonBuffer, dead_player);
		this.makeAlive(dead_player);
		drawSprite(moonBuffer,dead_player)
		copyTmpCanvasToRealCanvasAtPos(canvas, moonBuffer,600,0)
		//dead_player.renderSelf();
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
			if(royalty && royalty.grimDark  > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		//from here on out, prefer to god tier than to be corpse smooched.
		if(!royalty ){
			//okay, anybody free?
			royalty = getRandomElementFromArray(findLivingPlayers(this.session.availablePlayers));
			if(royalty && royalty.grimDark > 0){
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
			if(royalty && royalty.grimDark > 0){
				royalty = null; //grim dark won't corpse smooch unless they actual want to.
			}
		}
		royalty = this.ignoreEnemies(d, royalty);
		if(!royalty && d.godDestiny){
			//console.log("I couldn't find royalty and also could god tier. " + this.session.session_id);
		}
		return royalty;
	}

	this.renderForPlayer = function(div, deadPlayer){
		var royalty = this.getRoyalty(deadPlayer)
		if(royalty){
			deadPlayer.interactionEffect(royalty);
			royalty.interactionEffect(deadPlayer);
			var divID = (div.attr("id")) + "_" + deadPlayer.chatHandle;
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvas"+ divID);
			this.drawCorpseSmooch(canvasDiv, deadPlayer, royalty, 1000)
		}else{
			console.log("dream self dies from no corpse smooch: " + this.session.session_id)
			deadPlayer.isDreamSelf = true;
			deadPlayer.causeOfDeath = "sympathetic wounds after real self died unsmooched"
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
			if(d.dreamSelf == true){
				var royalty = this.getRoyalty(d);
				if(royalty){
					royalty.sanity += -10;
					ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
					ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
					if(d.aspect == "Doom") ret += "The prophecy is fulfilled. ";
					this.renderForPlayer(div, this.dreamersToRevive[i]);
					//this.makeAlive(d);
					this.combo ++;
				}else{
					//console.log("Adding important event god tier for: " + d.title())
					var alt = this.addImportantEvent(d);
					//console.log("alt is: " +alt);
					if(alt && alt.alternateScene(div)){
						//do nothing here.
					}else{
						ret += "<Br><Br><img src = 'images/sceneIcons/death_icon.png'>" + d.htmlTitle() + "'s waits patiently for the kiss of life. But nobody came. ";
						ret += " Their dream self dies as well. ";
						this.makeDead(d);
					}
				}
			}else if(d.isDreamSelf == true && d.godDestiny == false && d.godTier == false && d.dead == true){
				var alt = this.addImportantEvent(d);
					if(alt && alt.alternateScene(div)){
					}else{
						//don't even mention corpse smooching for dream selves. but them perma-dying is an event.
					}
			}
		}
		if(this.combo > 1){
			ret += this.combo +"X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;
	}

	this.addImportantEvent = function(player){
		//console.log("adding important event from corpse smooch")
		var current_mvp =  findStrongestPlayer(this.session.players)
		//only one alternate event can happen at a time. if one gets replaced, return
		if(player.godDestiny == false && player.godTier == false){//could god tier, but fate wn't let them
			return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
		}else if(this.session.reckoningStarted == true && player.godTier == false) { //if the reckoning started, they couldn't god tier.
			var ret = this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
		}
		return ret;
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
				royalty.sanity += -10;
				ret += " The " + royalty.htmlTitle() + ", as a member of the royalty of " + royalty.moon + ", administers the universal remedy for the unawakened ";
				ret += " to the " + d.htmlTitle() + ". Their dream self takes over on " + d.moon + ". ";
				this.makeAlive(d);
				combo ++;
			}else{
				ret += d.htmlTitle() + "'s waits patiently for the kiss of life. But nobody came. ";
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
