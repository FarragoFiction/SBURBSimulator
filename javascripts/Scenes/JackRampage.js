
//if jack is much stronger than a player, insta-kills them.
//can fight 0 or more players at once. (if zero, he just kills nonplayers.)
//total playerStrength must be at least half of his to survive.
function JackRampage(session){
	this.session = session;
	this.canRepeat = true;

	this.trigger = function(playerList){
		//console.log("Jack is: " + this.session.jackStrength  + " and King is: " + this.session.kingStrength)
		return this.session.jackStrength > this.session.kingStrength && this.session.jackStrength > 0; //Jack does not stop showing us his stabs.
	}

	this.getStabList = function(){
		var numStabbings = getRandomInt(0,Math.min(2,this.session.availablePlayers.length));
		var ret = [];
		if(this.session.availablePlayers.length == 0){
			return ret;
		}
		for(var i = 0; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(this.session.availablePlayers));
		}
		return Array.from(new Set(ret));
	}


	this.renderContent = function(div){
		//div.append("<br>"+this.content());

		//jack finds 0 or more players.
		var stabbings = this.getStabList();
		var ret = "";
		if(stabbings.length == 0){
			if(Math.seededRandom() > .5){
				ret += " Jack listlessly shows his stabs to a few Prospitian pawns. "
			}else{
				ret += " Jack listlessly shows his stabs to a few Dersite pawns. "
			}
			ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
			this.session.timeTillReckoning = 0;
			return ret;
		}
		this.setPlayersUnavailable(stabbings);
		var partyPower = getPartyPower(stabbings);
		if(partyPower > this.session.jackStrength*5){
			ret += getPlayersTitles(stabbings) + " suprise Jack with stabbings of their own. He is DEAD. ";
			this.session.jackStrength =  -9999;
			this.levelPlayers(stabbings);
			ret += findDeadPlayers(this.session.players).length + " players are dead in the wake of his rampage. ";
		}else if(partyPower > this.session.jackStrength){
			ret += " Jack fails to stab " + getPlayersTitles(stabbings);
			ret += "  He goes away to stab someone else, licking his wounds. ";
			if(Math.seededRandom()>.9){
				ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
				timeTillReckoning = 0;
			}
			this.minorLevelPlayers(stabbings);
			this.session.jackStrength += -10;
		}else if(partyPower == this.session.jackStrength){
			ret += " Jack is invigorated by the worthy battle with " + getPlayersTitles(stabbings);
			ret += " he retreats, for now, but with new commitment to stabbings. ";
			this.session.jackStrength += 10;
		}else{
			ret += " Jack shows his stabs to " + getPlayersTitles(stabbings) + " until they die.  DEAD.";
			div.append("<br>"+ret);
			this.killPlayers(stabbings);
			var divID = (div.attr("id"))
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvas = document.getElementById("canvas"+ divID);
			poseAsATeam(canvas, stabbings);
			//foundRareSession(div, "Jack murders. " + this.session.session_id);
			return;//make sure text is over image
		}
		div.append("<br>"+ret);
	}

	this.killPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].dead = true;
			stabbings[i].causeOfDeath = "after being shown too many stabs from Jack";
		}
	}

	this.levelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings.level_index +=2;
			stabbings[i].leveledTheHellUp = true;
		}
	}

	this.minorLevelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
			stabbings[i].increasePower();
		}
	}



	this.setPlayersUnavailable = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}

	this.addImportantEvent = function(players){
		var current_mvp =  findStrongestPlayer(this.session.players)
		for(var i = 0; i<players.length; i++){
			var player = players[i];
			if(player.isDreamSelf == true && player.godDestiny == false && player.godTier == false){
				var ret = this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
				if(ret){
					return ret;
				}
				return this.session.addImportantEvent(new PlayerDiedButCouldGodTier(this.session, current_mvp.power,player) );
			}
		}

	}

	this.content = function(){
		//jack finds 0 or more players.
		var stabbings = this.getStabList();
		var ret = "";
		if(stabbings.length == 0){
			if(Math.seededRandom() > .5){
				ret += " Jack listlessly shows his stabs to a few Prospitian pawns. "
			}else{
				ret += " Jack listlessly shows his stabs to a few Dersite pawns. "
			}
			ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
			this.session.timeTillReckoning = 0;
			return ret;
		}
		this.setPlayersUnavailable(stabbings);
		var partyPower = getPartyPower(stabbings);
		if(partyPower > this.session.jackStrength*5){
			ret += getPlayersTitles(stabbings) + " suprise Jack with stabbings of their own. He is DEAD. ";
			this.session.jackStrength =  -9999;
			this.levelPlayers(stabbings);
			ret += findDeadPlayers(this.session.players).length + " players are dead in the wake of his rampage. ";
		}else if(partyPower > this.session.jackStrength){
			ret += " Jack fails to stab " + getPlayersTitles(stabbings);
			ret += "  He goes away to stab someone else, licking his wounds. ";
			//TODO if one of them was a god tier, make their be a chance of him destroying one of the moons. kills all non active dream selves.
			if(Math.seededRandom()>.9){
				ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
				timeTillReckoning = 0;
			}
			this.minorLevelPlayers(stabbings);
			this.session.jackStrength += -10;
		}else if(partyPower == this.session.jackStrength){
			ret += " Jack is invigorated by the worthy battle with " + getPlayersTitles(stabbings);
			ret += " he retreats, for now, but with new commitment to stabbings. ";
			this.session.jackStrength += 10;
		}else{
			var alt = this.addImportantEvents(stabbings);
			if(alt){
				alt.alternateScene(div);
				return;
			}else{
				ret += " Jack shows his stabs to " + getPlayersTitles(stabbings) + " until they die.  DEAD.";
				this.killPlayers(stabbings);
		}
		}
		return ret;
	}
}
