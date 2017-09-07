import "dart:html";
import "../SBURBSim.dart";


class prepareToExileJack extends Scene {

	var player = null;	


	prepareToExileJack(Session session): super(session);



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
		appendHtml(div,"<br><img src = 'images/sceneIcons/shenanigans_icon.png'>"+this.content());
	}

	@override
	bool trigger(playerList){
		this.player = null;
		this.playerList = playerList;
		this.findSufficientPlayer();
		return (this.player != null) && (	!this.session.npcHandler.jack.exiled && this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) > 0 && 	this.session.npcHandler.jack.getStat(Stats.POWER) < 300); //if he's too strong, he'll just show you his stabs. give up
	}
	dynamic spyContent(){
		String ret = "The " + this.player.htmlTitle() + " performs a daring spy mission,";
		if(this.player.getStat(Stats.POWER) > 	this.session.npcHandler.king.getStat(Stats.POWER)/100){
			this.session.npcHandler.jack.addStat(Stats.POWER, -15);
			ret += " gaining valuable intel to use against Jack Noir. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}
	dynamic assasinationContent(){
		String ret = "The " + this.player.htmlTitle() + " performs a daring assasination mission against one of Jack Noir's minions,";
		if(this.player.getStat(Stats.POWER) > 	this.session.npcHandler.king.getStat(Stats.POWER)/100){
			this.session.npcHandler.jack.addStat(Stats.POWER, -30);
			ret += " losing him a valuable ally. ";
		}else{
			ret += " but hilariously bungles it. ";
		}
		return ret;
	}
	dynamic harrassContent(){
		String ret = "The " + this.player.htmlTitle() + " makes a general nuisance of themselves to Jack Noir, but in a deniable way. ";
		this.session.npcHandler.jack.addStat(Stats.POWER, -10);
		return ret;
	}
	dynamic content(){
		this.player.increasePower();
		session.removeAvailablePlayer(player);
		var r = rand.nextDouble();
		if(r > .3){
			return this.harrassContent();
		}else if(r > .6){
			return this.spyContent();
		}else{
			return this.assasinationContent();
		}
	}

}
