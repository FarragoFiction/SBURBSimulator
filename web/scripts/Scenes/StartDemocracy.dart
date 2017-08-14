import "dart:html";
import "../SBURBSim.dart";


/*
  A war weary villan will approach certain types of players.
  Breath, Doom, Mind, Seer, Page, or Rogue

  They will ask for help overthrowing all Royalty.

  Players work to weaken and Exile Queen.

  During Reckoning, WarWeary Villain assembles and army to help fight King.

  During ending, if democracy = true, mention that.;
*/

class StartDemocracy extends Scene {
  bool canRepeat = false;
	var friend = null;	//blood or page or thief or rogue.
	


	StartDemocracy(Session session): super(session, false);


	dynamic findSympatheticPlayer(){
		this.friend =  findClassPlayer(this.session.availablePlayers, SBURBClassManager.ROGUE);
		if(this.friend == null || this.friend.land == null){
			this.friend =  findAspectPlayer(this.session.availablePlayers, "Hope");
		}

		if(this.friend == null || this.friend.land == null){
			return null;
		}
	}
	@override
	void renderContent(Element div){
		appendHtml(div, "<br> <img src = 'images/sceneIcons/wv_icon.png'> "+this.content());
	}
	@override
	bool trigger(playerList){
		this.playerList = playerList;
		if(this.session.king.getStat("currentHP") <= 0 ||this.session.queen.getStat("currentHP") <= 0){  //the dead can't scheme or be schemed against
			return false;
		}
		this.findSympatheticPlayer();

		return (this.session.democracyStrength <= 0 ) && this.session.king.getStat("power") >  this.session.hardStrength && (this.friend != null);
	}
	dynamic content(){
		this.friend.increasePower();
		removeFromArray(this.friend, this.session.availablePlayers);
		this.session.available_scenes.insert(0, new PrepareToExileQueen(session));  //make it top priority, so unshift, don't push
		this.session.available_scenes.insert(0, new ExileQueen(session));  //make it top priority, so unshift, don't push
		this.session.available_scenes.insert(0, new PowerDemocracy(session));  //make it top priority, so unshift, don't push

		String ret = " The " + this.friend.htmlTitle() + " is just minding their own business when they are approached by an adorable little Dersite. ";
		ret += " The Dersite introduces himself as a Warweary Villein hoping to recruit a Champion. ";
		ret += " He wishes to end this stupid war, caused by the excesses of the Monarchy. ";
		ret += " The Warweary Villein just hates the Monarchy.  They are petty, bossy tyrants and are really full of themselves and are basically awful in every way. ";
		ret += " The " + this.friend.htmlTitle() + " can't help but be persuaded by the adorable rant. Look at the little guy's clenched fists! ";
		ret += " A plan is hatched to exile the Queen, and the Dersite promises an army to help fight the King. ";
		this.session.democracyStrength += 50;
		return ret;
	}

}
