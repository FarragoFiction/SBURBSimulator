//only needs to happen once, but if it DOESN'T happen before reckoning (or leader is permanently killed) doomed timeline.
function DoEctobiology(session){
	this.session = session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.leader = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.leader = getLeader(this.session.availablePlayers);  //dead men do no ectobiology
		if(this.leader){
			return this.leader.power > (Math.seededRandom()*100); //can't do it right out of the bat. might never do it
		}
		return false;
	}

  //could be up to 24 babies to draw (so many babies)
	this.drawLeaderPlusBabies = function(div){
		//alert("drawing babies")
		var repeatTime = 1000;
		var divID = (div.attr("id")) + "_babies";
		var ch = canvasHeight;
		if(players.length > 6){
			ch = canvasHeight*1.5;
		}
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		poseBabiesAsATeam(canvasDiv, this.leader, players, guardians, 4000);
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
		this.drawLeaderPlusBabies(div);
	}

	this.content = function(){
		ectoBiologyStarted = true;
		var ret = " Through a series of wacky, yet inevitable in hindsight, coincidences, the " + this.leader.htmlTitle();
		ret += " finds themselves in the veil of meteors surrounding the Medium. ";
		ret +=  " A button is pushed, and suddenly there are little tiny baby version of " + getPlayersTitlesBasic(players);
		if(scratched){
			ret += " Plus baby versions of all the players from the pre-scratch session?"
			ret += " No wonder that session went so poorly: It was always destined to be scatched or nobody would be born in the first place."
		}else{
			ret += ". Plus a bunch of superfluous extra babies. ";
			ret += " What is even going on here? ";
		}
		this.leader.increasePower();
		this.leader.leveledTheHellUp = true;
		this.leader.level_index +=3;
		return ret;
	}
}
