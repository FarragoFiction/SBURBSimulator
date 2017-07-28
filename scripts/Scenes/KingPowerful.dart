part of SBURBSim;


class KingPowerful extends Scene {
	KingPowerful(Session session): super(session, false);


  @override
	bool trigger(List<Player> playerList){
	  this.playerList = playerList;
		return this.session.king.getStat("power") > this.session.hardStrength;
	}



	@override
	void renderContent(Element div){
		appendHtml(div,"<br>"+this.content());
	}

	String content(){
		var nativePlayersInSession = findPlayersFromSessionWithId(this.playerList,this.session.session_id);
		var badPrototyping = findBadPrototyping(nativePlayersInSession);
		if(badPrototyping == null){
			badPrototyping = "glitchy piece of shit that is SBURB itself";
		}
		String ret = " At this point, the various prototypings from " +this.playerList.length.toString();
		ret += " players, especially the " + badPrototyping;
		ret += ", have made the enemies  far too powerful. ";


		if(this.playerList.length < this.session.players.length){
			ret += " Further prototypings will only serve to further strengthen the enemies. ";
		}
		return ret;
	}



}
