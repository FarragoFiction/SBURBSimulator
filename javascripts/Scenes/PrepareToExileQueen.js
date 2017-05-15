function PrepareToExileQueen(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;

	this.findSufficientPlayer = function(){
		//old way tended to have only one player do the thing each session. make it a team effort now.
		var potentials = [findAspectPlayer(this.session.availablePlayers, "Void")];
		potentials.push(findAspectPlayer(this.session.availablePlayers, "Mind"));
		potentials.push(findAspectPlayer(this.session.availablePlayers, "Hope"));
		potentials.push(findClassPlayer(this.session.availablePlayers, "Thief"));
		potentials.push(findClassPlayer(this.session.availablePlayers, "Rogue"));
		this.player =  getRandomElementFromArray(potentials);
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.trigger = function(playerList){
		this.player = null;
		this.playerList = playerList;
		this.findSufficientPlayer(this.session.availablePlayers);
		return (this.player != null) && (this.session.queen.getHP() > 0 && !this.session.queen.exiled);
	}

	this.moderateDamage = function(){
		console.log("moderate damage to queen's power in: " + this.session.session_id)
		var ret = "The " + this.player.htmlTitle() + " "
		var possibilities = ["performs a daring assassination mission against one of the Black Queen's agents, losing her a valuable ally. " ];
		this.session.queen.power += -10;
		return ret + getRandomElementFromArray(possibilities);
	}

	this.heavyDamage = function(){
		console.log("heavy damage to queen's power in: " + this.session.session_id)
		var ret = "The " + this.player.htmlTitle() + " "
		var possibilities = ["performs a daring spy mission, gaining valuable intel to use on the Black Queen. "];
		this.session.queen.power += -15;
		return ret + getRandomElementFromArray(possibilities);
	}

	this.lightDamage = function(){
		console.log("light damage to queen's power in: " + this.session.session_id)
		var ret = "The " + this.player.htmlTitle() + " "
		var possibilities = ["makes a general nuisance of themselves to the Black Queen"];
		this.session.queen.power += -5; //ATTENTION FUTURE JR:  you will look at this and wonder why we didn't make it proportional to the queens power. after all,  a five decrease is HUGE to an uncrowned queen and nothing to a First Guardian Queen.   Consider Xeno's paradox, however. If we do it that way, the closer we get to exiling the queen, the less power we'll take from her. She'll never reach zero. DO NOT FUCKING DO THIS.
		//also, maybe it SHOULD be fucking nothing to a first guardian queen. why the fuck does she care about whatever bullshit you doing. she's a GOD.
		return ret + getRandomElementFromArray(possibilities);
	}

	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, this.session.availablePlayers);
		//NOT RANDOM ANY MORE. INSTEAD BASED ON PLAYER POWER VS QUEEN POWER
		//generally will start with light and owrk your way up.
		if(player.power * 2 < this.queen.getPower()){ //queen is 100 and you are less than 50
			return this.lightDamage();
		}else if(player.power < this.queen.getPower()){ //queen is 100 and you are at least 50
			return this.moderateDamage();
		}else if(player.power > this.queen.getPower()){
			return this.heavyDamage(;)
		}
	}
}
