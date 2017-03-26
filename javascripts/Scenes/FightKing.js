function FightKing(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		//console.log('fight kin trigger?')
		return (this.session.kingStrength > 0) &&  (this.session.queenStrength <= 0) && (findLivingPlayers(this.session.players).length != 0) ;
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
			stabbings.level_index +=2;
		}
	}



this.getGoodGuys = function(){
		var living = findLivingPlayers(this.session.players);
		var timePlayer = findAspectPlayer(this.session.players, "Time");

		for(var i = 0; i<timePlayer.doomedTimeClones.length; i++){
			var timeClone = timePlayer.doomedTimeClones[i];
			living.push(timeClone);
		}
		return living;
	}

	//render each living player, each time clone, and some dersites/prospitan rabble (maybe)
	this.renderGoodguys = function(div){
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_final_boss";
		var ch = canvasHeight;
		var fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		poseAsATeam(canvasDiv, fightingPlayers, 2000);
	}

	this.renderContent = function(div){
		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		div.append("<br>");
		div.append(this.content());

	}

	this.minorLevelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
		}
	}



	this.setPlayersUnavailable = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}

	this.getDeadList = function(living){
		var numStabbings = getRandomInt(0,living.length);
		var timePlayer = findAspectPlayer(this.session.players, "Time");
		var ret = [];
		//doomed time clones absorb some of the hits.
		for(var i = 0; i<timePlayer.doomedTimeClones.length; i++){
				ret.push(timePlayer.doomedTimeClones[i]);
				removeFromArray(timePlayer.doomedTimeClones[i], timePlayer.doomedTimeClones)
		}

		if(living.length == 0){
			return ret;
		}
		for(var i = ret.length; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(living));
		}
		return Array.from(new Set(ret));
	}



	this.content = function(){
		var badPrototyping = findBadPrototyping(this.playerList);
		var living = findLivingPlayers(this.session.players);
		var ret = " It is time for the final opponent, the Black King. ";
		if(badPrototyping){
			ret += " He is made especially terrifying with the addition of the " + badPrototyping + ". ";
		}

		this.setPlayersUnavailable(living);
		var partyPower = getPartyPower(living);
		var timePlayer = findAspectPlayer(this.session.players, "Time"); //doesn't matter if THEY are alive or dead, they still have doomed time clones.
		if(timePlayer.doomedTimeClones.length > 0){
			//throw an extra one at them from nowhere just to make sure it's plural. whatever. who's counting here?
			ret += (timePlayer.doomedTimeClones.length) + " doomed time clones of the " + timePlayer.htmlTitleBasic() + " show up from various points in the timeline to help out. ";
			partyPower += 100 * (timePlayer.doomedTimeClones.length);
		}

		if(this.session.democracyStrength > 1){
			ret += " The Warweary Villein has assembled an army to help the Players. ";
			partyPower += this.session.democracyStrength;
			this.session.democracyStrength += -1 * getRandomInt(0,this.session.democracyStrength-1); //how badly is democracy hurt?
		}

		if(partyPower > this.session.kingStrength*5){
			ret += "The Players easily defeat the King, no sweat. It was easy. He is DEAD. ";
			this.session.kingStrength = 0;
			this.levelPlayers(living);
		}else{
			var deadPlayers = this.getDeadList(living);
			if(deadPlayers.length > 0){
				ret += " The king brutally destroys the " + getPlayersTitles(deadPlayers) + ".  DEAD.";
			}
			if(this.session.democracyStrength < 10){
				ret += " The King decimates the democractically assembled Army. ";
			}
			this.killPlayers(deadPlayers);
			living = findLivingPlayers(this.session.players);
			if(living.length > 0 ){
				ret += " After the smoke clears, the king is defeated. DEAD.";
				this.session.kingStrength = 0;
				this.levelPlayers(living);
			}else{
				ret += " The party is defeated. ";
			}
		}

		if(this.session.kingStrength > 10){
			this.session.kingStrength += -10;
		}
		return ret;

	}
}
