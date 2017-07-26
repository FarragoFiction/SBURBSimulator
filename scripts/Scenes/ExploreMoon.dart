part of SBURBSim;


class ExploreMoon extends Scene {
	bool canRepeat = true;
	var player1 = null;
	var player2 = null; //optional

	


	ExploreMoon(Session session): super(session);

	@override
	dynamic checkPlayer(player) {
		this.player1 = player;
		if (this.player1.dreamSelf ==
				false) { //can't explore a moon without a dream self.
			this.player1 = null;
			return null;
		}
	}

		String getProspitBullshit(){
			var possibilities = ["attending dance parties", "fluttering about aimlessly", "chatting up Prospitans", "learning the recipe for HOLY PASTRIES", "listening to sermons on the vast Croak","attending dance offs", "protecting the sacred candy shop from burglars", "racing frogs"];
			var thing1 = rand.pickFrom(possibilities);
			removeFromArray(thing1,possibilities);
			var thing2 = rand.pickFrom(possibilities);


			String vision = "The visions of the future provided by Skaia were largely ignored.";
			//have different vision based on predicted results. player power >> king power, predict success. player power << king, predict failure.
			var dead = findDeadPlayers(this.session.players);
			var living = findLivingPlayers(this.session.players);

			if(dead.length > 0) vision = "What is that cloud showing? Is that...grub sauce? Please be grub sauce." ;//the dead won't be rare. replace this if at all possible.;
			if(this.session.timeTillReckoning < 3 && getAveragePower(living)>this.session.king.getStat("currentHP")*2) vision = "Wow, everybody sure looks happy in that cloud. Maybe things will turn out after all?";
			if(this.session.timeTillReckoning < 3 && this.session.king.getStat("power")> getAverageHP(living) * 2) vision = "Um...Huh. That's. That's a lot of dead bodies. What's...what's going on in that cloud there?";
			if(this.player1.grimDark > 2 || (this.player2 && this.player2.grimDark > 0)) vision = "Skaia's clouds are dark. " ;//final option. no visions for grim dark players.;

			return "whimsical Prospit activities, such as " + thing1 + " and " + thing2 + ". " + vision;
		}

		String getDerseBullshit(){
			var possibilities = ["attending dance parties", "cheating at poker", "keeping tabs on the lifeblood of Derse", "learning the Derse waltz","understanding the nuances of a stab","lying their asses off to anyone and everyone","attending jazz clubs","setting up black market businesses","dodging the Derse law","smuggling contraband","delivering finely crafted suits"];
			var thing1 = rand.pickFrom(possibilities);
			removeFromArray(thing1, possibilities);
			var thing2 = rand.pickFrom(possibilities);

			var dead = findDeadPlayers(this.session.players);
			var living = findLivingPlayers(this.session.players);


			String whisper = "The whisperings of the HorrorTerrors provided a nice backdrop.";
			if(dead.length > 0) whisper = "...so, THAT's what it sounds like when a horrorterror laughs. Good to know." ;//the dead won't be rare. replace this if at all possible.;
			if(this.session.timeTillReckoning < 3 && this.session.king.getStat("power")> getAverageHP(living) * 2) whisper = "Oh god, did the Horrorterrors get LOUDER!?";
			if(this.player1.aspect == "Void" || (this.player2 != null && this.player2.aspect == "Void")) whisper = "The Horrorterrors are strangely quiet, their whisperings strained, like someone trying to speak through a broken speaker.";
			if(this.player1.grimDark > 0 || (this.player2 != null && this.player2.grimDark > 0)) whisper = "The Horrorterrors whisperings call to them. ";

			return "whimsical Derse activities, such as " + thing1 + " and " + thing2 + ". " + whisper;
		}



	@override
	void renderContent(Element div){
		if(this.player1.moon == "Prospit")appendHtml(div,"<br><img src = 'images/sceneIcons/prospit_icon.png'> ");
		if(this.player1.moon == "Derse")appendHtml(div,"<br><img src = 'images/sceneIcons/derse_icon.png'> ");
    appendHtml(div,this.content());
	}

	@override
	bool trigger(playerList){
		this.player1 = null; //reset
		this.player2 = null;
		for(num i = 0; i<this.session.availablePlayers.length; i++){
			this.checkPlayer(this.session.availablePlayers[i]);
			if(this.player1 != null){
				return true;
			}
		}
		if(this.player1 == null || this.session.availablePlayers.length == 0){
			return false;
		}
		return true;
	}
	//TODO get rid of this, don't need it anymore.
	void checkBloodBoost(){
		if(this.player1.aspect == "Blood" && this.player2 != null){
			this.player2.boostAllRelationships();
		}

		if(this.player2!=null && this.player2.aspect == "Blood"){
			this.player1.boostAllRelationships();
		}
	}
	dynamic content(){
		String ret = "";
		//remove player1 and player2 from available player list.
		removeFromArray(this.player1, this.session.availablePlayers);
		removeFromArray(this.player2, this.session.availablePlayers);
		//print(this.player1.title() + " is doing moon stuff with their land level at: " + this.player1.landLevel)
		var r1 = null;
		var r2 = null;
		this.player1.increasePower();
		if(this.player2 != null){
			this.player2.increasePower();
			this.player1.interactionEffect(this.player2);
			this.player2.interactionEffect(this.player1);
		}

		this.checkBloodBoost();

		ret += "The " + this.player1.htmlTitle();
		if(this.player2 != null){
			ret += " and the " + this.player2.htmlTitle() + " do ";
		}else{
			ret += " does ";
		}
		if(this.player1.moon == "Prospit"){
			ret += getProspitBullshit();
		}else{
			ret += getDerseBullshit();
			this.player1.corruptionLevelOther += 3;
			if(this.player2 != null) this.player2.corruptionLevelOther += 3;
		}

		if(this.player2 != null){
			var r1 = this.player1.getRelationshipWith(this.player2);
			var r2 = this.player2.getRelationshipWith(this.player1);
			if(r1.type() == " Totally In Love" && r2.type() == "Totally In Love"){
				ret += " The two flirt a bit. ";
			}else if(r2.type() == "Totally In Love"){
				ret += " The" + this.player2.htmlTitle() + " is flustered around the " + this.player1.htmlTitle();
			}else if(r1.type() == "Totally In Love"){
				ret += " The" + this.player1.htmlTitle() + " is flustered around the " + this.player2.htmlTitle();
			}else if(r1.type() == "Rivals" && r2.type() == "Rivals"){
				ret += " The two compete to see who can solve more puzzles. ";
			}else if(r2.type() == "Rivals"){
				ret += this.player2.htmlTitle() + " is irritable around the " + this.player1.htmlTitle() + ". ";
			}else if(r1.type() == "Rivals"){
				ret += " The" + this.player1.htmlTitle() + " is irritable around " + this.player2.htmlTitle();
			}
		}

		if(this.player2 != null && this.player2.grimDark>0){
			this.player1.corruptionLevelOther += 25;
			ret += " The corruption is spreading. ";
		}

		if(this.player2 != null && this.player1.grimDark>0){
			this.player2.corruptionLevelOther += 25;
			print("spreading corruption in: "  + this.session.session_id.toString());
			ret += " The corruption is spreading. ";
		}
		return ret;
	}


}

