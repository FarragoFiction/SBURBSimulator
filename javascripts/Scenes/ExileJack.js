function ExileJack(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (jackStrength < 10) && (jackStrength >  -9999);
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	this.content = function(){
		jackStrength =  -9999;
		var ret = " The plan has been performed flawlessly.  Jack has been exiled to the post-Apocalyptic version of Earth before he can cause too much damage.";
		return ret;
	}
}