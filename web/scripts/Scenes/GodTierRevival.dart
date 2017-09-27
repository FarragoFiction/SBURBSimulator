import "dart:html";
import "../SBURBSim.dart";


class GodTierRevival extends Scene {

	List<dynamic> godsToRevive = [];	


	GodTierRevival(Session session): super(session);

	@override
	bool trigger(List<Player> playerList){
		this.playerList = playerList;
		this.godsToRevive = <Player>[];
		//all dead players who aren't god tier and are destined to be god tier god tier now.
		List<Player> deadPlayers = findDeadPlayers(playerList);
		for(num i = 0; i<deadPlayers.length; i++){
			var p = deadPlayers[i];
			//only get one shot at this.
			if(p.godTier && p.canGodTierRevive){
				this.godsToRevive.add(p);
			}
		}
		return !this.godsToRevive.isEmpty;

	}
	@override
	void renderContent(Element div){
		appendHtml(div,"<br>"+this.content());
		var divID = (div.id) + "_tiger";
		var ch = canvasHeight;
		if(this.godsToRevive.length > 6){
			ch = canvasHeight*2;
		}
		String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height='$ch'>  </canvas>";
    appendHtml(div,canvasHTML);
		//different format for canvas code
		var canvasDiv = querySelector("#canvas"+ divID);
		List<dynamic> live_players = [];
		List<dynamic> dead_players = [];
		for(num i = 0; i<this.godsToRevive.length; i++){
			var p = this.godsToRevive[i];
			if(p.dead == false){
				live_players.add(this.godsToRevive[i]);
			}else{
				dead_players.add(this.godsToRevive[i]);
			}
		}

		Drawing.drawGodRevival(canvasDiv, live_players, dead_players);
	}
	dynamic addImportantEvent(player){
			return null;
	}
	dynamic content(){
		String ret = " <img src = 'images/sceneIcons/judgement_icon.png'>The game abstraction of the Judgement Clock is ruling on the death of the " + getPlayersTitles(this.godsToRevive ) + ". ";
		num breakNeeded = 200;
		for(num i = 0; i< this.godsToRevive.length; i++){
			Player p = this.godsToRevive[i];
			ret += " The " + p.htmlTitle() + "'s death is judged to be ";

			if(p.unconditionallyImmortal) {
				session.logger.info("AB: Found an unconditionally immortal ass hat.");
				ret += "... Lol, what clock?  ${p.htmlTitle()} is fucking unconditionally immortal. ";
				p.canGodTierRevive = true;
				p.increasePower();
				p.makeAlive();
			}else {
				double roll = p.rollForLuck();
				if (p.justDeath()) {
					if (roll > breakNeeded) {
						////session.logger.info(roll + " lucky break for god tier revival in: " + this.session.session_id );
						ret += " ... a LUCKY BREAK!!!!!!!! The Judgement Clock narrowly avoids ruling a JUST death. ";
						p.canGodTierRevive = true;
						p.increasePower();
						p.makeAlive();
					} else {
						////session.logger.info(roll + " just death for god tier in: " + this.session.session_id );
						ret += " JUST.  They do not revive. ";
						this.session.stats.justDeath = true;
						p.canGodTierRevive = false;
						if (p.didDenizenKillYou()) {
							p.causeOfDeath += " (it was a JUST judgement because they were corrupt)";
						} else {
							p.causeOfDeath += " (it was a JUST judgement)";
						}

						this.session.afterLife.addGhost(Player.makeRenderingSnapshot(p));
					}
				} else if (p.heroicDeath()) {
					if (roll > breakNeeded) {
						////session.logger.info(roll + " lucky break for god tier revival in: " + this.session.session_id );
						ret += " ... a LUCKY BREAK!!!!!!!! The Judgement Clock narrowly avoids ruling a HEROIC death. ";
						p.canGodTierRevive = true;
						p.increasePower();
						p.makeAlive();
					} else {
						this.session.stats.heroicDeath = true;
						////session.logger.info(roll + " heroic death for god tier in: " + this.session.session_id );
						ret += " HEROIC. They do not revive. ";
						p.canGodTierRevive = false;
						p.causeOfDeath += " (it was HEROIC judgement)";
						this.session.afterLife.addGhost(Player.makeRenderingSnapshot(p));
					}
				} else {
					if (roll < -1 * breakNeeded) {
						////session.logger.info("unlucky break for god tier revival in: " + this.session.session_id);
						ret += " ... Huh. Should the clock be DOING that? It's on both HEROIC and JUST at the same time, somehow? Not neither of them. Talk about a BAD BREAK. They do not revive.  ";
						p.canGodTierRevive = false;
						p.causeOfDeath += " (it was an unlucky judgement) ";
						this.session.afterLife.addGhost(Player.makeRenderingSnapshot(p));
					} else {
						////session.logger.info("god tier revival in: " + this.session.session_id);
						ret += " neither HEROIC nor JUST.  They revive in a rainbow glow, stronger than ever. ";
						p.canGodTierRevive = true;
						p.increasePower();
						p.makeAlive();
						if (p.aspect == Aspects.DOOM) { //powered by their own doom.
							//session.logger.info("doom is powered by their own death: " + this.session.session_id.toString()); //omg, they are sayians.
							p.addStat(Stats.POWER, 500);
							p.setStat(Stats.MIN_LUCK, 500); //prophecy fulfilled. you are no longer doomed. (will probably get drained again quickly, tho).  Do...do doom players EVER revive?????
							ret += " They prophesied this death. Now that their Doom is over, they can finally get on with their life. ";
							//session.logger.info("godtier doom player using their own death as a source of power. so proud of this. "  + this.session.session_id.toString());
						}
					}
				}
			}

		}
		return ret;
	}

}
