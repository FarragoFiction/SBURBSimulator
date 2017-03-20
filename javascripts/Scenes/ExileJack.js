function ExileJack(session){
	this.canRepeat = false;	
	this.session = session;
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return (this.session.jackStrength < 10) && (this.session.jackStrength >  -9999);
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	this.content = function(){
		this.session.jackStrength =  -9999;
		var ret = " The plan has been performed flawlessly.  Jack has been exiled to the post-Apocalyptic version of Earth before he can cause too much damage.";
		return ret;
	}
}