import "dart:html";
import "../SBURBSim.dart";


//only needs to happen once, but if it DOESN'T happen before reckoning (or leader is permanently killed) doomed timeline.
class DoEctobiology extends Scene {
	List<Player> playerList = [];  //what players are already in the medium when i trigger?
	Player leader = null;
	List<Player> playersMade = []; //keep track because not all players get made (multi session bullshit)

	


	DoEctobiology(Session session): super(session, false);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.leader = getLeader(this.session.getReadOnlyAvailablePlayers());  //dead men do no ectobiology
		if(this.leader != null && this.leader.dead == false && this.session.stats.ectoBiologyStarted == false){
			return (this.leader.getStat(Stats.POWER) > (rand.nextDouble()*200) && this.leader.canHelp()); //can't do it right out of the bat. might never do it
		}
		return false;
	}
	void drawLeaderPlusBabies(Element div){
		//alert("drawing babies");
		num repeatTime = 1000;
		String divID = (div.id) + "_babies";
		int ch = canvasHeight;
		if(this.session.players.length > 6){
			ch = (canvasHeight*1.5).round();
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$ch'>  </canvas>";
		appendHtml(div, canvasHTML);
		//different format for canvas code
		Element canvasDiv = querySelector("#canvas"+ divID);
		Drawing.poseBabiesAsATeam(canvasDiv, this.leader, this.playersMade, getGuardiansForPlayers(this.playersMade));
	}
	@override
	void renderContent(Element div){

		div.appendHtml("<br><img src = 'images/sceneIcons/ectobiology_icon.png'>"+this.content(),treeSanitizer: NodeTreeSanitizer.trusted);
		this.drawLeaderPlusBabies(div);
	}
	dynamic content(){
		////session.logger.info("doing ectobiology for session " + this.session.session_id);
		this.session.stats.ectoBiologyStarted = true;
		this.playersMade = findPlayersWithoutEctobiologicalSource(this.session.players);
		setEctobiologicalSource(this.playersMade, session.session_id);
		String ret = " Through a series of wacky, yet inevitable in hindsight, coincidences, the " + this.leader.htmlTitle();
		ret += " finds themselves in the veil of meteors surrounding the Medium. ";
		ret +=  " A button is pushed, and suddenly there are little tiny baby version of " + getPlayersTitlesBasic(this.playersMade);
		if(session.stats.scratched){
			ret += " Plus baby versions of all the players from the pre-scratch session?";
			ret += " No wonder that session went so poorly: It was always destined to be scratched or nobody would be born in the first place.";
		}else{
			ret += ". Plus a bunch of superfluous extra babies. ";
			ret += " What is even going on here? ";
		}
		this.leader.increasePower();
		this.leader.leveledTheHellUp = true;
		this.leader.level_index +=3;
		session.removeAvailablePlayer(leader);
		this.leader.flipOut(" how the Ultimate Goddamned Riddle means that if they didn't play this bullshit game in the first place they never would have been born at all");
		return ret;
	}

}
