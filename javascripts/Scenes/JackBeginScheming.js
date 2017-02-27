function JackBeginScheming(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.friend = null;
	
	//blood or page or thief or rogue. 
	this.findSympatheticPlayer = function(){
		this.friend =  findAspectPlayer(availablePlayers, "Blood");
		if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Page");
		}else if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Thief");
		}else if(this.friend == null){
			this.friend =  findClassPlayer(availablePlayers, "Rogue");
		}
	}
	
	//a player has to be not busy to be your friend right now.
	this.trigger = function(playerList){
		this.playerList = playerList;
		if(jackStrength <= 0 || queenStrength <= 0){  //the dead can't scheme or be schemed against
			return false;
		}
		this.findSympatheticPlayer();
		
		return (jackStrength >= queenStrength) && (this.friend != null);
	}
	
	this.renderContent = function(div){
		div.append(this.content);
	}
	
	this.content = function(){
		if(this.friend){
		this.friend.increasePower();
			removeFromArray(this.friend, availablePlayers);
			available_scenes.unshift( new PrepareToExileQueen());  //make it top priority, so unshift, don't push
			available_scenes.unshift( new PlanToExileJack());  //make it top priority, so unshift, don't push
			available_scenes.unshift( new ExileQueen());  //make it top priority, so unshift, don't push
			var ret = " Archagent Jack Noir has not let the Queen's relative weakness go unnoticed. ";
			ret += " He meets with the " + this.friend.htmlTitle() + " at " + this.friend.shortLand() + " and begins scheming to exile her. ";
			ret += " You can tell he likes the " + this.friend.htmlTitle() + " because he only stabbed them, like, three times, tops. ";
			ret += " And at least ONE of those was on accident. ";
		return ret;
		}
	}
}