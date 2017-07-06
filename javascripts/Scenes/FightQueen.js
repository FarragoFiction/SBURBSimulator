function FightQueen(session){
	this.canRepeat = true;
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.queen.getStat("currentHP") > 0) &&  !this.session.queen.dead&&(findLivingPlayers(this.session.players).length != 0) ;
	}


//includes time clones
	this.getGoodGuys = function(){
		var living = findLivingPlayers(this.session.players);
		var allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

		for(var i = 0; i<allPlayers.length; i++){
			living = living.concat(allPlayers[i].doomedTimeClones)
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
		if(this.session.queen.getStat("power") < 0) console.log("rendering fight queen with negative power " +this.session.session_id)
		div.append("<br> <img src = 'images/sceneIcons/bq_icon.png'> ");
		div.append(this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		var fighting = this.getGoodGuys()
		if(this.session.democraticArmy.getStat("currentHP") > 0) fighting.push(this.session.democraticArmy)
		this.session.queen.strife(div, fighting,0)

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
		//console.log("Queen Strength : " + this.session.queenStrength)
		var badPrototyping = findBadPrototyping(this.playerList);
		var living = findLivingPlayers(this.session.players);
		var ret = " Before the players can reach the Black King, they are intercepted by the Black Queen. ";
		if(badPrototyping && this.session.queen.crowned){
			ret += " She is made especially ferocious with the addition of the " + badPrototyping + ". ";
		}else if(!this.session.queen.crowned){
			ret += "She may no longer have her RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD, but she is dedicated to her duty and will fight the Players to the bitter end."
		}

		this.setPlayersUnavailable(living);

		return ret;

	}
}
