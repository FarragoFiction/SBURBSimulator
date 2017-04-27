function LifeStuff(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.combo = 0;

	//life players of sufficient power and of the right class can revive themselves or others. 
	//if life player is of right class, they or others can commune with the dead for power/knowledge.
	//life player is or right class, players with no dream self will do this instead of their moon quests. (visit dream bubbles, see ghosts.)
	this.trigger = function(playerList){
		return false;

	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.makeAlive = function(d){
		//foundRareSession(div, "A player was corpse smooched alive.")
		if(d.stateBackup) d.stateBackup.restoreState(d);
		d.influencePlayer = null;
		d.influenceSymbol = null;
		d.dead = false;
		d.murderMode = false;
		d.grimDark = false;
		d.triggerLevel = 1;
		d.leftMurderMode = false; //no scars
		d.victimBlood = null; //clean face
	}

	this.makeDead = function(d){
		//console.log("make dead " + d.title())
		d.dead = true;
	}




	this.content = function(){
		var ret = "TODO: LIfe revive.";
		
		return ret;

	}

}
