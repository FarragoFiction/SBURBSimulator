//only needs to happen once, but if it DOESN'T happen before reckoning (or leader is permanently killed) doomed timeline.
function DoEctobiology(){
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.leader = null;

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.leader = getLeader(availablePlayers);  //dead men do no ectobiology
		if(this.leader){
			return this.leader.power > (Math.random()*100); //can't do it right out of the bat. might never do it
		}
		return false;
	}

	this.renderContent = function(div){
		div.append(this.content());
	}

	this.content = function(){
		ectoBiologyStarted = true;
		var ret = " Through a series of wacky, yet inevitable in hindsight, coincidences, the " + this.leader.htmlTitle();
		ret += " finds themselves in the veil of meteors surrounding the Medium. ";
		ret +=  " A button is pushed, and suddenly there are little tiny baby version of " + getPlayersTitlesBasic(players);
		if(scratched){
			ret += " Plus baby versions of all the players from the pre-scratch session?"
			ret += "No wonder that session went so poorly: It was always destined to be scatched or nobody would be born in the first place."
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
