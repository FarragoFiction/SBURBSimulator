import "dart:html";
import "../SBURBSim.dart";


class PrepareToExileQueen extends Scene {

	var player = null;	


	PrepareToExileQueen(Session session): super(session);


	void findSufficientPlayer(){
		//old way tended to have only one player do the thing each session. make it a team effort now.
		var potentials = [findAspectPlayer(this.session.availablePlayers, Aspects.VOID)];
		potentials.add(findAspectPlayer(this.session.availablePlayers, Aspects.MIND));
		potentials.add(findAspectPlayer(this.session.availablePlayers, Aspects.HOPE));
		potentials.add(findClassPlayer(this.session.availablePlayers, SBURBClassManager.THIEF));
		potentials.add(findClassPlayer(this.session.availablePlayers, SBURBClassManager.ROGUE));
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
		return (this.player != null) && (this.session.queen.getStat("currentHP") > 0 && !this.session.queen.exiled);
	}
	dynamic moderateDamage(){
	//	print(this.session.scratched +  this.player + " moderate damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.queen.addStat("power", -10);
		return ret + rand.pickFrom(moderateQueenQuests);
	}
	dynamic heavyDamage(){
		//print(this.session.scratched +  this.player +   " heavy damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.queen..addStat("power", -15);
		return ret + rand.pickFrom(heavyQueenQuests);
	}
	dynamic lightDamage(){
		//print(this.session.scratched +  this.player +  " light damage to queen's power in: " + this.session.session_id);
		String ret = "The " + this.player.htmlTitle() + " ";
		this.session.queen..addStat("power", -5);; //ATTENTION FUTURE JR:  you will look at this and wonder why we didn't make it proportional to the queens power. after all,  a five decrease is HUGE to an uncrowned queen and nothing to a First Guardian Queen.   Consider Xeno's paradox, however. If we do it that way, the closer we get to exiling the queen, the less power we'll take from her. She'll never reach zero. DO NOT FUCKING DO THIS.
		//also, maybe it SHOULD be fucking nothing to a first guardian queen. why the fuck does she care about whatever bullshit you doing. she's a GOD.
		return ret + rand.pickFrom(lightQueenQuests);
	}
	dynamic content(){

		removeFromArray(this.player, this.session.availablePlayers);
		//NOT RANDOM ANY MORE. INSTEAD BASED ON PLAYER POWER VS QUEEN POWER
		//generally will start with light and owrk your way up.
		if(this.player.getStat("power")  < this.session.queen.getStat("power")* .25){ //queen is 100 and you are less than 25
			return this.lightDamage();
		}else if(this.player.getStat("power") < this.session.queen.getStat("power")){ //queen is 100 and you are at least 50
			return this.moderateDamage();
		}else if(this.player.getStat("power") > this.session.queen.getStat("power")){
			return this.heavyDamage();
		}
		this.player.increasePower();
	}

}
