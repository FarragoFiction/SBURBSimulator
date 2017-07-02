function KingPowerful(session){
	this.session=session;
	this.canRepeat = false;
	this.playerList = [];  //what players are already in the medium when i trigger?

	this.trigger = function(playerList){
		this.playerList = playerList;
		return this.session.king.getStat("power") > this.session.hardStrength;
	}

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.content = function(){
		var nativePlayersInSession = findPlayersFromSessionWithId(this.playerList,this.session.session_id);
		var badPrototyping = findBadPrototyping(nativePlayersInSession);
		if(!badPrototyping){
			badPrototyping = "glitchy piece of shit that is SBURB itself"
		}
		var ret = " At this point, the various prototypings from " +this.playerList.length;
		ret += " players, especially the " + badPrototyping;
		ret += ", have made the enemies  far too powerful. "

		if(this.playerList.length < this.session.players.length){
			ret += " Further prototypings will only serve to further strengthen the enemies. ";
		}
		return ret;
	}


}
