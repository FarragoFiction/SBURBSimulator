//x times corpse smooch combo.
function CorpseSmooch(){
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dreamersToRevive = [];

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dreamersToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this. if you're a jerk, no luck.
			if(p.dreamSelf && p.getFriends().length > 0){
				this.dreamersToRevive.push(p);
			}
		}
		//corspses can't smooch themselves.
		return this.dreamersToRevive.length > 0 && this.dreamersToRevive.length < playerList.length;

	}

	this.renderContent = function(div){
		div.append(this.content());
		for(var i = 0; i<this.dreamersToRevive.length; i++){
			this.renderForPlayer(div, this.dreamersToRevive[i]);
		}
	}

	//smoocher on left, corpse on right, them waking up on prospit/derse on far right
	this.drawCorpseSmooch = function(canvas, dead_player, royalty, repeatTime){
		var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(pSpriteBuffer,royalty,repeatTime)

		dead_player.dead = true;
		dead_player.isDreamSelf = false;  //temporarily show non dream version
		var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
		drawSprite(dSpriteBuffer,dead_player,repeatTime)



		setTimeout(function(){
			copyTmpCanvasToRealCanvasAtPos(canvas, pSpriteBuffer,-100,0)
			copyTmpCanvasToRealCanvasAtPos(canvas, dSpriteBuffer,100,0)
		}, repeatTime);  //images aren't always loaded by the time i try to draw them the first time.

		//want to let corpse render before i revive it
			var moonBuffer = getBufferCanvas(document.getElementById("canvas_template"));
			drawMoon(moonBuffer, dead_player);
			dead_player.dead = false;
			dead_player.isDreamSelf = true;
			drawSprite(moonBuffer,dead_player,repeatTime)
			copyTmpCanvasToRealCanvasAtPos(canvas, moonBuffer,600,0)

	}

	this.getRoyalty = function(d){
		var royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(availablePlayers));

		if(!royalty){
			//okay, princes are traditional...
			royalty = findClassPlayer(findLivingPlayers(availablePlayers), "Prince");
		}
		if(!royalty){
			//okay, anybody free?
			royalty = getRandomElementFromArray(findLivingPlayers(availablePlayers));
		}

		//shit, maybe your best friend can drop what they are doing to save your ass?
		if(!royalty){
			royalty = d.getWhoLikesMeBestFromList(findLivingPlayers(players));
		}
		//is ANYBODY even alive out there????
		if(!royalty){
			royalty = getRandomElementFromArray(findLivingPlayers(players));
		}
		return royalty;
	}

	this.renderForPlayer = function(div, deadPlayer){
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_" + deadPlayer.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+ divID);
		var royalty = this.getRoyalty(deadPlayer)
		var context = this; //bulshit scoping inside of timeout


		setTimeout(function(){
			context.drawCorpseSmooch(canvasDiv, deadPlayer, royalty, repeatTime)
		}, repeatTime/2);  //images aren't always loaded by the time i try to draw them the first time.
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
				d.dead = false;
				d.dreamSelf = false;
				d.isDreamSelf = true;
				d.murderMode = false;
				d.grimDark = false;
				d.triggerLevel = 1;
				combo ++;
			}else{
				ret += d.htmlTitle() + "'s corpse waits patiently for the kiss of life. But nobody came. ";
				ret += " Their dream self dies as well. ";
				d.dreamSelf = false;
			}
		}
		if(combo > 1){
			ret += combo +"X CORPSEMOOCH COMBO!!!";
		}
		//x times corpse smooch combo
		return ret;

	}

}
