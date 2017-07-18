
part of SBURBSim;
class FightKing extends Scene {
	bool canRepeat = true;
	List<dynamic> playerList = [];  //what players are already in the medium when i trigger?

	


	FightKing(Session session): super(session);

	@override
	dynamic trigger(List<Player> playerList){
		this.playerList = playerList;
		//print('fight kin trigger?');
		return (this.session.king.getStat("currentHP") > 0) && !this.session.king.dead && (this.session.queen.getStat("currentHP") <= 0 || this.session.queen.dead) && (findLivingPlayers(this.session.players).length != 0) ;
	}
	dynamic getGoodGuys(){
	var living = findLivingPlayers(this.session.players);
	var allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

	for(num i = 0; i<allPlayers.length; i++){
		living = living.concat(allPlayers[i].doomedTimeClones);
	}
	return living;
}
	void renderGoodguys(div){
		num repeatTime = 1000;
		var divID = (div.attr("id")) + "_final_boss";
		var ch = canvasHeight;
		var fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}
		String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+ch + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);
		poseAsATeam(canvasDiv, fightingPlayers, 2000);
	}

	@override
	void renderContent(div){
		//print("rendering fight king);")
		div.append("<br> <img src = 'images/sceneIcons/bk_icon.png'>");
		div.append(this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		var fighting = this.getGoodGuys();
		if(this.session.democraticArmy.getStat("currentHP") > 0) fighting.push(this.session.democraticArmy);
		this.session.king.strife(div, fighting,0);

	}
	void setPlayersUnavailable(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}
	dynamic content(){
		var nativePlayersInSession = findPlayersFromSessionWithId(this.playerList);
		var badPrototyping = findBadPrototyping(nativePlayersInSession);

		String ret = " It is time for the final opponent, the Black King. ";
		if(badPrototyping){
			ret += " He is made especially terrifying with the addition of the " + badPrototyping + ". ";
		}


		return ret;

	}

}
