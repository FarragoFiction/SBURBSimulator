import "dart:html";
import "../SBURBSim.dart";


class GiveJackBullshitWeapon extends Scene {
  bool canRepeat = false;

	GiveJackBullshitWeapon(Session session): super(session, false);

	@override
	bool trigger(playerList){
		this.playerList = playerList;
		var partyRoll = partyRollForLuck(this.session.players);
		var jackRoll = this.session.npcHandler.jack.rollForLuck();
		//if(partyRoll< jackRoll) //session.logger.info("We rolled: " + partyRoll + " jack rolled: " + jackRoll);
		return (!this.session.npcHandler.queen.exiled && !this.session.npcHandler.jack.exiled && this.session.npcHandler.jack.crowned == null) && (this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) > 0 && partyRoll < jackRoll );
	}
	dynamic content(){
		this.session.stats.jackGotWeapon = true;


		String ret = " Jack Noir is tired of putting up with the STUPID LOUSY WISE AND JUST LEADER, what a royal pain in the ass. ";
		ret += " It's bad enough she makes him handle every single piece of paperwork in all of Derse, does she really need to rub salt in his wounds and make him dress up in frivolous outfits as well?";
		ret += " So, it's no surprise that Jack murders the Black Queen the second he finds a Legendary weapon amongst the confiscated packages of Prospit. ";
		this.session.npcHandler.queen.setStat(Stats.CURRENT_HEALTH,-9999999999); //not even ring can keep her alive.
		this.session.npcHandler.queen.dead = true;
		return ret;
	}

	@override
	void renderContent(Element div){
		appendHtml(div,"<br><img src = 'images/sceneIcons/jack_icon.png'> "+this.content());
	}

}
