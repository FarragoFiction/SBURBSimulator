function FightKing(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (kingStrength > 0) &&  (queenStrength <= 0) && (findLivingPlayers(players).length != 0) ;
	}
	
	this.killPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].dead = true;
			stabbings[i].causeOfDeath = "fighting the Black King";
		}
	}
	
	this.levelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].leveledTheHellUp = true;
		}
	}
	
	this.minorLevelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
		}
	}
	

	
	this.setPlayersUnavailable = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], availablePlayers);
		}
	}
	
	this.getDeadList = function(){
		var numStabbings = getRandomInt(0,players.length);
		var ret = [];
		if(players.length == 0){
			return ret;
		}
		for(var i = 0; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(players));
		}
		return Array.from(new Set(ret));
	}
	
	
	
	this.content = function(){
		var badPrototyping = findBadPrototyping(this.playerList);
		var living = findLivingPlayers(players);
		var ret = " It is time for the final opponent, the Black King. ";
		if(badPrototyping){
			ret += " He is made especially terrifying with the addition of the " + badPrototyping + ". ";
		}
		
		this.setPlayersUnavailable(living);
		var partyPower = getPartyPower(living);
		var timePlayer = findAspectPlayer(players, "Time"); //doesn't matter if THEY are alive or dead, they still have doomed time clones.
		if(timePlayer.doomedTimeClones > 0){
			//throw an extra one at them from nowhere just to make sure it's plural. whatever. who's counting here?
			ret += (timePlayer.doomedTimeClones) + " doomed time clones of the " + timePlayer.htmlTitle() + " show up from various points in the timeline to help out. ";
			partyPower += 100 * (timePlayer.doomedTimeClones);
		}
		
		if(democracyStrength > 1){
			ret += " The Warweary Villein has assembled an army to help the Players. ";
			partyPower += democracyStrength;
			democracyStrength += -1 * getRandomInt(0,democracyStrength-1); //how badly is democracy hurt?
		}
		
		if(partyPower > kingStrength*5){
			ret += "The Players easily defeat the King, no sweat. It was easy. He is DEAD. ";
			kingStrength = 0;
			this.levelPlayers(living);
		}else{
			var deadPlayers = this.getDeadList();
			if(deadPlayers.length > 0){
				ret += " The king brutally destroys the " + getPlayersTitles(deadPlayers) + ".  DEAD.";
			}
			if(democracyStrength < 10){
				ret += " The King decimates the democractically assembled Army. ";
			}
			this.killPlayers(deadPlayers);
			living = findLivingPlayers(players);
			if(living.length > 0 ){
				ret += " After the smoke clears, the king is defeated. DEAD.";
				kingStrength = 0;
				this.levelPlayers(living);
			}else{
				ret += " The party is defeated. ";
			}
		}
		
		if(kingStrength > 10){
			kingStrength += -10;
		}
		return ret;
		
	}
}