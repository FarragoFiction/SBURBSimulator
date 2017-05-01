
//if jack is much stronger than a player, insta-kills them.
//can fight 0 or more players at once. (if zero, he just kills nonplayers.)
//total playerStrength must be at least half of his to survive.
function JackRampage(session){
	this.session = session;
	this.canRepeat = true;

	this.trigger = function(playerList){
		//console.log("Jack is: " + this.session.jackStrength  + " and King is: " + this.session.kingStrength)
		return this.session.jack.crowned != null && this.session.jack.getHP() > 0; //Jack does not stop showing us his stabs.
	}

	//TODO get lowest mobility player and 2-3 of their friends. (random but based on mobility)
	//TODO jack never ever ever tries to hurt the witch. whatever the witch prototyped is her familiar and is loyal to her.
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


		this.renderPrestabs = function(div, stabbings){
			var repeatTime = 1000;
			var divID = (div.attr("id")) + "_final_boss";
			var ch = canvasHeight;

			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
			div.append(canvasHTML);
			//different format for canvas code
			var canvasDiv = document.getElementById("canvas"+ divID);
			poseAsATeam(canvasDiv, stabbings, 2000);
		}


	//TODO copy how queen fight works. get Stabs is maing thing that needs to change.
	//if nobody to stab, instead of boss fight, stabs.
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
			ret = "Jack has caught the " + getPlayersTitlesBasic(stabbings) + ".  Will he show them his stabs? Strife!";
			div.append("<br>"+ret);
			this.renderPrestabs(div, stabbings); //pose as a team BEFORE getting your ass handed to you.
			this.session.jack.strife(div, stabbings,0)
			return;//make sure text is over image

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
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
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
			if(alt && alt.alternateScene(div)){
				return;
			}else{
				ret += " Jack shows his stabs to " + getPlayersTitles(stabbings) + " until they die.  DEAD.";
				this.killPlayers(stabbings);
		}
		}
		return ret;
	}
}
