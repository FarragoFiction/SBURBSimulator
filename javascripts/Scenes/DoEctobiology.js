//only needs to happen once, but if it DOESN'T happen before reckoning (or leader is permanently killed) doomed timeline.
function DoEctobiology(session){
	this.session = session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.leader = null;
	this.playersMade = []; //keep track because not all players get made (multi session bullshit)

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.leader = getLeader(this.session.availablePlayers);  //dead men do no ectobiology
		if(this.leader && this.leader.dead == false && this.session.ectoBiologyStarted == false){
			return this.leader.power > (Math.seededRandom()*200); //can't do it right out of the bat. might never do it
		}
		return false;
	}

  //could be up to 24 babies to draw (so many babies)
	this.drawLeaderPlusBabies = function(div){
		//alert("drawing babies")
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_babies";
		var ch = canvasHeight;
		if(this.session.players.length > 6){
			ch = canvasHeight*1.5;
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		poseBabiesAsATeam(canvasDiv, this.leader, this.playersMade, getGuardiansForPlayers(this.playersMade), 4000);
	}

	this.renderContent = function(div){
		div.append("<br><img src = 'images/sceneIcons/ectobiology_icon.png'>"+this.content());
		this.drawLeaderPlusBabies(div);
	}

	this.content = function(){
		//console.log("doing ectobiology for session " + this.session.session_id)
		this.session.ectoBiologyStarted = true;
		this.playersMade = findPlayersWithoutEctobiologicalSource(this.session.players);
		setEctobiologicalSource(this.playersMade, session.session_id)
		var ret = " Through a series of wacky, yet inevitable in hindsight, coincidences, the " + this.leader.htmlTitle();
		ret += " finds themselves in the veil of meteors surrounding the Medium. ";
		ret +=  " A button is pushed, and suddenly there are little tiny baby version of " + getPlayersTitlesBasic(this.playersMade);
		if(session.scratched){
			ret += " Plus baby versions of all the players from the pre-scratch session?"
			ret += " No wonder that session went so poorly: It was always destined to be scratched or nobody would be born in the first place."
		}else{
			ret += ". Plus a bunch of superfluous extra babies. ";
			ret += " What is even going on here? ";
		}
		this.leader.increasePower();
		this.leader.leveledTheHellUp = true;
		this.leader.level_index +=3;
		this.leader.flipOut(" how the Ultimate Goddamned Riddle means that if they didn't play this bullshit game in the first place they never would have been born at all")
		return ret;
	}
}
