function GoGrimDark(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.player = null;
		//select a random player. if they've been triggered, random chance of going grim dark (based on how triggered.)
		for(var i = 0; i< this.playerList.length; i++){//never, EVER fix this to be available players.  corpses shouldu ALWAYS be able to go grim dark, this is HILARIOUS
			var p = this.playerList[i]
			if(p.corruptionLevelOther >= 50){
				this.player = p;
				return true;
			}
		}
		return false;
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		return this.session.addImportantEvent(new PlayerWentGrimDark(this.session, current_mvp.power,this.player) );
	}

	this.renderContent = function(div){
		var alt = this.addImportantEvent();
		if(alt && alt.alternateScene(div)){
			return;
		}
		div.append("<br>"+this.content());
		if(this.player.grimDark ==4){
			var divID = div.attr("id") + "grimdark"
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvas"+ divID);
			drawSinglePlayer(canvasDiv, this.player);
		}
	}

	//modify land quests and etc. physical contact with a grim dark player raises your corruption levels.
	this.raiseGrimDarkLevel = function(){
			this.player.changeGrimDark(1);  //this SHOULD be the only way to modify grim dark level upwards
			this.player.corruptionLevelOther = 0; //reset corruption level
			var ret = "";
			if(this.player.grimDark == 1){
				ret += " The " + this.player.htmlTitle() + " is starting to seem a little strange. They sure do like talking about Horrorterrors!"
			}else if(this.player.grimDark == 2){
				this.player.nullAllRelationships();
				ret += " The " + this.player.htmlTitleBasic() + " isn't responding to chat messages much anymore. "
			}else if(this.player.grimDark == 3){
				this.player.power += 100;
				this.player.aspectIncreasePower(100);
				ret += " The " + this.player.htmlTitleBasic() + " will tell anyone who will listen that the game needs to be broken. "
			}else if(this.player.grimDark == 4){
				this.player.power += 100;
				console.log("full grim dark: " + this.session.session_id)
				this.player.aspectIncreasePower(100);
				ret +=  "The " + this.player.htmlTitleBasic() + " slips into the fabled blackdeath trance of the woegothics, quaking all the while in the bloodeldritch throes of the broodfester tongues.";
				ret += " It is now painfully obvious to anyone with a brain, they have basically gone completely off the deep end in every way. The "
				ret += this.player.htmlTitle() + " has officially gone grimdark. ";
			}
			return ret;
	}

	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, this.session.availablePlayers);
		var ret = this.raiseGrimDarkLevel();
		return ret;
	}
}
