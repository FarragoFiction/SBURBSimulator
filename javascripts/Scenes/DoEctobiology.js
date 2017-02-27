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
		ret += ". Plus a bunch of superfluous extra babies. ";
		ret += " What is even going on here? ";
		this.leader.increasePower();
		this.leader.leveledTheHellUp = true;
		return ret;
	}
}