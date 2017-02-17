function DisengageMurderMode(){
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.player = null;
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		//select a random player. if they've been triggered, random chance of going murderMode if enemies (based on how triggered.)
		this.player = getRandomElementFromArray(availablePlayers);
		if(this.player){
			if(this.player.triggerLevel < 1 &&  this.player.murderMode){
				return true;
			}
		}
		return false;
	}
	
	this.content = function(){
		this.player.increasePower();
		removeFromArray(this.player, availablePlayers);
		var ret = "The " + this.player.htmlTitle() + " has finally calmed their ass down enough to leave Murder Mode.  ";
		ret += " This is whatever the opposite of completely terrifying is. ";
		this.player.murderMode = false;
		return ret;
	}
}