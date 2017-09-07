import "dart:html";
import "dart:math" as Math;
import "../SBURBSim.dart";



//if jack is much stronger than a player, insta-kills them.
//can fight 0 or more players at once. (if zero, he just kills nonplayers.)
//total playerStrength must be at least half of his to survive.
class JackRampage extends Scene{


	JackRampage(Session session): super(session);


	@override
	bool trigger(List<Player> playerList){
		////session.logger.info("Jack is: " + this.session.jackStrength  + " and King is: " + this.session.kingStrength);
		return this.session.npcHandler.jack.crowned != null && this.session.npcHandler.jack.getStat(Stats.CURRENT_HEALTH) > 0 && !this.session.npcHandler.jack.dead; //Jack does not stop showing us his stabs.
	}
	List<GameEntity> getStabList(){
		List<Player> potentialPlayers = [];
		for(Player p in session.getReadOnlyAvailablePlayers()){
			if(p.class_name != SBURBClassManager.WITCH){
				potentialPlayers.add(p); //don't make a big deal out of it, but jack doesn't want to hurt the witch. familiar loyalty, yo.
				//this is actually a bad thing, too, cause it means the witch's OP sprite doesn't get to kick Jack's ass.
			}
		}
		int numStabbings = rand.nextIntRange(1,Math.min(4,potentialPlayers.length));
		////session.logger.info("Number stabbings is: " + numStabbings);
		List<GameEntity> ret = [];
		if(potentialPlayers.length == 0){
			return ret;
		}
		ret.add(rand.pickFrom(potentialPlayers)); //used to get slowest player, but too many perma deaths happened.
		List<Player> friends = ret[0].getFriendsFromList(potentialPlayers);
		if(friends.length == 0) return ret;
		////session.logger.info("friends: " + friends.length);
		for(int i = 0; i<=numStabbings; i++){
			Player f = rand.pickFrom(friends);
			////session.logger.info(f);
			if(this.canCatch(f)) ret.add(f);

		}
		//var unique = Array.from(new Set(ret));  breaks IE because IE is a whiny little bitch.
		//var unique = [...new Set(ret)]  ;//IE ALSO bitches about this. Fucking IE.  I think it doesn't implement Sets. What the actual fuck.;
        Set<GameEntity> unique = new Set<GameEntity>.from(ret);

		ret = []; //add some sprites. this is literally the only other fight they are good for.
		for(Player g in unique){
			ret.add(g);
			ret.add(g.sprite);
			//if(g.sprite.name == "sprite") //session.logger.info("trying to stab somebody not in the medium yet in session: " + this.session.session_id.toString());
		}
		return ret;
	}
	bool canCatch(Player victim){
			if(this.session.npcHandler.jack.getStat(Stats.POWER) < victim.getStat(Stats.POWER)) return false;
			if(victim.aspect == Aspects.VOID && victim.isVoidAvailable() && victim.getStat(Stats.POWER) >50) return false;
			if(victim.aspect == Aspects.SPACE && victim.getStat(Stats.POWER) > 50){
				////session.logger.info("high level space player avoiding jack" + this.session.session_id.toString());
				return false;  //god tier calliope managed to hide from a Lord of Time. space players might not move around a lot, but that doesn't mean they are easy to catch.
			}
			////session.logger.info("jack found a stab victim" + this.session.session_id.toString());
		return true;
	}
	void renderPrestabs(Element div, List<GameEntity> stabbings){
			//num repeatTime = 1000;
			//var divID = (div.id) + "_final_boss";
			//var ch = canvasHeight;

			//String canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth.toString() + "' height='"+ch + "'>  </canvas>";
			//div.append(canvasHTML);  //no. not if sprites can be here.
			//different format for canvas code
			//var canvasDiv = querySelector("#canvas"+ divID);
			//poseAsATeam(canvasDiv, stabbings, 2000); //can't do this anymore, mighit be  a sprite in there.
		}
	@override
	void renderContent(Element div){
		this.session.stats.jackRampage = true;
		//div.append("<br>"+this.content());
		appendHtml(div,"<br><img src = 'images/sceneIcons/jack_icon.png'> ");

		//jack finds 0 or more players.
		List<GameEntity> stabbings = this.getStabList();
	//	if(stabbings.length > 1) //session.logger.info("Jack fighting more than one player: " + this.session.session_id);
		String ret = "";
		if(stabbings.length == 0){
			if(rand.nextDouble() > .5){
				ret += " Jack listlessly shows his stabs to a few Prospitian pawns. ";
            appendHtml(div,""+ret);
			}else{
				ret += " Jack listlessly shows his stabs to a few Dersite pawns. ";
            appendHtml(div,""+ret);
			}
			ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start.";
			this.session.timeTillReckoning = 0;
			this.session.npcHandler.king.setStat(Stats.CURRENT_HEALTH,-99999999);
			this.session.npcHandler.king.dead = true;
			//session.logger.info("jack starts reckoning " + this.session.session_id.toString());
        appendHtml(div,""+ret);
		}else{

			Player stabbee = stabbings[0] is Player ? stabbings[0] : null;

			if(stabbee != null && stabbee.dreamSelf && !stabbee.isDreamSelf && rand.nextDouble() >.5){
				//jack kills the dream self instead of the active self. no strife. just death.
				//want to test out a dream self dying without active.
				////session.logger.info("jack kills nonactive dream self: " + this.session.session_id);
				ret = "Jack has found the dream self of the " + stabbee.htmlTitleBasic() + ". He shows the sleeping body his stabs. The dream self is no longer available for revival shenanigans. ";
        appendHtml(div,""+ret);
				stabbee.dreamSelf = false;
				var snop = Player.makeRenderingSnapshot(stabbee);
				snop.causeOfDeath = "after being sleep stabbed by Jack";
				snop.isDreamSelf = true;
				this.session.afterLife.addGhost(snop);
			}else{
				this.setPlayersUnavailable(stabbings);
				ret = "Jack has caught the " + getPlayersTitlesBasic(stabbings) + ".  Will he show them his stabs? Strife!";
        appendHtml(div,""+ret);
				this.renderPrestabs(div, stabbings); //pose as a team BEFORE getting your ass handed to you.
				Team pTeam = new Team.withName("The Players",this.session, stabbings);
				Team dTeam = new Team(this.session, [this.session.npcHandler.jack]);
				Strife strife = new Strife(this.session, [pTeam, dTeam]);
				strife.startTurn(div);
		}
			return;//make sure text is over image
		}

	}
	void setPlayersUnavailable(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			session.removeAvailablePlayer(stabbings[i]);
		}
	}
	ImportantEvent addImportantEvent(players){//TODO reimplement this for boss fights
		/*
		var current_mvp = findStrongestPlayer(this.session.players);
		for(num i = 0; i<players.length; i++){
			var player = players[i];
			if(player.isDreamSelf == true && player.godDestiny == false && player.godTier == false){
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.getStat(Stats.POWER),player) );
			}
		}
		*/
		return null;
	}

}
