function ExileJack(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (jackStrength < 10) && (jackStrength > 0);
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.content = function(){
		jackStrength = 0;
		var ret = " The plan has been performed flawlessly.  Jack has been exiled to the post-Apocalyptic version of Earth before he can cause too much damage.";
		return ret;
	}
}