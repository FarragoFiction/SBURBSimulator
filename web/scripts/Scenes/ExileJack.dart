import "dart:html";
import "../SBURBSim.dart";


class ExileJack extends Scene{

	bool canRepeat = false;

	ExileJack(Session session): super(session, false);


	@override
	bool trigger(playerList){
		this.playerList = playerList;
		return (!this.session.npcHandler.jack.exiled && this.session.npcHandler.jack.getStat(Stats.POWER) < 10) && (this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) >  0 && this.session.npcHandler.jack.crowned == null);
	}
	@override
	void renderContent(Element div){
		appendHtml(div,"<br> <img src = 'images/sceneIcons/jack_icon.png'> "+this.content());
	}
	dynamic content(){
		this.session.npcHandler.jack.setStat(Stats.CURRENT_HEALTH,0); //effectively dead.
		this.session.npcHandler.jack.exiled = true;
		String ret = " The plan has been performed flawlessly.  Jack has been exiled to the post-Apocalyptic version of Earth before he can cause too much damage.";
		return ret;
	}

}
