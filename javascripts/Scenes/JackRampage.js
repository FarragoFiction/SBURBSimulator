
//if jack is much stronger than a player, insta-kills them. 
//can fight 0 or more players at once. (if zero, he just kills nonplayers.)
//total playerStrength must be at least half of his to survive. 
function JackRampage(){
	
	this.canRepeat = true;	
	
	this.trigger = function(playerList){
		return jackStrength > kingStrength && jackStrength != 0; //Jack does not stop showing us his stabs.
	}
	
	this.getStabList = function(){
		var numStabbings = getRandomInt(0,Math.min(2,availablePlayers.length));
		var ret = [];
		if(availablePlayers.length == 0){
			return ret;
		}
		for(var i = 0; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(availablePlayers));
		}
		return Array.from(new Set(ret));
	}
	

	this.renderContent = function(div){
		div.append("<br>"+this.content());
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
			removeFromArray(stabbings[i], availablePlayers);
		}
	}
	
	this.content = function(){
		//jack finds 0 or more players.
		var stabbings = this.getStabList();
		var ret = "";
		if(stabbings.length == 0){
			if(Math.random() > .5){
				ret += " Jack listlessly shows his stabs to a few Prospitian pawns. "
			}else{
				ret += " Jack listlessly shows his stabs to a few Dersite pawns. "
			}
			ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
			timeTillReckoning = 0; 
			return ret;
		}
		this.setPlayersUnavailable(stabbings);
		var partyPower = getPartyPower(stabbings);
		if(partyPower > jackStrength*5){
			ret += getPlayersTitles(stabbings) + " suprise Jack with stabbings of their own. He is DEAD. ";
			jackStrength = 0;
			this.levelPlayers(stabbings);
			ret += findDeadPlayers(players).length + " players are dead in the wake of his rampage. ";
		}else if(partyPower > jackStrength){		
			ret += " Jack fails to stab " + getPlayersTitles(stabbings);
			ret += "  He goes away to stab someone else, licking his wounds. ";
			if(Math.random()>.9){
				ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start."
				timeTillReckoning = 0; 
			}
			this.minorLevelPlayers(stabbings);
			jackStrength += -10;
		}else if(partyPower == jackStrength){
			ret += " Jack is invigorated by the worthy battle with " + getPlayersTitles(stabbings);
			ret += " he retreats, for now, but with new commitment to stabbings. ";
			jackStrength += 10;
		}else{
			ret += " Jack shows his stabs to " + getPlayersTitles(stabbings) + " until they die.  DEAD.";
			this.killPlayers(stabbings);
		}
		return ret;
	}
}