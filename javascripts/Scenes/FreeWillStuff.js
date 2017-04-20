function FreeWillStuff(session){
	this.session = session;
	this.canRepeat = true;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.wills = [];
	//luck can be good or it can be bad.
	this.minHighValue = 110;

	this.trigger = function(playerList){
		this.rolls = [];//reset
		//what the hell roue of doom's corpse. corpses aren't part of the player list!
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			var player = this.session.availablePlayers[i];
			var willValue = player.willPower;
			if(willValue >= this.minHighValue){
				this.wills.push(new WillPower(player, willValue));
			}
		}
		return this.wills.length > 0
	}
	
	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}
	
	
	
	this.processWill = function(){
		
	}
	
	this.content = function(){
		var ret = "Luck Event: ";
		removeFromArray(this.player, this.session.availablePlayers);
		for(var i = 0; i<this.wills.length; i++){
			var will = this.wills[i];
			removeFromArray(will.player, this.session.availablePlayers);
			ret += this.processWill(will);
		}
		
		return ret;
	}
}

function WillPower(player, value){
	this.player = player;
	this.value = value;
}