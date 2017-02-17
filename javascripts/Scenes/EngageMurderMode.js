function EngageMurderMode(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		this.player = getRandomElementFromArray(availablePlayers);
		if(this.player){
			if(this.player.triggerLevel > 0 &&  !this.player.murderMode && this.player.getEnemies().length > 0){
				if((Math.random() * 10) < this.player.triggerLevel){
					return true;
				}
			}
		}
		return false;
	}
	
	this.content = function(){
		//console.log("murder mode");
		this.player.increasePower();
		removeFromArray(this.player, availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " has taken an acrobatic fucking pirouette off the handle and into a giant pile of crazy.  ";
		ret += " They engage Murder Mode while thinking of their enemies " + getPlayersTitles(this.player.getEnemies()) + ". ";
		ret += " This is completely terrifying. ";
		this.player.murderMode = true;
		return ret;
	}
}