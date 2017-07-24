part of SBURBSim;



//if jack is much stronger than a player, insta-kills them.
//can fight 0 or more players at once. (if zero, he just kills nonplayers.)
//total playerStrength must be at least half of his to survive.
class JackRampage extends Scene{
	bool canRepeat = true;


	JackRampage(Session session): super(session);


	@override
	bool trigger(playerList){
		//print("Jack is: " + this.session.jackStrength  + " and King is: " + this.session.kingStrength);
		return this.session.jack.crowned != null && this.session.jack.getStat("currentHP") > 0 && !this.session.jack.dead; //Jack does not stop showing us his stabs.
	}
	dynamic getStabList(){
		List<dynamic> potentialPlayers = [];
		for(num i = 0; i<this.session.availablePlayers.length; i++){
			var p = this.session.availablePlayers[i];
			if(p.class_name != "Witch"){
				potentialPlayers.add(p); //don't make a big deal out of it, but jack doesn't want to hurt the witch. familiar loyalty, yo.
				//this is actually a bad thing, too, cause it means the witch's OP sprite doesn't get to kick Jack's ass.
			}
		}
		var numStabbings = getRandomInt(1,Math.min(4,potentialPlayers.length));
		//print("Number stabbings is: " + numStabbings);
		List<dynamic> ret = [];
		if(potentialPlayers.length == 0){
			return ret;
		}
		ret.add(getRandomElementFromArray(potentialPlayers)); //used to get slowest player, but too many perma deaths happened.
		var friends = ret[0].getFriendsFromList(potentialPlayers);
		if(friends.length == 0) return ret;
		//print("friends: " + friends.length);
		for(int i = 0; i<=numStabbings; i++){
			var f = getRandomElementFromArray(friends);
			//print(f);
			if(this.canCatch(f)) ret.add(f);

		}
		//var unique = Array.from(new Set(ret));  breaks IE because IE is a whiny little bitch.
		//var unique = [...new Set(ret)]  ;//IE ALSO bitches about this. Fucking IE.  I think it doesn't implement Sets. What the actual fuck.;
    Set<Player> unique = new Set<Player>.from(ret);

		 ret = []; //add some sprites. this is literally the only other fight they are good for.
		for(Player g in unique){
			ret.add(g);
			ret.add(g.sprite);
			if(g.sprite.name == "sprite") print("trying to stab somebody not in the medium yet in session: " + this.session.session_id.toString());
		}
		return ret;
	}
	bool canCatch(Player victim){
			if(this.session.jack.getStat("mobility") < victim.getStat("mobility")) return false;
			if(victim.aspect == "Void" && victim.isVoidAvailable() && victim.getStat("power") >50) return false;
			if(victim.aspect == "Space" && victim.getStat("power") > 50){
				print("high level space player avoiding jack" + this.session.session_id.toString());
				return false;  //god tier calliope managed to hide from a Lord of Time. space players might not move around a lot, but that doesn't mean they are easy to catch.
			}
			print("jack found a stab victim" + this.session.session_id.toString());
		return true;
	}
	void renderPrestabs(div, stabbings){
			num repeatTime = 1000;
			var divID = (div.attr("id")) + "_final_boss";
			var ch = canvasHeight;

			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth.toString() + "' height;="+ch + "'>  </canvas>";
			//div.append(canvasHTML);  //no. not if sprites can be here.
			//different format for canvas code
			var canvasDiv = querySelector("#canvas"+ divID);
			//poseAsATeam(canvasDiv, stabbings, 2000); //can't do this anymore, mighit be  a sprite in there.
		}
	@override
	void renderContent(div){
		this.session.jackRampage = true;
		//div.append("<br>"+this.content());
		div.append("<br><img src = 'images/sceneIcons/jack_icon.png'> ");

		//jack finds 0 or more players.
		var stabbings = this.getStabList();
	//	if(stabbings.length > 1) print("Jack fighting more than one player: " + this.session.session_id);
		String ret = "";
		if(stabbings.length == 0){
			if(seededRandom() > .5){
				ret += " Jack listlessly shows his stabs to a few Prospitian pawns. ";
				div.append(""+ret);
			}else{
				ret += " Jack listlessly shows his stabs to a few Dersite pawns. ";
				div.append(""+ret);
			}
			ret += " Bored of this, he decides to show his stabs to BOTH the Black and White Kings.  The battle is over. The Reckoning will soon start.";
			this.session.timeTillReckoning = 0;
			this.session.king.setStat("currentHP",-99999999);
			this.session.king.dead = true;
			print("jack starts reckoning " + this.session.session_id.toString());
			div.append(""+ret);
		}else{


			if(stabbings[0].dreamSelf && !stabbings[0].isDreamSelf && seededRandom() >.5){
				//jack kills the dream self instead of the active self. no strife. just death.
				//want to test out a dream self dying without active.
				//print("jack kills nonactive dream self: " + this.session.session_id);
				ret = "Jack has found the dream self of the " + stabbings[0].htmlTitleBasic() + ". He shows the sleeping body his stabs. The dream self is no longer available for revival shenanigans. ";
				div.append(""+ret);
				stabbings[0].dreamSelf = false;
				var snop = Player.makeRenderingSnapshot(stabbings[0]);
				snop.causeOfDeath = "after being sleep stabbed by Jack";
				snop.isDreamSelf = true;
				this.session.afterLife.addGhost(snop);
			}else{
				this.setPlayersUnavailable(stabbings);
				ret = "Jack has caught the " + getPlayersTitlesBasic(stabbings) + ".  Will he show them his stabs? Strife!";
				div.append(""+ret);
				this.renderPrestabs(div, stabbings); //pose as a team BEFORE getting your ass handed to you.
				Team pTeam = new Team(this.session, stabbings);
				Team dTeam = new Team(this.session, [this.session.jack]);
				Strife strife = new Strife(this.session, [pTeam, dTeam]);
				strife.startTurn(div);
		}
			return;//make sure text is over image
		}

	}
	void setPlayersUnavailable(stabbings){
		for(num i = 0; i<stabbings.length; i++){
			removeFromArray(stabbings[i], this.session.availablePlayers);
		}
	}
	dynamic addImportantEvent(players){//TODO reimplement this for boss fights
		/*
		var current_mvp = findStrongestPlayer(this.session.players);
		for(num i = 0; i<players.length; i++){
			var player = players[i];
			if(player.isDreamSelf == true && player.godDestiny == false && player.godTier == false){
				return this.session.addImportantEvent(new PlayerDiedForever(this.session, current_mvp.power,player) );
			}
		}
		*/

	}

}
