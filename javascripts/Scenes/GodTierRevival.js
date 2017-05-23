function GodTierRevival(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.godsToRevive = [];

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.godsToRevive = [];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		var deadPlayers = findDeadPlayers(playerList);
		for(var i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this.
			if(p.godTier && p.canGodTierRevive){
				this.godsToRevive.push(p);
			}
		}
		return this.godsToRevive.length > 0;

	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_tiger";
		var ch = canvasHeight;
		if(this.godsToRevive.length > 6){
			ch = canvasHeight*2;
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		var live_players = [];
		var dead_players = [];
		for(var i = 0; i<this.godsToRevive.length; i++){
			var p = this.godsToRevive[i]
			if(p.dead == false){
				live_players.push(this.godsToRevive[i]);
			}else{
				dead_players.push(this.godsToRevive[i]);
			}
		}

		drawGodRevival(canvasDiv, live_players, dead_players,repeatTime)
	}

	//in retrospect this doesn't make sense. they are already dead here and can not be revived.
	this.addImportantEvent = function(player){
			return null;
	}

	this.content = function(){
		var ret = " <img src = 'images/sceneIcons/judgement_icon.png'>The game abstraction of the Judgement Clock is ruling on the death of the " + getPlayersTitles(this.godsToRevive ) + ". ";
		var breakNeeded = 200;
		for(var i = 0; i< this.godsToRevive.length; i++){
			var p = this.godsToRevive[i];
			ret += " The " + p.htmlTitle() + "'s death is judged to be ";
			var roll = p.rollForLuck();
			if(p.justDeath()){
				if(roll > breakNeeded){
					//console.log(roll + " lucky break for god tier revival in: " + this.session.session_id );
					ret += " ... a LUCKY BREAK!!!!!!!! The Judgement Clock narrowly avoids ruling a JUST death. ";
					p.canGodTierRevive = true;
					p.increasePower();
					p.makeAlive();
				}else{
					//console.log(roll + " just death for god tier in: " + this.session.session_id );
					ret += " JUST.  They do not revive. ";
					this.session.justDeath = true;
					p.canGodTierRevive = false;
					if(p.didDenizenKillYou()){
						p.causeOfDeath += " (it was a JUST judgement because they were corrupt)"
					}else{
						p.causeOfDeath += " (it was a JUST judgement)"
					}

					this.session.afterLife.addGhost(makeRenderingSnapshot(p));
				}

			}else if (p.heroicDeath()){
				if(roll > breakNeeded){
					//console.log(roll + " lucky break for god tier revival in: " + this.session.session_id );
					ret += " ... a LUCKY BREAK!!!!!!!! The Judgement Clock narrowly avoids ruling a HEROIC death. ";
					p.canGodTierRevive = true;
					p.increasePower();
					p.makeAlive();
				}else{
					this.session.heroicDeath = true;
					//console.log(roll + " heroic death for god tier in: " + this.session.session_id );
					ret += " HEROIC. They do not revive. ";
					p.canGodTierRevive = false;
					p.causeOfDeath += " (it was HEROIC judgement)"
					this.session.afterLife.addGhost(makeRenderingSnapshot(p));
				}
			}else{
				if(roll < -1 * breakNeeded){
					//console.log("unlucky break for god tier revival in: " + this.session.session_id);
					ret += " ... Huh. Should the clock be DOING that? It's on both HEROIC and JUST at the same time, somehow? Not neither of them. Talk about a BAD BREAK. They do not revive.  ";
					p.canGodTierRevive = false;
					p.causeOfDeath += " (it was an unlucky judgement) "
					this.session.afterLife.addGhost(makeRenderingSnapshot(p));
				}else{
					//console.log("god tier revival in: " + this.session.session_id);
					ret += " neither HEROIC nor JUST.  They revive in a rainbow glow, stronger than ever. ";
					p.canGodTierRevive = true;
					p.increasePower();
					p.makeAlive();
					if(this.aspect == "Doom"){ //powered by their own doom.
						console.log("doom is powered by their own death: " + this.session.session_id) //omg, they are sayians.
						this.power += 500;
						this.minLuck = 500; //prophecy fulfilled. you are no longer doomed. (will probably get drained again quickly, tho).  Do...do doom players EVER revive?????
						ret += " They prophesied this death. Now that their Doom is over, they can finally get on with their life. "
						console.log("godtier doom player using their own death as a source of power. so proud of this. "  + this.session.session_id);
					}
				}
			}

		}
		return ret;
	}
}
