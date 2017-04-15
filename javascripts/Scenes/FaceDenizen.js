function FaceDenizen(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.denizenFighters = [];

	this.trigger = function(playerList){
		this.denizenFighters = [];
		this.playerList = playerList;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i]
			if(p.landLevel >= 12 && !p.denizenFaced && p.land != null){
				this.denizenFighters.push(p);
			}
		}
		return this.denizenFighters.length > 0;
	}

	this.addImportantEvent = function(player){
		var current_mvp =  findStrongestPlayer(this.session.players)
		//need to grab this cause if they are dream self corpse smooch won't trigger an important event
		if(player.godDestiny == false && player.isDreamSelf == true){//could god tier, but fate wn't let them
			var ret = this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}else if(this.session.reckoningStarted == true && player.isDreamSelf == true) { //if the reckoning started, they couldn't god tier.
			var ret  = this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
			if(ret){
				return ret;
			}
			this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
		}else if(player.isDreamSelf == true){
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
		}
	}

	this.renderContent = function(div){

		for(var i = 0; i<this.denizenFighters.length; i++){
			var ret = "<br>";
			var p = this.denizenFighters[i];
			removeFromArray(p, this.session.availablePlayers);
			//ret += "Debug Power: " + p.power;
			//fight denizen
			if(p.getFriends().length < p.getEnemies().length){
				ret += " The " + p.htmlTitle() + " sneak attacks their denizen, " + p.getDenizen() + ". ";
				if(p.power > 7){
					ret += " They win handly, and obtain untold levels of power and sweet sweet hoarde grist. They gain all the levels. All of them. ";
					p.denizenFaced = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.level_index +=3;
					p.leveledTheHellUp = true;
					p.denizenDefeated = true;
					this.session.denizenBeat = true;
					//console.log("denizen beat through violence in session: " + this.session.session_id)
					div.append("<br>"+ret);
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " Huh.  They were NOT ready for that.  They are easily crushed by their Denizen. DEAD.";
					p.dead = true;
					p.causeOfDeath = "fighting their Denizen way too early";
					div.append("<br>"+ret);
					var divID = (div.attr("id"))
					var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
					div.append(canvasHTML);
					var canvas = document.getElementById("canvas"+ divID);
					drawSinglePlayer(canvas, p);
					//foundRareSession(div, "A denizen made a corpse.");

				}
			}else{//do The Choice
				ret += " The " + p.htmlTitle() + " cautiously approaches their denizen, " + p.getDenizen() + " and are presented with The Choice. ";
				if(p.power > 10){
					ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
					ret += " They gain the power they need to acomplish their objectives. ";
					p.denizenFaced = true;
					p.denizenDefeated = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.leveledTheHellUp = true;
					div.append("<br>"+ret);
					this.session.denizenBeat = true;
					//console.log("denizen beat through choice in session: " + this.session.session_id)
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + p.getDenizen() + " warns them not to come back. ";
					div.append("<br>"+ret);
				}
			}

		}
	}

	this.content = function(){
		var ret = "";
		for(var i = 0; i<this.denizenFighters.length; i++){
			var p = this.denizenFighters[i];
			removeFromArray(p, this.session.availablePlayers);
			//ret += "Debug Power: " + p.power;
			//fight denizen
			if(p.getFriends().length < p.getEnemies().length){
				ret += " The " + p.htmlTitle() + " sneak attacks their denizen, " + p.getDenizen() + ". ";
				if(p.power > 7){
					ret += " They win handly, and obtain untold levels of power and sweet sweet hoarde grist. They gain all the levels. All of them. ";
					p.denizenFaced = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.level_index +=3;
					p.leveledTheHellUp = true;
					p.denizenDefeated = true;
					this.session.denizenBeat = true;
				//	console.log("denizen beat through violence in session: " + this.session.session_id)
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " Huh.  They were NOT ready for that.  They are easily crushed by their Denizen. DEAD.";
					p.dead = true;
					p.causeOfDeath = "fighting their Denizen way too early";
				}
			}else{//do The Choice
				ret += " The " + p.htmlTitle() + " cautiously approaches their denizen, " + p.getDenizen() + " and are presented with The Choice. ";
				if(p.power > 10){
					ret += " The " + p.htmlTitle() + " manages to choose correctly, despite the seeming impossibility of the matter. ";
					ret += " They gain the power they need to acomplish their objectives. ";
					p.denizenFaced = true;
					p.denizenDefeated = true;
					p.power = p.power*2;  //current and future doubling of power.
					p.leveledTheHellUp = true;
					//this.session.denizenBeat = true;
					//console.log("denizen beat through choice in session: " + this.session.session_id)
				}else{
					p.denizenFaced = true;
					p.denizenDefeated = false;
					ret += " They are unable to bring themselves to make the clearly correct, yet impossible, Choice, and are forced to admit defeat. " + p.getDenizen() + " warns them not to come back. ";
				}
			}

		}
		return ret;
	}
}
