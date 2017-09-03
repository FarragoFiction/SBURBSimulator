import "dart:html";
import "../SBURBSim.dart";


//if i am page or blood player, can't do this alone.

class SolvePuzzles extends Scene {
	Player player1 = null;
	Player player2 = null; //optional


	


	SolvePuzzles(Session session): super(session);


	void checkPlayer(Player player){
		if(rand.nextBool()) {
			this.player1 = player;
			this.player2 = player.findHelper(session.getReadOnlyAvailablePlayers());
		}


	}
	@override
	bool trigger(List<Player> playerList){
		this.player1 = null; //reset
		this.player2 = null;
		List shuffledPlayers = shuffle(rand, new List<Player>.from(session.getReadOnlyAvailablePlayers()));
		for(Player p in shuffledPlayers){
			this.checkPlayer(p);
			if(this.player1 != null && this.player1.land != null){
				return true;
			}
		}
		if(this.player1 == null || this.session.getReadOnlyAvailablePlayers().length == 0 || this.player1.land == null){
			return false;
		}
		return true;


	}

	String getBullshitQuest(){
		//if i stored this in random tables like my old stuff (this is may 2017, btw), then i couldn't avoid repeats as easily as i am here.
		//remember kids: design and architecture really do fucking matter.
			String landChosen = this.player1.land1;
			if(rand.nextDouble() > 0.5) landChosen = this.player1.land2;
			//shits on adventure game tropes and just uses a cheat code to solve the puzzle (star.eyes from discorse)
			List<String> possibilities = ["learning the true meaning of " + landChosen,"learning to really hate the entire concept of " + landChosen,"getting really fucking sick of " + landChosen,  "getting coy hints about The Ultimate Riddle","shitting on adventure game tropes and just using a cheat code","killing underlings","delving into dungeons", "exploring ruins", "solving puzzles", "playing minigames", "learning about the lore"];
			String thing1 = rand.pickFrom(possibilities);
			removeFromArray(thing1,possibilities);
			String thing2 = rand.pickFrom(possibilities);
			return "random bullshit sidequests at " + this.player1.shortLand() + ", " + thing1 + " and " + thing2 + ". ";
	}

	@override
	void renderContent(Element div){
		////session.logger.info("Ultimate Riddle for Player with power of: " + this.player1.getStat("power") + " and land level of: " + this.player1.landLevel + " " + this.player1);
		appendHtml(div, "<br> <img src = 'images/sceneIcons/sidequest_icon.png'> "+this.content());
	}
	String spreadCoruption(Player player1, Player player2){
		bool ret = false;
		if(player2 != null && player2.grimDark>0){
			player1.corruptionLevelOther += 5;
			ret = true;
		}

		if(player2 != null && player1.grimDark>0){
			player2.corruptionLevelOther += 5;
			ret = true;
		}

		if(corruptedOtherLandTitles.indexOf(player1.land1) != -1 || corruptedOtherLandTitles.indexOf(player1.land2) != -1 ){
			player1.corruptionLevelOther += 3;
			if(player2 != null) player2.corruptionLevelOther += 3;
			ret = true;
		}

		if(ret != null){
		//	//session.logger.info("Spreading corruptin in: " + this.session.session_id);
			return "The corruption is spreading.";
		}
		return "";

	}
	String content(){
		////session.logger.info("Solving puzzles at: " + this.player1.land);
		String ret = "";
		//remove player1 and player2 from available player list.
		session.removeAvailablePlayer(player1);
		session.removeAvailablePlayer(player2);
		//Relationship r1 = null;
		//Relationship r2 = null;
		List<Player> living = findLivingPlayers(this.session.players);
		List<Player> dead = findDeadPlayers(this.session.players);
		if(living.length == 1 && dead.length > 2){  //less of a reference if it's just one dead dude.
			//session.logger.info("SWEET BIKE STUNTS, BRO: " + this.session.session_id.toString());
			String realSelf = "";
			if(!this.player1.isDreamSelf && !this.player1.godTier){
				//session.logger.info("Real self stunting in: " + this.session.session_id.toString());
				realSelf =  "You are duly impressed that they are not a poser who does dreamself stunting.  Realself stunting 5ever, bro.";
			}
			return "The " +  this.player1.htmlTitle()  + " is "+ rand.pickFrom(bike_quests) + "." + realSelf;
		}
		this.player1.increasePower();
		this.player1.increaseGrist();
		if(this.player2 != null &&  this.player1  != this.player2){  //could be a time double, don't have a relationship with a time double (it never works out)
			this.player2.increasePower();
			this.player2.increaseGrist();
			ret += this.player1.interactionEffect(this.player2);
			ret += this.player2.interactionEffect(this.player1);
		}

		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null && (this.player2.aspect != this.player1.aspect ||this.player2.aspect == Aspects.TIME)){ //seriously, stop having clones of non time players!!!!
			ret += " and the " + this.player2.htmlTitle() + " do ";
		}else{
			ret += " does ";
		}
		ret += this.getBullshitQuest();

		ret += this.spreadCoruption(this.player1, this.player2);
		return ret;
	}



}
