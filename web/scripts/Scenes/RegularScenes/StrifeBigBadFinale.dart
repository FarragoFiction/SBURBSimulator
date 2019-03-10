import "dart:html";
import "../../SBURBSim.dart";

//the final fight against every big bad at once in a big stupid pile
class StrifeBigBadFinale extends Scene {
	//you get one shot, one opportunity (even if you're alive after, the big bads just follow you in)
	bool happenedOnce = false;
	List<BigBad> bigBads = new List<BigBad>();

	StrifeBigBadFinale(Session session): super(session);

	@override
	bool trigger(playerList){
		bigBads.clear();

		List<GameEntity> possibleTargets = new List<GameEntity>.from(session.activatedNPCS);
		//if you are not a big bad, dead or inactive, remove.
		possibleTargets.removeWhere((GameEntity item) => !(item is BigBad) || item.dead || !item.active);
		//if you aren't fightable, what are you even doing here?
		possibleTargets.removeWhere((GameEntity item) => !item.canStrife);

		bigBads = new List<BigBad>.from(possibleTargets);

		return bigBads.isNotEmpty && !happenedOnce;
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
		return living;
	}
	void renderGoodguys(Element div){
		List<GameEntity> fightingPlayers = this.getGoodGuys();
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
		happenedOnce = true; //now or never
		doFight(div);
	}

	List<Team> setupBigBadTeams(Team pTeam) {
		List<Team> teams = new List<Team>();
		for(BigBad bb in bigBads) {
			Team dTeam = new Team(this.session, [bb]);
			teams.add(dTeam);
			dTeam.canAbscond = false;
			pTeam.members.removeWhere((GameEntity g) => dTeam.members.contains(g));
		}
		return teams;

	}


	void doFight(Element div) {
		DivElement container = new DivElement();
		div.append(container);
		this.renderGoodguys(div); //pose as a team BEFORE getting your ass handed to you.
		List<GameEntity> fighting = this.getGoodGuys();
		String flavor = "It is time for a fuck off big giant boss fight.";
		if(bigBads.length > 2) flavor = "$flavor It's actually really confusing to keep track of who is on who's side.";

		div.setInnerHtml("The Players realize that before they can deploy the frog, they need to at least TRY to get rid of the all these motherfucking big bads in this motherfucking session.  $flavor");

		Team pTeam = new Team.withName("The Players",this.session, fighting);
		pTeam.canAbscond = false;

		List<Team> teams = setupBigBadTeams(pTeam);
		teams.insert(0, pTeam);
		Strife strife = new Strife(this.session, teams);
		strife.startTurn(div);
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
