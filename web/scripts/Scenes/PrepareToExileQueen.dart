import "dart:html";
import "../SBURBSim.dart";


class PrepareToExileQueen extends Scene {

	var player = null;	


	PrepareToExileQueen(Session session): super(session);


	void findSufficientPlayer(){
		List<Player> availablePlayers = session.getReadOnlyAvailablePlayers();
		//old way tended to have only one player do the thing each session. make it a team effort now.
		var potentials = [findAspectPlayer(availablePlayers, Aspects.VOID)];
		potentials.add(findAspectPlayer(availablePlayers, Aspects.MIND));
		potentials.add(findAspectPlayer(availablePlayers, Aspects.HOPE));
		potentials.add(findClassPlayer(availablePlayers, SBURBClassManager.THIEF));
		potentials.add(findClassPlayer(availablePlayers, SBURBClassManager.ROGUE));
		this.player =  rand.pickFrom(potentials);
	}

	@override
	void renderContent(Element div){
		appendHtml(div,"<br> <img src = 'images/sceneIcons/shenanigans_icon.png'>"+this.content());
	}

	@override
	bool trigger(playerList){
		this.player = null;
		this.playerList = playerList;
		this.findSufficientPlayer();
		return (this.player != null) && (this.session.npcHandler.queen.getStat(Stats.CURRENT_HEALTH) > 0 && !this.session.npcHandler.queen.exiled);
	}
	dynamic moderateDamage(){
	//	//session.logger.info(this.session.scratched +  this.player + " moderate damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.npcHandler.queen.addStat(Stats.POWER, -10);
		return ret + rand.pickFrom(moderateQueenQuests);
	}
	dynamic heavyDamage(){
		////session.logger.info(this.session.scratched +  this.player +   " heavy damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.npcHandler.queen..addStat(Stats.POWER, -15);
		return ret + rand.pickFrom(heavyQueenQuests);
	}
	dynamic lightDamage(){
		////session.logger.info(this.session.scratched +  this.player +  " light damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.npcHandler.queen.addStat(Stats.POWER, -5); //ATTENTION FUTURE JR:  you will look at this and wonder why we didn't make it proportional to the queens power. after all,  a five decrease is HUGE to an uncrowned queen and nothing to a First Guardian Queen.   Consider Xeno's paradox, however. If we do it that way, the closer we get to exiling the queen, the less power we'll take from her. She'll never reach zero. DO NOT FUCKING DO THIS.
		//also, maybe it SHOULD be fucking nothing to a first guardian queen. why the fuck does she care about whatever bullshit you doing. she's a GOD.
		return ret + rand.pickFrom(lightQueenQuests);
	}
	String content(){
		session.removeAvailablePlayer(player);
		//NOT RANDOM ANY MORE. INSTEAD BASED ON PLAYER POWER VS QUEEN POWER
		//generally will start with light and owrk your way up.
		this.player.increasePower();
		if(this.player.getStat(Stats.POWER)  < this.session.npcHandler.queen.getStat(Stats.POWER)* .25){ //queen is 100 and you are less than 25
			return this.lightDamage();
		}else if(this.player.getStat(Stats.POWER) <= this.session.npcHandler.queen.getStat(Stats.POWER)){ //queen is 100 and you are at least 50
			return this.moderateDamage();
		}else if(this.player.getStat(Stats.POWER) > this.session.npcHandler.queen.getStat(Stats.POWER)){
			return this.heavyDamage();
		}else {
			 //session.logger.info("AB:  a nonsensical amount of damage is being done to the queen in session ${session.session_id}");
			return this.lightDamage();
		}

	}

}
