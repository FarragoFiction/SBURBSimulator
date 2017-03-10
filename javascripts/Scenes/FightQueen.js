function FightQueen(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (queenStrength > 0) &&  (findLivingPlayers(players).length != 0) ;
	}
	
	this.killPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].dead = true;
			stabbings[i].causeOfDeath = "fighting the Black Queen";
		}
	}
	
//includes time clones
	this.getGoodGuys = function(){
		var living = findLivingPlayers(players);
		var timePlayer = findAspectPlayer(players, "Time");

		for(var i = 0; i<timePlayer.doomedTimeClones; i++){
			var timeClone = makeRenderingSnapshot(timePlayer);
			timeClone.dead = false;
			//from a different timeline, things went differently.
			var rand = Math.random();
			if(rand>.2){
				timeClone.godTier = !timeClone.godTier;
			}else if(rand>.4){
				timeClone.isDreamSelf = !timeClone.isDreamSelf;
			}else if(rand>.6){
				timeClone.grimDark = !timeClone.grimDark;
			}else if(rand>.8){
				timeClone.murderMode = !timeClone.murderMode;
			}
			
			var rand = Math.random(); //reroll for second set of traits. like grim dark dream self.
			if(rand>.2){
				timeClone.godTier = !timeClone.godTier;
			}else if(rand>.4){
				timeClone.isDreamSelf = !timeClone.isDreamSelf;
			}else if(rand>.6){
				timeClone.grimDark = !timeClone.grimDark;
			}else if(rand>.8){
				timeClone.murderMode = !timeClone.murderMode;
			}
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
	

	
	this.levelPlayers = function(stabbings){
		for(var i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].increasePower();
			stabbings[i].leveledTheHellUp = true;
			stabbings.level_index +=2;
		}
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
			removeFromArray(stabbings[i], availablePlayers);
		}
	}
	
	this.getDeadList = function(living){
		var numStabbings = getRandomInt(0,living.length);
		var ret = [];
		if(living.length == 0){
			return ret;
		}
		for(var i = 0; i<=numStabbings; i++){
			ret.push(getRandomElementFromArray(living));
		}
		return Array.from(new Set(ret));
	}
	
	
	
	this.content = function(){
		var badPrototyping = findBadPrototyping(this.playerList);
		var living = findLivingPlayers(players);
		var ret = " Before the players can reach the Black King, they are intercepted by the Black Queen. ";
		if(badPrototyping){
			ret += " She is made especially ferocious with the addition of the " + badPrototyping + ". ";
		}
		
		this.setPlayersUnavailable(living);
		var partyPower = getPartyPower(living);
		var timePlayer = findAspectPlayer(players, "Time"); //doesn't matter if THEY are alive or dead, they still have doomed time clones.
		if(timePlayer.doomedTimeClones > 0){
			//throw an extra one at them from nowhere just to make sure it's plural. whatever. who's counting here?
			ret += (timePlayer.doomedTimeClones) + " doomed time clones of the " + timePlayer.htmlTitle() + " show up from various points in the time line to help out. ";
			partyPower += 100 * (timePlayer.doomedTimeClones);
		}
		if(partyPower > queenStrength*5){
			ret += "The Players easily defeat the Queen, no sweat. It was easy. She is DEAD. ";
			queenStrength = 0;
			this.levelPlayers(living);
		}else{
			var deadPlayers = this.getDeadList(living);
			if(deadPlayers.length > 0){
				ret += " The queen efficiently destroys the " + getPlayersTitles(deadPlayers) + ".  DEAD.";
			}
			this.killPlayers(deadPlayers);
			living = findLivingPlayers(players);
			if(living.length > 0 ){
				ret += " After all is said and done, the queen is defeated. DEAD.";
				queenStrength = 0;
				this.levelPlayers(living);
			}else{
				ret += " The party is defeated. ";
			}
		}
		if(queenStrength > 10){
			queenStrength += -10;
		}
		return ret;
		
	}
}