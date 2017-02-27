function KingPowerful(){
	this.canRepeat = false;	
	this.playerList = [];  //what players are already in the medium when i trigger?
	
	this.trigger = function(playerList){
		this.playerList = playerList;
		return kingStrength > hardStrength;
	}
	
	this.renderContent = function(div){
		div.append(this.content());
	}
	
	this.content = function(){
		var badPrototyping = findBadPrototyping(this.playerList);
		var ret = " At this point, the various prototypings from " +this.playerList.length;
		ret += " players, especially the " + badPrototyping;
		ret += ", have made the enemies  far too powerful. ";
		
		if(this.playerList.length < players.length){
			ret += " Further prototypings will only serve to further strengthen the enemies. ";
		}
		return ret;
	}
	

}
