import "dart:html";
import "../../SBURBSim.dart";

//JR makes this on 5/30/18
class StrifeBigBad extends Scene {
	GameEntity bigBad;

	StrifeBigBad(Session session): super(session);

	@override
	bool trigger(playerList){
		bigBad = null;
		List<GameEntity> possibleTargets = new List<GameEntity>.from(session.activatedNPCS);
		possibleTargets.addAll(session.players);
		//get rid of targets that aren't big bads or targets who are dead
		possibleTargets.removeWhere((GameEntity item) => !item.bigBad || item.dead);
		bigBad = session.rand.pickFrom(possibleTargets);
		return bigBad != null;
	}


	List<GameEntity> getGoodGuys(){
		List<GameEntity> living = findLiving(this.session.players);
		List<GameEntity> allPlayers = this.session.players; //anybody can have doomedclones now, not just time players.

		for(num i = 0; i<allPlayers.length; i++){
			living.addAll(allPlayers[i].doomedTimeClones);
			for(GameEntity g in allPlayers[i].companionsCopy) {
				if(g is Player && !g.dead) living.add(g);
			}

		}
		//for the love of all that is sane, don't join the team meant to defeat you. please.
		living.remove(bigBad);
		return living;
	}
	void renderGoodguys(Element div){
		List<Player> fightingPlayers = this.getGoodGuys();
		int ch = canvasHeight;
		if(fightingPlayers.length > 6){
			ch = (canvasHeight*1.5).round(); //a little bigger than two rows, cause time clones
		}
		CanvasElement canvasDiv = new CanvasElement(width: canvasWidth, height: ch);
		div.append(canvasDiv);
		Drawing.poseAsATeam(canvasDiv, fightingPlayers);
	}

	@override
	void renderContent(Element div){
		if(canFight()) {
			doFight(div);
		}else {
			failFight(div);
		}

	}

	void failFight(Element div) {
		DivElement container = new DivElement();
		div.append(container);
		String flavor = "";
		if(bigBad is BigBad) flavor = (bigBad as BigBad).textIfNoStrife;
		div.setInnerHtml("The ${gameEntity.htmlTitle()} has had enough of the tyranny of the ${bigBad.htmlTitle()}.  $flavor");


	}

	void doFight(Element div) {
		bigBad.heal();
		DivElement container = new DivElement();
		div.append(container);
		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		List<GameEntity> fighting = this.getGoodGuys();
		String flavor = "";
		if(bigBad is BigBad) flavor = (bigBad as BigBad).textIfYesStrife;
		div.setInnerHtml("The ${gameEntity.htmlTitle()} has had enough of the tyranny of the ${bigBad.htmlTitle()}.  $flavor");

		Team pTeam = new Team.withName("The Players",this.session, fighting);
		pTeam.canAbscond = true;
		Team dTeam = new Team(this.session, [bigBad]);
		dTeam.canAbscond = true;
		Strife strife = new Strife(this.session, [pTeam, dTeam]);
		strife.startTurn(div);
	}

	bool canFight() {
		return bigBad.canStrife;
	}

	void describeFight() {

	}

	void minorLevelPlayers(List<GameEntity> stabbings){
		for(num i = 0; i<stabbings.length; i++){
			stabbings[i].increasePower();
		}
	}
	void setPlayersUnavailable(List<GameEntity> stabbings){
		for(num i = 0; i<stabbings.length; i++){
			session.removeAvailablePlayer(stabbings[i]);
		}
	}


}
