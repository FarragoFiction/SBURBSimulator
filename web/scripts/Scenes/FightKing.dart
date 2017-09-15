import "dart:html";
import "../SBURBSim.dart";
import '../../scripts/includes/logger.dart';

class FightKing extends Scene {


	


	FightKing(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		////session.logger.info('fight kin trigger?');
		return (this.session.npcHandler.king.getStat(Stats.CURRENT_HEALTH) > 0) && !this.session.npcHandler.king.dead && (this.session.npcHandler.queen.getStat(Stats.CURRENT_HEALTH) <= 0 || this.session.npcHandler.queen.dead) && (findLivingPlayers(this.session.players).length != 0) ;
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
		String divID = (div.id) + "_final_boss";
		num ch = canvasHeight;
		var fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height="+ch.toString() + "'>  </canvas>";
		appendHtml(div,canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);
		Drawing.poseAsATeam(canvasDiv, fightingPlayers);
	}

	@override
	void renderContent(Element div){
		////session.logger.info("rendering fight king);")
		appendHtml(div, "<br> <img src = 'images/sceneIcons/bk_icon.png'>");
    appendHtml(div,this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		var fighting = this.getGoodGuys();
		if(this.session.npcHandler.democraticArmy.getStat(Stats.CURRENT_HEALTH) > 0) fighting.add(this.session.npcHandler.democraticArmy);
		Team pTeam = new Team.withName("The Players", this.session, fighting);
		pTeam.canAbscond = false;
		Team dTeam = new Team(this.session, [this.session.npcHandler.king]);
         dTeam.canAbscond = false;
		Strife strife = new Strife(this.session, [pTeam, dTeam]);
		strife.timeTillRocks = 10;
		strife.startTurn(div);

	}
	void setPlayersUnavailable(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			session.removeAvailablePlayer(stabbings[i]);
		}
	}
	dynamic content(){
		List<Player> nativePlayersInSession = findPlayersFromSessionWithId(this.playerList,this.session.session_id);
		String badPrototyping = findBadPrototyping(nativePlayersInSession);

		String ret = " It is time for the final opponent, the Black King. ";
		if(badPrototyping != null){
			ret += " He is made especially terrifying with the addition of the " + badPrototyping + ". ";
		}


		return ret;

	}

}
