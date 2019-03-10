import "dart:html";
import "../../SBURBSim.dart";
import '../../../scripts/includes/logger.dart';

class FightKing extends Scene {


	


	FightKing(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		////session.logger.info('fight kin trigger?');
		if(!session.reckoningStarted) return false;

		bool queenDefeated = false;
		if(this.session.derse == null) {
			queenDefeated = true;
		}else if(this.session.derse.queen.dead || this.session.derse.queen.getStat(Stats.CURRENT_HEALTH) <= 0)  {
			queenDefeated = true;
		}



		return (this.session.battlefield.blackKing.getStat(Stats.CURRENT_HEALTH) > 0) && !this.session.battlefield.blackKing.dead && queenDefeated && (findLiving(this.session.players).length != 0) ;
	}
	List<GameEntity> getGoodGuys(){
	List<GameEntity> living = findLiving<GameEntity>(this.session.players);
	List<Player> allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

	for(num i = 0; i<allPlayers.length; i++){
		living.addAll(allPlayers[i].doomedTimeClones);
		for(GameEntity g in allPlayers[i].companionsCopy) {
			if(g is Player && !g.dead) living.add(g);
		}
	}
	return living;
}
	void renderGoodguys(Element div){
		String divID = (div.id) + "_final_boss";
		num ch = canvasHeight;
		List<GameEntity> fightingPlayers = this.getGoodGuys();
		if(fightingPlayers.length > 6){
			ch = canvasHeight*1.5; //a little bigger than two rows, cause time clones
		}

		CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: canvasHeight);
		div.append(canvasDiv);
		Drawing.poseAsATeam(canvasDiv, fightingPlayers);
	}

	@override
	void renderContent(Element div){
		////session.logger.info("rendering fight king);")
		//session.battlefield.blackKing.stats.copyFrom(findStrongestPlayer(session.players).stats);
		session.battlefield.blackKing.setStat(Stats.CURRENT_HEALTH, session.battlefield.blackKing.getStat(Stats.HEALTH));

		appendHtml(div, "<br> <img src = 'images/sceneIcons/bk_icon.png'>");
		appendHtml(div,this.content());

		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		List<GameEntity> fighting = this.getGoodGuys();
		Team pTeam = new Team.withName("The Players", this.session, fighting);
		pTeam.canAbscond = false;
		Team dTeam = new Team(this.session, [this.session.battlefield.blackKing]);
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
