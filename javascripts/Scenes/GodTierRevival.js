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

		setTimeout(function(){
			drawGodRevival(canvasDiv, live_players, dead_players,repeatTime)
		}, repeatTime/2);  //images aren't always loaded by the time i try to draw them the first time.
	}

	this.addImportantEvent = function(player){
			var current_mvp =  findStrongestPlayer(this.session.players)
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
	}

	this.content = function(){
		var ret = " The game abstraction of the Judgement Clock is ruling on the death of the " + getPlayersTitles(this.godsToRevive ) + ". ";

		for(var i = 0; i< this.godsToRevive.length; i++){
			var p = this.godsToRevive[i];
			ret += " The " + p.htmlTitle() + "'s death is judged to be ";
			if(p.justDeath()){
				this.addImportantEvent(p);
				ret += " JUST.  They do not revive. ";
				p.canGodTierRevive = false;
			}else if (p.heroicDeath()){
				this.addImportantEvent(p);
				ret += " HEROIC. They do not revive. ";
				p.canGodTierRevive = false;
			}else{
				ret += " neither HEROIC nor JUST.  They revive in a rainbow glow, stronger than ever. ";
				p.dead = false;
				p.canGodTierRevive = true;
				p.increasePower();
				p.murderMode = false;
				p.grimDark = false;
				p.leftMurderMode = false;
				p.triggerLevel = 1;

			}

		}
		return ret;
	}
}
