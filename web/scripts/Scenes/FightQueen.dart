import "dart:html";
import "../SBURBSim.dart";


class FightQueen extends Scene {


	


	FightQueen(Session session): super(session);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return (this.session.queen.getStat("currentHP") > 0) &&  !this.session.queen.dead&&(findLivingPlayers(this.session.players).length != 0) ;
	}
	dynamic getGoodGuys(){
		var living = findLivingPlayers(this.session.players);
		var allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

		for(num i = 0; i<allPlayers.length; i++){
			living.addAll(allPlayers[i].doomedTimeClones);
		}
		return living;
	}
	void renderGoodguys(Element div){
		num repeatTime = 1000;
		String divID = (div.id) + "_final_boss";
		num ch = canvasHeight;
		List<Player> fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+ch.toString() + "'>  </canvas>";
		appendHtml(div,canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);
		poseAsATeam(canvasDiv, fightingPlayers);
	}
	@override
	void renderContent(Element div){
		if(this.session.queen.getStat("power") < 0) print("rendering fight queen with negative power " +this.session.session_id.toString());
		appendHtml(div,"<br> <img src = 'images/sceneIcons/bq_icon.png'> ");
    appendHtml(div,this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		var fighting = this.getGoodGuys();
		if(this.session.democraticArmy.getStat("currentHP") > 0) fighting.add(this.session.democraticArmy);
		Team pTeam = new Team.withName("The Players",this.session, fighting);
    pTeam.canAbscond = false;
		Team dTeam = new Team(this.session, [this.session.queen]);
    dTeam.canAbscond = false;
		Strife strife = new Strife(this.session, [pTeam, dTeam]);
		strife.startTurn(div);

	}
	void minorLevelPlayers(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
		}
	}
	void setPlayersUnavailable(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}

	dynamic content(){
		//print("Queen Strength : " + this.session.queenStrength);
		String badPrototyping = findBadPrototyping(this.playerList);
		var living = findLivingPlayers(this.session.players);
		String ret = " Before the players can reach the Black King, they are intercepted by the Black Queen. ";
		if(badPrototyping != null && this.session.queen.crowned != null){
			ret += " She is made especially ferocious with the addition of the " + badPrototyping + ". ";
		}else if(this.session.queen.crowned != null){
			ret += "She may no longer have her RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD, but she is dedicated to her duty and will fight the Players to the bitter end.";
		}

		this.setPlayersUnavailable(living);

		return ret;

	}

}
