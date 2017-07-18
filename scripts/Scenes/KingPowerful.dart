part of SBURBSim;


class KingPowerful extends Scene {
	var session;
	bool canRepeat = false;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?

	


	KingPowerful(this.session) {}


	dynamic trigger(playerList){
		this.playerList = playerList;
		return this.session.king.getStat("power") > this.session.hardStrength;
	}
	void renderContent(div){
		div.append("<br>"+this.content());
	}
	dynamic content(){
		var nativePlayersInSession = findPlayersFromSessionWithId(this.playerList,this.session.session_id);
		var badPrototyping = findBadPrototyping(nativePlayersInSession);
		if(!badPrototyping){
			badPrototyping = "glitchy piece of shit that is SBURB itself";
		}
		String ret = " At this point, the various prototypings from " +this.playerList.length;
		ret += " players, especially the " + badPrototyping;
		ret += ", have made the enemies  far too powerful. ";

		if(this.playerList.length < this.session.players.length){
			ret += " Further prototypings will only serve to further strengthen the enemies. ";
		}
		return ret;
	}



}
