part of SBURBSim;


//if i am page or blood player, can't do this alone.

class SolvePuzzles extends Scene {
	Player player1 = null;
	Player player2 = null; //optional


	


	SolvePuzzles(Session session): super(session);


	void checkPlayer(Player player){
		this.player1 = player;
		this.player2 = null;
		if(player.aspect == "Blood" || player.class_name == "Page"){
			if(this.session.availablePlayers.length > 1){
				this.player2 = rand.pickFrom(this.session.availablePlayers);
				if(this.player2 == this.player1 && this.player2.aspect != "Time"){
					this.player1 = null;
					this.player2 = null;
					return;
				}

			}else{
				this.player1 = null;
				return;
			}
		}

		//if i'm not blood or page, random roll for a friend.
		if(this.session.availablePlayers.length > 1 && rand.nextDouble() > .5){
			this.player2 = findHighestMobilityPlayer(this.session.availablePlayers);
			if(this.player2 == this.player1 && this.player1.aspect != "Time"){  //only time player can help themselves out.
				this.player2 == null;
			}
		}

	}
	@override
	bool trigger(List<Player> playerList){
		this.player1 = null; //reset
		this.player2 = null;
		for(num i = 0; i<this.session.availablePlayers.length; i++){
			this.checkPlayer(this.session.availablePlayers[i]);
			if(this.player1 != null && this.player1.land != null){
				return true;
			}
		}
		if(this.player1 == null || this.session.availablePlayers.length == 0 || this.player1.land == null){
			return false;
		}
		return true;


	}
	void checkBloodBoost(){ //TODO seriously rip this out
		if(this.player1.aspect == "Blood" && this.player2 != null){
			this.player2.boostAllRelationships();
		}

		if(this.player2!=null && this.player2.aspect == "Blood"){
			this.player1.boostAllRelationships();
		}
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
		//print("Ultimate Riddle for Player with power of: " + this.player1.getStat("power") + " and land level of: " + this.player1.landLevel + " " + this.player1);
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
		//	print("Spreading corruptin in: " + this.session.session_id);
			return "The corruption is spreading.";
		}
		return "";

	}
	String content(){
		//print("Solving puzzles at: " + this.player1.land);
		String ret = "";
		//remove player1 and player2 from available player list.
		removeFromArray(this.player1, this.session.availablePlayers);
		removeFromArray(this.player2, this.session.availablePlayers);
		//Relationship r1 = null;
		//Relationship r2 = null;
		List<Player> living = findLivingPlayers(this.session.players);
		List<Player> dead = findDeadPlayers(this.session.players);
		if(living.length == 1 && dead.length > 2){  //less of a reference if it's just one dead dude.
			print("SWEET BIKE STUNTS, BRO: " + this.session.session_id.toString());
			String realSelf = "";
			if(!this.player1.isDreamSelf && !this.player1.godTier){
				print("Real self stunting in: " + this.session.session_id.toString());
				realSelf =  "You are duly impressed that they are not a poser who does dreamself stunting.  Realself stunting 5ever, bro.";
			}
			return "The " +  this.player1.htmlTitle()  + " is "+ rand.pickFrom(bike_quests) + "." + realSelf;
		}
		this.player1.increasePower();
		if(this.player2 != null &&  this.player1  != this.player2){  //could be a time double, don't have a relationship with a time double (it never works out)
			this.player1.increasePower();
			this.player2.increasePower();
			this.player1.interactionEffect(this.player2);
			this.player2.interactionEffect(this.player1);
		}

		this.checkBloodBoost();

		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null && (this.player2.aspect != this.player1.aspect ||this.player2.aspect == "Time")){ //seriously, stop having clones of non time players!!!!
			ret += " and the " + this.player2.htmlTitle() + " do ";
		}else{
			ret += " does ";
		}
		ret += this.getBullshitQuest();

		ret += this.spreadCoruption(this.player1, this.player2);
		return ret;
	}



}
